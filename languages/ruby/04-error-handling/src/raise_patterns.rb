# ---------- raise as an expression (begin/rescue returns a value) ----------
def find_user(id)
  users = { 1 => "Alice", 2 => "Bob", 3 => "Carol" }
  raise KeyError, "User #{id} not found" unless users.key?(id)
  users[id]
end

def find_user_or_default(id, default)
  find_user(id)
rescue KeyError
  default
end

puts "User 1: #{find_user_or_default(1, "Nobody")}"
puts "User 99: #{find_user_or_default(99, "Nobody")}"

# ---------- re-raise after logging ----------
def log_and_reraise(message)
  puts "[LOG] #{message}"
  raise
end

begin
  begin
    raise "original error"
  rescue => e
    log_and_reraise("Caught error, re-raising")
  end
rescue => e
  puts "Outer caught: #{e.message}"
end

# ---------- catch/throw for control flow (not error handling) ----------
def find_first_even(numbers)
  numbers.each do |n|
    throw :found, n if n.even?
  end
  nil
end

result = catch(:found) do
  find_first_even([1, 3, 5, 7, 8, 10])
end
puts "\nFirst even: #{result}"

result = catch(:found) do
  find_first_even([1, 3, 5, 7])
end
puts "First even (none): #{result.inspect}"

# ---------- Alternative: return nil instead of raising ----------
def find_user_nil(id)
  users = { 1 => "Alice", 2 => "Bob", 3 => "Carol" }
  users[id]
end

puts "Found: #{find_user_nil(1)}"
puts "Not found: #{find_user_nil(99).inspect}"

# ---------- Alternative: return a result hash ----------
def find_user_result(id)
  users = { 1 => "Alice", 2 => "Bob", 3 => "Carol" }
  if users.key?(id)
    { success: true, value: users[id] }
  else
    { success: false, error: "User #{id} not found" }
  end
end

result = find_user_result(2)
if result[:success]
  puts "Result success: #{result[:value]}"
else
  puts "Result error: #{result[:error]}"
end

result = find_user_result(99)
if result[:success]
  puts "Result success: #{result[:value]}"
else
  puts "Result error: #{result[:error]}"
end

# ---------- Alternative: raise with a custom exception class ----------
class ValidationError < StandardError
  attr_reader :errors

  def initialize(errors)
    @errors = errors
    super("Validation failed: #{errors.size} error(s)")
  end
end

def validate_user(name, email)
  errors = []
  errors << "Name is required" if name.nil? || name.strip.empty?
  errors << "Email is required" if email.nil? || email.strip.empty?
  errors << "Email must contain @" unless email&.include?("@")
  raise ValidationError.new(errors) unless errors.empty?
  { name: name, email: email }
end

begin
  validate_user("Alice", "alice@example.com")
rescue ValidationError => e
  puts "\nValidation error: #{e.message}"
  puts "Errors: #{e.errors.join(", ")}"
end

begin
  validate_user("", "not-an-email")
rescue ValidationError => e
  puts "\nValidation error: #{e.message}"
  puts "Errors: #{e.errors.join(", ")}"
end
