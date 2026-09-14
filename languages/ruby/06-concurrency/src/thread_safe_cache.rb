# ---------- Thread-safe cache with Mutex ----------
puts "=== Thread-safe cache ==="

class ThreadSafeCache
  def initialize
    @data = {}
    @mutex = Mutex.new
  end

  def []=(key, value)
    @mutex.synchronize { @data[key] = value }
  end

  def [](key)
    @mutex.synchronize { @data[key] }
  end

  def key?(key)
    @mutex.synchronize { @data.key?(key) }
  end

  def size
    @mutex.synchronize { @data.size }
  end

  def clear
    @mutex.synchronize { @data.clear }
  end

  def fetch(key)
    return @data[key] if @data.key?(key)
    @mutex.synchronize do
      return @data[key] if @data.key?(key)
      @data[key] = yield(key)
    end
  end
end

cache = ThreadSafeCache.new

cache["greeting"] = "Hello"
cache["farewell"] = "Goodbye"
puts "  greeting: #{cache["greeting"]}"
puts "  farewell: #{cache["farewell"]}"
puts "  size: #{cache.size}"

cache.fetch("expensive_computation") do |key|
  puts "  Computing #{key}... (slow)"
  sleep(0.1)
  "result-for-#{key}"
end
puts "  expensive_computation: #{cache["expensive_computation"]}"

# ---------- Concurrent access stress test ----------
puts "\n=== Concurrent access stress test ==="

cache = ThreadSafeCache.new
success_count = 0
mutex = Mutex.new

threads = 10.times.map do |tid|
  Thread.new do
    50.times do |i|
      key = "key-#{tid}-#{i}"
      value = cache.fetch(key) do |k|
        sleep(0.001)
        "value-for-#{k}"
      end
      if value == "value-for-#{key}"
        mutex.synchronize { success_count += 1 }
      end
    end
  end
end
threads.each(&:join)

expected = 10 * 50
puts "  Expected successes: #{expected}"
puts "  Actual successes:   #{success_count}"
puts "  Cache size: #{cache.size}"
puts "  All correct: #{success_count == expected}"

# ---------- Lazy attribute initialization pattern ----------
puts "\n=== Lazy attribute initialization ==="

class LazyConfig
  def initialize
    @mutex = Mutex.new
    @loaded_config = nil
  end

  def config
    return @loaded_config if @loaded_config
    @mutex.synchronize do
      return @loaded_config if @loaded_config
      @loaded_config = load_config
    end
  end

  private

  def load_config
    puts "  Loading configuration from file..."
    sleep(0.1)
    {
      "database_url" => "postgres://localhost/mydb",
      "cache_ttl" => 3600,
      "max_connections" => 10
    }
  end
end

config = LazyConfig.new
c1 = config.config
puts "  Config loaded: #{c1.keys}"
c2 = config.config
puts "  Config from cache: #{c2.keys}"
puts "  Same object: #{c1.object_id == c2.object_id}"
