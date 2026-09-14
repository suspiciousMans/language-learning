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
