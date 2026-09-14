# ---------- Basic raise and rescue ----------
begin
  puts "About to raise..."
  raise "Something went wrong!"
  puts "This line never runs"
rescue => e
  puts "Caught: #{e.class} — #{e.message}"
  puts "Backtrace (first 3 lines):"
  puts e.backtrace.first(3).join("\n")
end

puts "\nProgram continues after rescue\n"

# ---------- Raising specific exception types ----------
def divide(a, b)
  raise ArgumentError, "Cannot divide by zero" if b.zero?
  a / b
end

begin
  puts "10 / 2 = #{divide(10, 2)}"
  puts "10 / 0 = #{divide(10, 0)}"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
rescue => e
  puts "Unexpected error: #{e.class} — #{e.message}"
end

# ---------- ensure always runs ----------
def process_with_cleanup(filename)
  file = nil
  begin
    file = File.open(filename, "w")
    file.write("important data")
    puts "File written successfully"
    raise "Simulated failure after write"
  rescue => e
    puts "Error during processing: #{e.message}"
    raise
  ensure
    if file && !file.closed?
      file.close
      puts "File closed in ensure block"
    end
  end
end

begin
  process_with_cleanup("/tmp/ruby_04_test.txt")
rescue => e
  puts "Outer rescue: #{e.message}"
end

puts "File exists and was closed: #{File.exist?("/tmp/ruby_04_test.txt")}"

# ---------- else clause ----------
def succeed_or_fail(should_succeed)
  begin
    raise "fail!" unless should_succeed
    "success!"
  rescue => e
    "rescued: #{e.message}"
  else
    "else: #{_1}"
  end
end

puts "\nSuccess case: #{succeed_or_fail(true)}"
puts "Failure case: #{succeed_or_fail(false)}"

# ---------- Understanding Exception vs StandardError ----------
class MyCustomError < StandardError
  def initialize(msg, code)
    super(msg)
    @code = code
  end
  attr_reader :code
end

begin
  raise MyCustomError.new("custom error", 42)
rescue MyCustomError => e
  puts "\nCustom error caught: #{e.message}, code=#{e.code}"
rescue Exception => e
  puts "Caught a top-level Exception (unexpected)"
end
