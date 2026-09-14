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

# ---------- Fiber scheduler note ----------
puts "\n=== Fiber scheduler note ==="
puts "  Ruby 3.0+ supports Fiber.schedule for async I/O."
puts "  Install a scheduler with Fiber.set_scheduler(Async::Scheduler.new)"
puts "  Then blocking operations like sleep, IO.read, etc. automatically"
puts "  yield the fiber instead of blocking the thread."
puts "  This enables async-style code with synchronous-looking syntax."
puts "  See the async gem: gem install async"
