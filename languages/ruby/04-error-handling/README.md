# Project 04: Error Handling — Ruby

**Difficulty:** intermediate  
**Prerequisites:** Project 03 (Methods, Classes, and Modules)

## Goals

- Handle errors with `raise`, `rescue`, `ensure`, and `else`
- Create custom exception classes and exception hierarchies
- Use `begin`/`rescue` as both statements and expressions
- Understand `StandardError` vs `Exception` and why you should rescue the former
- Practice defensive programming: validate inputs, fail fast, provide meaningful error messages
- Explore alternative error-handling patterns: return nil, return result hashes, use monads

## Concepts

- **`raise`** — raise an exception (defaults to `RuntimeError`); can take a message string, an exception class, or an exception instance
- **`rescue`** — catches exceptions; can target specific exception types or use a generic `rescue => e`
- **`ensure`** — code that always runs, whether an exception occurred or not (like `finally` in other languages)
- **`else`** — runs only when no exception was raised in the `begin` block
- **`$!`** — global variable holding the current exception (thread-local)
- **`$@`** — global variable holding the backtrace of the current exception
- **`StandardError`** — the base class for most "normal" exceptions; `Exception` is broader and includes `SystemExit`, `NoMemoryError`, etc. — rescue `StandardError`, not `Exception`
- **Custom exceptions** — derive from `StandardError` (or a domain-specific base); can carry extra data as attributes
- **`begin`/`rescue` as expression** — the whole block returns a value; if an exception is rescued, the rescue clause's last expression is the return value
- **`fail`** — alias for `raise`; some style guides prefer `fail` for failures and `raise` for re-raising
- **`catch`/`throw`** — non-local exit (different from exceptions); used for control flow, not error handling

## Exercises

### Exercise 1: Basic Exception Handling — raise, rescue, ensure

Create `src/exceptions_basics.rb`:

```ruby
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
    raise  # re-raise after cleanup
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

# Verify cleanup happened
puts "File exists and was closed: #{File.exist?("/tmp/ruby_04_test.txt")}"

# ---------- else clause ----------
def succeed_or_fail(should_succeed)
  begin
    raise "fail!" unless should_succeed
    "success!"
  rescue => e
    "rescued: #{e.message}"
  else
    "else: #{_1}"  # _1 is the result of the begin block
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
  # This would catch things like SystemExit, NoMemoryError — don't do this
  puts "Caught a top-level Exception (unexpected)"
end
```

**Expected output (abridged):**
```
About to raise...
Caught: RuntimeError — Something went wrong!
Backtrace (first 3 lines):
	(...):in `<main>': Something went wrong! (RuntimeError)
	...

Program continues after rescue

10 / 2 = 5
ArgumentError: Cannot divide by zero

File written successfully
Error during processing: Simulated failure after write
File closed in ensure block
Outer rescue: Simulated failure after write
File exists and was closed: true

Success case: else: success!
Failure case: rescued: fail!

Custom error caught: custom error, code=42
```

### Exercise 2: Custom Exception Classes

Create `src/custom_exceptions.rb`:

```ruby
# ---------- Custom exception hierarchy ----------
class BankError < StandardError; end
class InsufficientFundsError < BankError
  attr_reader :balance, :attempted

  def initialize(balance, attempted)
    @balance = balance
    @attempted = attempted
    super("Insufficient funds: have $#{balance}, tried to withdraw $#{attempted}")
  end
end

class AccountNotFoundError < BankError
  attr_reader :account_id

  def initialize(account_id)
    @account_id = account_id
    super("Account not found: #{account_id}")
  end
end

class Account
  attr_reader :id, :balance

  def initialize(id, balance)
    @id = id
    @balance = balance
  end

  def withdraw(amount)
    raise ArgumentError, "Withdrawal amount must be positive" if amount <= 0
    raise InsufficientFundsError.new(@balance, amount) if amount > @balance
    @balance -= amount
    "Withdrew $#{amount}, new balance: $#{@balance}"
  end

  def deposit(amount)
    raise ArgumentError, "Deposit amount must be positive" if amount <= 0
    @balance += amount
    "Deposited $#{amount}, new balance: $#{@balance}"
  end
end

# Simulate a bank lookup
class Bank
  def initialize
    @accounts = {
      1 => Account.new(1, 100),
      2 => Account.new(2, 250),
      3 => Account.new(3, 0)
    }
  end

  def find_account(id)
    @accounts.fetch(id) do
      raise AccountNotFoundError.new(id)
    end
  end
end

bank = Bank.new

# Successful operations
begin
  account = bank.find_account(1)
  puts "Account #{account.id}: balance=#{account.balance}"
  puts account.withdraw(50)
rescue BankError => e
  puts "Bank error: #{e.message}"
end

# Insufficient funds
begin
  account = bank.find_account(1)
  puts account.withdraw(200)
rescue InsufficientFundsError => e
  puts "Caught insufficient funds:"
  puts "  Message: #{e.message}"
  puts "  Have: $#{e.balance}, tried: $#{e.attempted}"
  puts "  Shortfall: $#{e.attempted - e.balance}"
rescue BankError => e
  puts "Other bank error: #{e.message}"
end

# Account not found
begin
  bank.find_account(999)
rescue AccountNotFoundError => e
  puts "\nAccount not found: #{e.account_id}"
rescue BankError => e
  puts "Other bank error: #{e.message}"
end

# ---------- Exception hierarchy and rescue ordering ----------
puts "\n=== Rescue ordering ==="

begin
  raise InsufficientFundsError.new(100, 200)
rescue InsufficientFundsError => e
  puts "Caught InsufficientFundsError (most specific first)"
rescue BankError => e
  puts "Caught BankError (parent class)"
rescue StandardError => e
  puts "Caught StandardError (broader)"
end

# ---------- Wrapping and re-raising ----------
def risky_operation
  raise "Low-level failure"
end

def high_level_operation
  risky_operation
rescue => e
  raise BankError, "High-level operation failed", cause: e
end

begin
  high_level_operation
rescue BankError => e
  puts "\nHigh-level error: #{e.message}"
  puts "Caused by: #{e.cause&.message}"
end
```

**Expected output (abridged):**
```
Account 1: balance=100
Withdrew $50, new balance: $50
Caught insufficient funds:
  Message: Insufficient funds: have $50, tried to withdraw $200
  Have: $50, tried: $200
  Shortfall: $100

Account not found: 999

=== Rescue ordering ===
Caught InsufficientFundsError (most specific first)

High-level error: High-level operation failed
Caused by: Low-level failure
```

### Exercise 3: raise as an Expression, Re-raise, and Alternative Patterns

Create `src/raise_patterns.rb`:

```ruby
# ---------- raise as an expression (begin/rescue returns a value) ----------
def find_user(id)
  users = { 1 => "Alice", 2 => "Bob", 3 => "Carol" }
  raise KeyError, "User #{id} not found" unless users.key?(id)
  users[id]
end

# Pattern 1: return a default on failure
def find_user_or_default(id, default)
  find_user(id)
rescue KeyError
  default
end

puts "User 1: #{find_user_or_default(1, "Nobody")}"
puts "User 99: #{find_user_or_default(99, "Nobody")}"

# Pattern 2: re-raise after logging
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
  users[id]  # returns nil if not found — no exception
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
```

**Expected output (abridged):**
```
User 1: Alice
User 99: Nobody

[LOG] Caught error, re-raising
Outer caught: original error

First even: 8
First even (none): 

Found: Alice
Not found: nil

Result success: Bob
Result error: User 99 not found

Validation error: Validation failed: 2 error(s)
Errors: Name is required, Email must contain @
```

## Completion Checklist

- [ ] You understand `raise` and `rescue` basics
- [ ] You know when to use `ensure` (always-run cleanup) vs `else` (only-on-success)
- [ ] You understand why you should rescue `StandardError`, not `Exception`
- [ ] You can create custom exception classes with extra data
- [ ] You understand exception hierarchy and rescue ordering (most specific first)
- [ ] You can re-raise exceptions after logging or wrapping
- [ ] You know the difference between `raise` (error) and `catch`/`throw` (control flow)
- [ ] You understand alternative error-handling patterns: nil, result hash, custom exception
- [ ] You know how to write rescue clauses that return values (begin/rescue as expression)
- [ ] You understand the `cause:` keyword for exception wrapping (Ruby 2.1+)

## Hints

- Always rescue `StandardError` (or a more specific type) — rescuing `Exception` catches `SystemExit`, `NoMemoryError`, `SignalException`, and other system-level events you almost never want to catch
- `ensure` runs whether an exception occurred or not — use it for cleanup (closing files, releasing locks, etc.)
- `else` runs only when no exception was raised — useful when you want to distinguish "success" from "rescued failure" in the same block
- Custom exceptions should inherit from `StandardError`, not `Exception` or `RuntimeError` directly (though `RuntimeError` is a subclass of `StandardError`)
- `raise` without arguments inside a rescue block re-raises the current exception (`$!`)
- `catch`/`throw` is for control flow (early exit from nested loops, etc.), not for error handling — it's rarely needed in idiomatic Ruby
- Ruby's philosophy: "raise exception, rescue exception, move on" — exceptions are for exceptional situations, not expected control flow
- When writing libraries, consider returning `nil` or a result object instead of raising, so callers can decide how to handle failure
