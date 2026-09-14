# Project 06: Concurrency — Ruby

**Difficulty:** intermediate-advanced  
**Prerequisites:** Project 04 (Error Handling), Project 05 (Testing)

## Goals

- Understand Ruby's concurrency model: threads, fibers, and process forking
- Use `Thread` for concurrent execution and understand the GIL (Global Interpreter Lock)
- Coordinate threads with `Mutex`, `ConditionVariable`, and `Queue`
- Use `Fiber` for lightweight cooperative concurrency
- Understand async programming patterns and when to use them
- Avoid common concurrency pitfalls: race conditions, deadlocks, thread safety
- Explore the Ruby standard library's concurrent-aware classes

## Concepts

- **`Thread`** — OS-level thread; Ruby threads are native threads but subject to the GIL in MRI, meaning only one thread executes Ruby code at a time; I/O operations release the GIL, so threads are useful for I/O-bound concurrency
- **GIL (Global Interpreter Lock)** — in MRI Ruby, only one thread can execute Ruby bytecode at a time; this makes Ruby thread-safe for most operations but means CPU-bound Ruby code doesn't benefit from multiple cores; use `Process.fork` or a different Ruby implementation (JRuby, TruffleRuby) for true parallelism
- **`Mutex`** — mutual exclusion lock; ensures only one thread can execute a critical section at a time; use `synchronize { ... }` to protect shared mutable state
- **`ConditionVariable`** — allows threads to wait for a condition to become true; used with a `Mutex` for producer-consumer patterns
- **`Queue`** — thread-safe queue; `push`/`<<` to add, `pop`/`shift` to remove (blocks if empty by default); `close` to signal no more items; suitable for producer-consumer and work-queue patterns
- **`Fiber`** — lightweight cooperative coroutine; fibers yield control explicitly with `Fiber.yield` and resume with `Fiber.resume`; multiple fibers can run on one thread; useful for async I/O and generator patterns
- **`Fiber.schedule`** (Ruby 3.0+) — the fiber scheduler interface; when a fiber scheduler is installed, blocking operations (I/O, sleep, etc.) automatically yield the fiber instead of blocking the thread, enabling async-like behavior with synchronous-looking code
- **`Process.fork`** — creates a child process (true parallelism, separate memory space); use with `IO.pipe` or sockets for inter-process communication; be cautious with file descriptors and database connections after fork
- **`Thread#join`** / **`Thread#value`** — wait for a thread to finish; `join` blocks until done, `value` joins and returns the thread's last expression value
- **`Thread.abort_on_exception`** — when true (default in Ruby 2.5+), an unhandled exception in a thread kills the thread and re-raises in the main thread; set per-thread with `thread.abort_on_exception = true`
- **Race condition** — when the outcome depends on the timing of thread execution; occurs when multiple threads read/write shared mutable state without proper synchronization
- **Deadlock** — when two or more threads each hold a lock the other needs, and neither can proceed; avoid by consistent lock ordering and timeouts

## Exercises

### Exercise 1: Threads Basics — Creation, Joining, and Shared State

Create `src/threads_basics.rb`:

```ruby
# ---------- Creating and joining threads ----------
puts "=== Thread creation and joining ==="

thread1 = Thread.new do
  3.times do |i|
    puts "  Thread 1: iteration #{i}"
    sleep(0.1)
  end
  "Thread 1 done"
end

thread2 = Thread.new do
  3.times do |i|
    puts "  Thread 2: iteration #{i}"
    sleep(0.05)
  end
  "Thread 2 done"
end

puts "  Main thread: threads are running..."

result1 = thread1.value
result2 = thread2.value

puts "  #{result1}"
puts "  #{result2}"
puts "  Main thread: both threads finished"

# ---------- Thread-local variables ----------
puts "\n=== Thread-local variables ==="

threads = 5.times.map do |i|
  Thread.new do
    Thread.current[:thread_id] = i
    Thread.current[:data] = "Data for thread #{i}"
    sleep(0.02 * i)
    "Thread #{i}: id=#{Thread.current[:thread_id]}, data=#{Thread.current[:data]}"
  end
end

results = threads.map(&:value)
results.each { |r| puts "  #{r}" }

# ---------- Shared mutable state WITHOUT synchronization (race condition demo) ----------
puts "\n=== Race condition demonstration (unsynchronized) ==="

counter = 0
ITERATIONS = 100_000

threads = 4.times.map do
  Thread.new do
    ITERATIONS.times { counter += 1 }
  end
end
threads.each(&:join)

puts "  Expected: #{4 * ITERATIONS}"
puts "  Actual:   #{counter}"
puts "  Lost updates: #{4 * ITERATIONS - counter}"
puts "  (Results vary each run — this is the race condition)"

# ---------- Protecting shared state with Mutex ----------
puts "\n=== Protected with Mutex ==="

counter = 0
mutex = Mutex.new

threads = 4.times.map do
  Thread.new do
    ITERATIONS.times do
      mutex.synchronize { counter += 1 }
    end
  end
end
threads.each(&:join)

puts "  Expected: #{4 * ITERATIONS}"
puts "  Actual:   #{counter}"
puts "  Lost updates: #{4 * ITERATIONS - counter} (should be 0)"
```

**Expected output (abridged):**
```
=== Thread creation and joining ===
  Main thread: threads are running...
  Thread 1: iteration 0
  Thread 2: iteration 0
  Thread 1: iteration 1
  Thread 2: iteration 1
  Thread 2: iteration 2
  Thread 1: iteration 2
  Thread 1 done
  Thread 2 done
  Main thread: both threads finished

=== Thread-local variables ===
  Thread 0: id=0, data=Data for thread 0
  Thread 1: id=1, data=Data for thread 1
  Thread 2: id=2, data=Data for thread 2
  Thread 3: id=3, data=Data for thread 3
  Thread 4: id=4, data=Data for thread 4

=== Race condition demonstration (unsynchronized) ===
  Expected: 400000
  Actual:   287342
  Lost updates: 112658
  (Results vary each run — this is the race condition)

=== Protected with Mutex ===
  Expected: 400000
  Actual:   400000
  Lost updates: 0 (should be 0)
```

### Exercise 2: Producer-Consumer with Queue — Thread-safe Data Passing

Create `src/producer_consumer.rb`:

```ruby
# ---------- Simple producer-consumer with Queue ----------
puts "=== Producer-Consumer with Queue ==="

queue = Queue.new
SHUTDOWN_MSG = :shutdown
NUM_ITEMS = 10

producer = Thread.new do
  NUM_ITEMS.times do |i|
    item = "item-#{i}"
    queue << item
    puts "  Produced: #{item}"
    sleep(0.05)
  end
  queue << SHUTDOWN_MSG
  puts "  Producer done"
end

consumer = Thread.new do
  processed = []
  loop do
    item = queue.pop
    break if item == SHUTDOWN_MSG
    processed << item.upcase
    puts "  Consumed: #{item} -> #{item.upcase}"
    sleep(0.08)
  end
  puts "  Consumer done, processed #{processed.size} items"
  processed
end

producer.join
processed = consumer.value
puts "  All processed: #{processed.inspect}"

# ---------- Multiple producers, single consumer ----------
puts "\n=== Multiple producers, single consumer ==="

queue = Queue.new
NUM_PRODUCERS = 3
ITEMS_PER_PRODUCER = 5
mutex = Mutex.new
total_produced = 0

producers = NUM_PRODUCERS.times.map do |pid|
  Thread.new do
    ITEMS_PER_PRODUCER.times do |i|
      item = "p#{pid}-item-#{i}"
      queue << item
      mutex.synchronize { total_produced += 1 }
      sleep(0.03)
    end
  end
end

consumer = Thread.new do
  consumed = []
  remaining = NUM_PRODUCERS * ITEMS_PER_PRODUCER
  remaining.times do
    item = queue.pop
    consumed << item
    sleep(0.06)
  end
  consumed
end

producers.each(&:join)
consumed = consumer.value

puts "  Total produced: #{total_produced}"
puts "  Total consumed: #{consumed.size}"
puts "  All items uniquely consumed: #{consumed.uniq.size == consumed.size}"
puts "  First few: #{consumed.first(5).inspect}"

# ---------- Worker pool pattern ----------
puts "\n=== Worker pool pattern ==="

NUM_WORKERS = 3
TASK_COUNT = 10

def work(item)
  sleep(0.05)
  "#{item}-result"
end

queue = Queue.new
results = []
results_mutex = Mutex.new

workers = NUM_WORKERS.times.map do |wid|
  Thread.new do
    loop do
      item = queue.pop
      break if item == :shutdown
      result = work(item)
      results_mutex.synchronize { results << result }
    end
  end
end

TASK_COUNT.times { |i| queue << "task-#{i}" }
NUM_WORKERS.times { queue << :shutdown }
workers.each(&:join)

puts "  Submitted #{TASK_COUNT} tasks to #{NUM_WORKERS} workers"
puts "  Collected #{results.size} results"
puts "  Results: #{results.sort.inspect}"
```

**Expected output (abridged):**
```
=== Producer-Consumer with Queue ===
  Produced: item-0
  Consumed: item-0 -> ITEM-0
  Produced: item-1
  Consumed: item-1 -> ITEM-1
  ...
  Producer done
  Consumer done, processed 10 items
  All processed: ["ITEM-0", "ITEM-1", ..., "ITEM-9"]

=== Multiple producers, single consumer ===
  Total produced: 15
  Total consumed: 15
  All items uniquely consumed: true
  First few: ["p0-item-0", "p1-item-0", "p2-item-0", ...]

=== Worker pool pattern ===
  Submitted 10 tasks to 3 workers
  Collected 10 results
  Results: ["task-0-result", "task-1-result", ..., "task-9-result"]
```

### Exercise 3: Fibers — Cooperative Concurrency and Generators

Create `src/fibers.rb`:

```ruby
# ---------- Basic Fiber: yield and resume ----------
puts "=== Basic Fiber ==="

fiber = Fiber.new do |first|
  puts "  Fiber started, received: #{first}"
  second = Fiber.yield "yielded 1"
  puts "  Fiber resumed, received: #{second}"
  third = Fiber.yield "yielded 2"
  puts "  Fiber resumed, received: #{third}"
  "Fiber complete"
end

puts "  Initial resume with 'hello':"
result1 = fiber.resume("hello")
puts "  Fiber returned: #{result1}"

puts "  Second resume with 'world':"
result2 = fiber.resume("world")
puts "  Fiber returned: #{result2}"

puts "  Third resume with 'foo':"
result3 = fiber.resume("foo")
puts "  Fiber returned: #{result3}"

# ---------- Fiber as a generator (infinite sequence) ----------
puts "\n=== Fiber as generator: Fibonacci sequence ==="

def fibonacci_generator
  Fiber.new do
    a, b = 0, 1
    loop do
      Fiber.yield a
      a, b = b, a + b
    end
  end
end

fib = fibonacci_generator
first_10 = 10.times.map { fib.resume }
puts "  First 10 Fibonacci numbers: #{first_10.inspect}"

next_5 = 5.times.map { fib.resume }
puts "  Next 5: #{next_5.inspect}"

# ---------- Fiber with parameters on resume ----------
puts "\n=== Fiber with resume parameters ==="

processor = Fiber.new do |initial|
  accumulator = initial
  loop do
    value = Fiber.yield accumulator
    accumulator = value * 2
  end
end

puts "  Initial: #{processor.resume(1)}"
puts "  After x2: #{processor.resume(2)}"
puts "  After x2: #{processor.resume(3)}"
puts "  After x2: #{processor.resume(4)}"

# ---------- Multiple fibers, cooperative scheduling ----------
puts "\n=== Multiple fibers, cooperative scheduling ==="

def run_fibers(*fibers)
  fibers.each(&:resume)
end

f1 = Fiber.new do
  puts "  Fiber 1: step 1"
  Fiber.yield
  puts "  Fiber 1: step 2"
  Fiber.yield
  puts "  Fiber 1: step 3"
end

f2 = Fiber.new do
  puts "  Fiber 2: step 1"
  Fiber.yield
  puts "  Fiber 2: step 2"
  Fiber.yield
  puts "  Fiber 2: step 3"
end

puts "  Round 1:"
run_fibers(f1, f2)
puts "  Round 2:"
run_fibers(f1, f2)
puts "  Round 3:"
run_fibers(f1, f2)

# ---------- Fiber scheduler basics (Ruby 3.0+) ----------
puts "\n=== Fiber scheduler note ==="
puts "  Ruby 3.0+ supports Fiber.schedule for async I/O."
puts "  Install a scheduler with Fiber.set_scheduler(Async::Scheduler.new)"
puts "  Then blocking operations like sleep, IO.read, etc. automatically"
puts "  yield the fiber instead of blocking the thread."
puts "  This enables async-style code with synchronous-looking syntax."
puts "  See the async gem: gem install async"
```

**Expected output (abridged):**
```
=== Basic Fiber ===
  Initial resume with 'hello':
  Fiber started, received: hello
  Fiber returned: yielded 1
  Second resume with 'world':
  Fiber resumed, received: world
  Fiber returned: yielded 2
  Third resume with 'foo':
  Fiber resumed, received: foo
  Fiber returned: Fiber complete

=== Fiber as generator: Fibonacci sequence ===
  First 10 Fibonacci numbers: [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
  Next 5: [55, 89, 144, 233, 377]

=== Fiber with resume parameters ===
  Initial: 1
  After x2: 2
  After x2: 3
  After x2: 4

=== Multiple fibers, cooperative scheduling ===
  Round 1:
  Fiber 1: step 1
  Fiber 2: step 1
  Round 2:
  Fiber 1: step 2
  Fiber 2: step 2
  Round 3:
  Fiber 1: step 3
  Fiber 2: step 3

=== Fiber scheduler note ===
  Ruby 3.0+ supports Fiber.schedule for async I/O.
  ...
```

### Exercise 4: Thread Safety Patterns — Thread-safe Cache and Lazy Initialization

Create `src/thread_safe_cache.rb`:

```ruby
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

  # ---------- Double-checked locking for lazy initialization ----------
  def fetch(key)
    # Fast path: check without lock (may have stale read, but safe)
    return @data[key] if @data.key?(key)
    # Slow path: acquire lock and check again
    @mutex.synchronize do
      return @data[key] if @data.key?(key)
      @data[key] = yield(key)
    end
  end
end

cache = ThreadSafeCache.new

# Single-threaded usage
cache["greeting"] = "Hello"
cache["farewell"] = "Goodbye"
puts "  greeting: #{cache["greeting"]}"
puts "  farewell: #{cache["farewell"]}"
puts "  size: #{cache.size}"

# Thread-safe lazy initialization
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
        sleep(0.001)  # simulate expensive computation
        "value-for-#{k}"
      end
      # Verify the value was stored correctly
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

# First call loads
c1 = config.config
puts "  Config loaded: #{c1.keys}"

# Second call returns cached
c2 = config.config
puts "  Config from cache: #{c2.keys}"

puts "  Same object: #{c1.object_id == c2.object_id}"
```

**Expected output (abridged):**
```
=== Thread-safe cache ===
  greeting: Hello
  farewell: Goodbye
  size: 2
  Computing expensive_computation... (slow)
  expensive_computation: result-for-expensive_computation

=== Concurrent access stress test ===
  Expected successes: 500
  Actual successes:   500
  Cache size: 500
  All correct: true

=== Lazy attribute initialization ===
  Loading configuration from file...
  Config loaded: ["database_url", "cache_ttl", "max_connections"]
  Config from cache: ["database_url", "cache_ttl", "max_connections"]
  Same object: true
```

## Completion Checklist

- [ ] You can create and join threads with `Thread.new` and `Thread#value`
- [ ] You understand thread-local variables (`Thread.current[:key]`)
- [ ] You understand the GIL and its impact on Ruby concurrency (I/O-bound vs CPU-bound)
- [ ] You can protect shared mutable state with `Mutex#synchronize`
- [ ] You can use `Queue` for thread-safe producer-consumer patterns
- [ ] You can implement a worker pool with a shared queue and shutdown signal
- [ ] You can create and use `Fiber` for cooperative concurrency
- [ ] You can use a `Fiber` as a generator to produce infinite sequences
- [ ] You understand the difference between threads (preemptive, OS-managed) and fibers (cooperative, programmer-controlled)
- [ ] You know about `Fiber.schedule` (Ruby 3.0+) and async programming options
- [ ] You can implement thread-safe patterns: double-checked locking, lazy initialization
- [ ] You can identify and fix race conditions
- [ ] You understand deadlock risks and how to avoid them
- [ ] You know when to use `Process.fork` for true parallelism

## Hints

- Ruby threads are great for I/O-bound work (network requests, file reads, DB queries) but don't help with CPU-bound Ruby code due to the GIL — use `Process.fork` or a non-MRI Ruby for CPU parallelism
- Always use `Mutex#synchronize` when multiple threads access mutable shared state — even "simple" operations like `@counter += 1` are not atomic (they're read-modify-write)
- `Queue` is thread-safe by design — prefer it over a plain array with a mutex for work queues and producer-consumer patterns
- The shutdown pattern: send a special sentinel value (like `:shutdown`) to signal workers to stop — each worker checks for it after popping from the queue
- Fibers are lightweight (much cheaper than threads) but require explicit yielding — they're ideal for generators, iterators, and async I/O with a fiber scheduler
- Double-checked locking (check without lock, then check again with lock) is a common optimization for lazy initialization — but be careful: the fast-path check may see stale data in highly concurrent scenarios
- `Thread#value` is convenient — it joins the thread and returns its last expression value, raising any unhandled exception from the thread
- Test concurrent code with stress tests (many iterations, many threads) — race conditions often only appear under load
- When in doubt, start with the simplest correct solution: a single thread, then add concurrency only where profiling shows it's needed
- The `async` gem provides a mature fiber scheduler and async I/O primitives — worth learning for production async Ruby
