# Project 05: Testing with RSpec — Ruby

**Difficulty:** intermediate  
**Prerequisites:** Project 04 (Error Handling)

## Goals

- Write unit tests with RSpec
- Use `describe`/`it`/`context` blocks to organize tests
- Apply the Arrange-Act-Assert pattern
- Use mocks and stubs to isolate the system under test
- Test edge cases: nil, empty collections, boundary values, error conditions
- Understand `before`/`after` hooks, helper methods, and shared examples
- Run tests with `rspec` and read the formatted output

## Concepts

- **RSpec** — behavior-driven development (BDD) framework for Ruby; tests are expressed as specifications of behavior
- **`describe`** — groups related tests; usually describes a class or method
- **`it`** — an individual example (test case); contains the actual test code
- **`context`** — an alias for `describe` used to describe a specific scenario or precondition
- **`expect(...).to(...)`** — assertion; reads like English: "expect this value to equal that value"
- **Matchers** — `eq`, `be`, `be_nil`, `include`, `be >`, `raise_error`, `change`, `match`, `respond_to`, etc.
- **`let`** — defines a memoized helper method; computed lazily on first use within an example
- **`let!`** — like `let` but forces evaluation before each example (e.g., for setup side effects)
- **`before`** — runs code before each example (`:each`) or before all examples (`:all`)
- **`after`** — runs code after each example or after all examples
- **Mocks/stubs** — `allow(...).to receive(...).and_return(...)` stubs a method; `expect(...).to receive(...)` sets an expectation that a method will be called
- **Doubles** — `double("name", message: "hello")` creates a test double (fake object) with known behavior
- **Shared examples** — `shared_examples_for` / `it_behaves_like` for reusing test patterns across classes
- **Subject** — `subject { described_class.new }` defines the default object under test; `is_expected.to` is a shorthand

## Exercises

### Exercise 1: RSpec Basics — describe, it, expect, matchers

Create `src/calculator.rb`:

```ruby
# A simple calculator class to test
class Calculator
  def add(a, b)
    a + b
  end

  def subtract(a, b)
    a - b
  end

  def multiply(a, b)
    a * b
  end

  def divide(a, b)
    raise ArgumentError, "Cannot divide by zero" if b.zero?
    a / b
  end

  def power(base, exp)
    raise ArgumentError, "Negative exponent not supported" if exp < 0
    result = 1
    exp.times { result *= base }
    result
  end
end
```

Create `src/calculator_spec.rb`:

```ruby
require_relative "calculator"

RSpec.describe Calculator do
  subject(:calc) { described_class.new }

  describe "#add" do
    it "returns the sum of two positive numbers" do
      # Arrange-Act-Assert
      result = calc.add(3, 5)
      expect(result).to eq(8)
    end

    it "handles negative numbers" do
      expect(calc.add(-3, 5)).to eq(2)
      expect(calc.add(3, -5)).to eq(-2)
      expect(calc.add(-3, -5)).to eq(-8)
    end

    it "handles zero" do
      expect(calc.add(0, 0)).to eq(0)
      expect(calc.add(5, 0)).to eq(5)
    end
  end

  describe "#subtract" do
    it "returns the difference" do
      expect(calc.subtract(10, 3)).to eq(7)
      expect(calc.subtract(3, 10)).to eq(-7)
    end
  end

  describe "#multiply" do
    it "returns the product" do
      expect(calc.multiply(3, 4)).to eq(12)
      expect(calc.multiply(-3, 4)).to eq(-12)
      expect(calc.multiply(0, 100)).to eq(0)
    end
  end

  describe "#divide" do
    it "returns the quotient" do
      expect(calc.divide(10, 2)).to eq(5)
      expect(calc.divide(7, 2)).to eq(3)  # integer division
    end

    it "raises ArgumentError when dividing by zero" do
      expect { calc.divide(10, 0) }.to raise_error(ArgumentError, "Cannot divide by zero")
    end
  end

  describe "#power" do
    it "computes positive powers" do
      expect(calc.power(2, 3)).to eq(8)
      expect(calc.power(5, 0)).to eq(1)
    end

    it "raises ArgumentError for negative exponent" do
      expect { calc.power(2, -1) }.to raise_error(ArgumentError)
    end
  end

  describe "edge cases" do
    it "handles large numbers" do
      expect(calc.add(1_000_000, 2_000_000)).to eq(3_000_000)
    end

    it "handles integer overflow gracefully (Ruby has arbitrary precision)" do
      result = calc.power(2, 100)
      expect(result).to be_a(Integer)
      expect(result).to be > 0
    end
  end
end
```

**Run:** `rspec src/calculator_spec.rb`

**Expected output (abridged):**
```
.....

Calculator
  #add
    returns the sum of two positive numbers
    handles negative numbers
    handles zero
  #subtract
    returns the difference
  #multiply
    returns the product
  #divide
    returns the quotient
    raises ArgumentError when dividing by zero
  #power
    computes positive powers
    raises ArgumentError for negative exponent
  edge cases
    handles large numbers
    handles integer overflow gracefully (Ruby has arbitrary precision)

11 examples, 0 failures
```

### Exercise 2: Mocks, Stubs, and Doubles — Isolating the System Under Test

Create `src/user_repository.rb`:

```ruby
# A repository interface (in real code, this would talk to a database)
class UserRepository
  def find_by_id(id)
    raise NotImplementedError, "Subclass must implement"
  end

  def save(user)
    raise NotImplementedError, "Subclass must implement"
  end

  def delete(id)
    raise NotImplementedError, "Subclass must implement"
  end
end

# A user model
class User
  attr_reader :id, :name, :email

  def initialize(id, name, email)
    @id = id
    @name = name
    @email = email
  end

  def valid?
    !name.nil? && !name.strip.empty? && email&.include?("@")
  end
end

# A service that uses the repository — this is what we'll test
class UserService
  def initialize(repo)
    @repo = repo
  end

  def get_user(id)
    @repo.find_by_id(id)
  end

  def create_user(name, email)
    user = User.new(0, name, email)
    unless user.valid?
      raise ArgumentError, "Invalid user: name and valid email required"
    end
    saved = @repo.save(user)
    saved
  end

  def delete_user(id)
    @repo.delete(id)
  end

  def find_or_create(id, name, email)
    user = @repo.find_by_id(id)
    return user if user
    create_user(name, email)
  end
end
```

Create `src/user_service_spec.rb`:

```ruby
require_relative "user_repository"
require_relative "user"

RSpec.describe UserService do
  let(:repo) { double("UserRepository") }
  subject(:service) { described_class.new(repo) }

  describe "#get_user" do
    it "returns the user when found" do
      alice = User.new(1, "Alice", "alice@example.com")
      allow(repo).to receive(:find_by_id).with(1).and_return(alice)

      result = service.get_user(1)

      expect(result).to eq(alice)
      expect(result.name).to eq("Alice")
    end

    it "returns nil when user not found" do
      allow(repo).to receive(:find_by_id).with(999).and_return(nil)

      result = service.get_user(999)

      expect(result).to be_nil
    end

    it "delegates to the repository" do
      expect(repo).to receive(:find_by_id).with(42)
      service.get_user(42)
    end
  end

  describe "#create_user" do
    it "saves and returns a valid user" do
      saved_user = User.new(1, "Bob", "bob@example.com")
      allow(repo).to receive(:save).and_return(saved_user)

      result = service.create_user("Bob", "bob@example.com")

      expect(result).to eq(saved_user)
      expect(result.name).to eq("Bob")
      expect(repo).to have_received(:save)
    end

    it "raises ArgumentError for invalid user (empty name)" do
      expect { service.create_user("", "bob@example.com") }
        .to raise_error(ArgumentError, /Invalid user/)
    end

    it "raises ArgumentError for invalid email" do
      expect { service.create_user("Bob", "not-an-email") }
        .to raise_error(ArgumentError, /Invalid user/)
    end
  end

  describe "#find_or_create" do
    it "returns existing user when found" do
      existing = User.new(1, "Alice", "alice@example.com")
      allow(repo).to receive(:find_by_id).with(1).and_return(existing)

      result = service.find_or_create(1, "New", "new@example.com")

      expect(result).to eq(existing)
      expect(repo).not_to have_received(:save)
    end

    it "creates a new user when not found" do
      allow(repo).to receive(:find_by_id).and_return(nil)
      new_user = User.new(2, "Charlie", "charlie@example.com")
      allow(repo).to receive(:save).and_return(new_user)

      result = service.find_or_create(2, "Charlie", "charlie@example.com")

      expect(result).to eq(new_user)
      expect(repo).to have_received(:save)
    end
  end

  describe "integration-style test with a fake repository" do
    # AFake repository that actually stores users in memory — useful for
    # testing the service without a real database
    class FakeRepo
      def initialize
        @users = {}
      end

      def find_by_id(id)
        @users[id]
      end

      def save(user)
        @users[user.id] = user
        user
      end

      def delete(id)
        @users.delete(id)
      end
    end

    let(:fake_repo) { FakeRepo.new }
    subject(:service) { described_class.new(fake_repo) }

    it "works end-to-end: create, find, delete" do
      # Create
      user = service.create_user("Dave", "dave@example.com")
      expect(user.name).to eq("Dave")

      # Find
      found = service.get_user(user.id)
      expect(found).to eq(user)

      # Delete
      result = service.delete_user(user.id)
      expect(service.get_user(user.id)).to be_nil
    end
  end
end
```

**Run:** `rspec src/user_service_spec.rb`

**Expected output (abridged):**
```
.............................

UserService
  #get_user
    returns the user when found
    returns nil when user not found
    delegates to the repository
  #create_user
    saves and returns a valid user
    raises ArgumentError for invalid user (empty name)
    raises ArgumentError for invalid email
  #find_or_create
    returns existing user when found
    creates a new user when not found
  integration-style test with a fake repository
    works end-to-end: create, find, delete

13 examples, 0 failures
```

### Exercise 3: Hooks, let, and Shared Examples — Reusable Test Patterns

Create `src/bank_account.rb`:

```ruby
class BankAccount
  attr_reader :balance, :account_number

  def initialize(account_number, initial_balance = 0)
    @account_number = account_number
    @balance = initial_balance
    @closed = false
  end

  def deposit(amount)
    raise ArgumentError, "Amount must be positive" if amount <= 0
    raise RuntimeError, "Account is closed" if @closed
    @balance += amount
    @balance
  end

  def withdraw(amount)
    raise ArgumentError, "Amount must be positive" if amount <= 0
    raise RuntimeError, "Account is closed" if @closed
    raise InsufficientFundsError, "Insufficient funds" if amount > @balance
    @balance -= amount
    @balance
  end

  def close
    @closed = true
  end

  def closed?
    @closed
  end
end

class InsufficientFundsError < StandardError; end
```

Create `src/bank_account_spec.rb`:

```ruby
require_relative "bank_account"

RSpec.describe BankAccount do
  subject(:account) { described_class.new(123, 100) }

  # ---------- before hooks ----------
  # before(:each) runs before every example — good for setup that all tests need
  before(:each) do
    # Reset the subject before each test (subject is already a new instance
    # per example thanks to RSpec's default behavior, but this shows the pattern)
    @balance_before = account.balance
  end

  describe "#deposit" do
    it "increases the balance" do
      expect { account.deposit(50) }.to change(account, :balance).by(50)
    end

    it "raises ArgumentError for non-positive amount" do
      expect { account.deposit(0) }.to raise_error(ArgumentError)
    end

    it "raises RuntimeError when account is closed" do
      account.close
      expect { account.deposit(10) }.to raise_error(RuntimeError, "Account is closed")
    end
  end

  describe "#withdraw" do
    it "decreases the balance" do
      expect { account.withdraw(30) }.to change(account, :balance).by(-30)
    end

    it "raises InsufficientFundsError when balance is too low" do
      expect { account.withdraw(200) }.to raise_error(InsufficientFundsError, "Insufficient funds")
    end

    it "allows withdrawing exactly the balance" do
      expect { account.withdraw(100) }.to change(account, :balance).to(0)
    end
  end

  describe "#close" do
    it "marks the account as closed" do
      expect(account.closed?).to be false
      account.close
      expect(account.closed?).to be true
    end

    it "prevents further deposits" do
      account.close
      expect { account.deposit(10) }.to raise_error(RuntimeError)
    end

    it "prevents further withdrawals" do
      account.close
      expect { account.withdraw(10) }.to raise_error(RuntimeError)
    end
  end

  # ---------- shared examples ----------
  # Shared examples let you reuse test patterns across different classes
  shared_examples "a closable resource" do
    it "starts as not closed" do
      expect(subject.closed?).to be false
    end

    it "can be closed" do
      subject.close
      expect(subject.closed?).to be true
    end
  end

  # Include the shared examples for this class
  it_behaves_like "a closable resource"
end

# ---------- shared examples in a separate context ----------
# You can also define shared examples that take parameters
RSpec.shared_examples "a withdrawable account" do |initial_balance|
  it "allows withdrawing up to the balance" do
    account = described_class.new(999, initial_balance)
    expect { account.withdraw(initial_balance) }.to change(account, :balance).to(0)
  end

  it "rejects withdrawals above the balance" do
    account = described_class.new(999, initial_balance)
    expect { account.withdraw(initial_balance + 1) }
      .to raise_error(InsufficientFundsError)
  end
end

RSpec.describe BankAccount do
  it_behaves_like "a withdrawable account", 500
  it_behaves_like "a withdrawable account", 0
  it_behaves_like "a withdrawable account", 1
end
```

**Run:** `rspec src/bank_account_spec.rb`

**Expected output (abridged):**
```
.............................

BankAccount
  #deposit
    increases the balance
    raises ArgumentError for non-positive amount
    raises RuntimeError when account is closed
  #withdraw
    decreases the balance
    raises InsufficientFundsError when balance is too low
    allows withdrawing exactly the balance
  #close
    marks the account as closed
    prevents further deposits
    prevents further withdrawals
  a closable resource
    starts as not closed
    can be closed
  a withdrawable account
    allows withdrawing up to the balance (with initial_balance = 500)
    rejects withdrawals above the balance (with initial_balance = 500)
    allows withdrawing up to the balance (with initial_balance = 0)
    rejects withdrawals above the balance (with initial_balance = 0)
    allows withdrawing up to the balance (with initial_balance = 1)
    rejects withdrawals above the balance (with initial_balance = 1)

19 examples, 0 failures
```

### Exercise 4: Testing Error Handling and Edge Cases

Create `src/validation.rb`:

```ruby
# A validation module with various error conditions to test
module Validation
  def self.validate_email(email)
    raise ArgumentError, "Email is nil" if email.nil?
    raise ArgumentError, "Email is empty" if email.strip.empty?
    raise ArgumentError, "Email must contain @" unless email.include?("@")
    raise ArgumentError, "Email must contain a domain" unless email.split("@").last.include?(".")
    email.strip.downcase
  end

  def self.validate_age(age)
    raise ArgumentError, "Age is nil" if age.nil?
    raise ArgumentError, "Age must be an integer" unless age.is_a?(Integer)
    raise ArgumentError, "Age must be positive" if age < 0
    raise ArgumentError, "Age seems unrealistic" if age > 150
    age
  end

  def self.validate_username(username)
    raise ArgumentError, "Username is required" if username.nil? || username.strip.empty?
    raise ArgumentError, "Username too short (min 3 chars)" if username.length < 3
    raise ArgumentError, "Username too long (max 20 chars)" if username.length > 20
    raise ArgumentError, "Username can only contain letters, numbers, and underscores" unless username.match?(/\A[a-zA-Z0-9_]+\z/)
    username.downcase
  end

  def self.validate_password(password)
    raise ArgumentError, "Password is required" if password.nil? || password.empty?
    raise ArgumentError, "Password too short (min 8 chars)" if password.length < 8
    issues = []
    issues << "missing uppercase letter" unless password.match?(/[A-Z]/)
    issues << "missing lowercase letter" unless password.match?(/[a-z]/)
    issues << "missing digit" unless password.match?(/[0-9]/)
    issues << "missing special character" unless password.match?(/[^a-zA-Z0-9]/)
    raise ArgumentError, "Password weak: #{issues.join(", ")}" unless issues.empty?
    password
  end
end
```

Create `src/validation_spec.rb`:

```ruby
require_relative "validation"

RSpec.describe Validation do
  describe ".validate_email" do
    it "returns a normalized email for valid input" do
      expect(Validation.validate_email("Alice@Example.COM")).to eq("alice@example.com")
    end

    it "raises ArgumentError for nil" do
      expect { Validation.validate_email(nil) }
        .to raise_error(ArgumentError, "Email is nil")
    end

    it "raises ArgumentError for empty string" do
      expect { Validation.validate_email("   ") }
        .to raise_error(ArgumentError, "Email is empty")
    end

    it "raises ArgumentError for missing @" do
      expect { Validation.validate_email("alice.example.com") }
        .to raise_error(ArgumentError, "Email must contain @")
    end

    it "raises ArgumentError for missing domain" do
      expect { Validation.validate_email("alice@") }
        .to raise_error(ArgumentError, "Email must contain a domain")
    end

    it "accepts emails with subdomains" do
      expect(Validation.validate_email("alice@mail.example.com")).to eq("alice@mail.example.com")
    end
  end

  describe ".validate_age" do
    it "returns the age for valid input" do
      expect(Validation.validate_age(25)).to eq(25)
    end

    it "raises ArgumentError for nil" do
      expect { Validation.validate_age(nil) }
        .to raise_error(ArgumentError, "Age is nil")
    end

    it "raises ArgumentError for non-integer" do
      expect { Validation.validate_age("25") }
        .to raise_error(ArgumentError, "Age must be an integer")
      expect { Validation.validate_age(25.5) }
        .to raise_error(ArgumentError, "Age must be an integer")
    end

    it "raises ArgumentError for negative age" do
      expect { Validation.validate_age(-1) }
        .to raise_error(ArgumentError, "Age must be positive")
    end

    it "raises ArgumentError for unrealistic age" do
      expect { Validation.validate_age(200) }
        .to raise_error(ArgumentError, "Age seems unrealistic")
    end

    it "accepts age 0 and 150 (boundary values)" do
      expect(Validation.validate_age(0)).to eq(0)
      expect(Validation.validate_age(150)).to eq(150)
    end
  end

  describe ".validate_username" do
    it "returns a normalized username" do
      expect(Validation.validate_username("Alice_123")).to eq("alice_123")
    end

    it "raises ArgumentError for nil or empty" do
      expect { Validation.validate_username(nil) }
        .to raise_error(ArgumentError, "Username is required")
      expect { Validation.validate_username("") }
        .to raise_error(ArgumentError, "Username is required")
    end

    it "raises ArgumentError for too short" do
      expect { Validation.validate_username("Ab") }
        .to raise_error(ArgumentError, /too short/)
    end

    it "raises ArgumentError for too long" do
      long_name = "a" * 21
      expect { Validation.validate_username(long_name) }
        .to raise_error(ArgumentError, /too long/)
    end

    it "raises ArgumentError for invalid characters" do
      expect { Validation.validate_username("alice@bob") }
        .to raise_error(ArgumentError, /can only contain/)
      expect { Validation.validate_username("alice bob") }
        .to raise_error(ArgumentError, /can only contain/)
    end

    it "accepts underscores" do
      expect(Validation.validate_username("alice_bob_123")).to eq("alice_bob_123")
    end
  end

  describe ".validate_password" do
    it "accepts a strong password" do
      expect(Validation.validate_password("Str0ng!Pass")).to eq("Str0ng!Pass")
    end

    it "raises ArgumentError for too short" do
      expect { Validation.validate_password("Short1!") }
        .to raise_error(ArgumentError, /too short/)
    end

    it "raises ArgumentError for missing uppercase" do
      expect { Validation.validate_password("strong!pass1") }
        .to raise_error(ArgumentError, /missing uppercase/)
    end

    it "raises ArgumentError for missing lowercase" do
      expect { Validation.validate_password("STR0NG!PASS") }
        .to raise_error(ArgumentError, /missing lowercase/)
    end

    it "raises ArgumentError for missing digit" do
      expect { Validation.validate_password("Strong!Pass") }
        .to raise_error(ArgumentError, /missing digit/)
    end

    it "raises ArgumentError for missing special character" do
      expect { Validation.validate_password("StrongPass1") }
        .to raise_error(ArgumentError, /missing special/)
    end

    it "raises ArgumentError with all issues listed" do
      expect { Validation.validate_password("weak") }
        .to raise_error(ArgumentError, /missing uppercase/, /missing digit/, /missing special/)
    end
  end
end
```

**Run:** `rspec src/validation_spec.rb`

**Expected output (abridged):**
```
....................

Validation
  .validate_email
    returns a normalized email for valid input
    raises ArgumentError for nil
    raises ArgumentError for empty string
    raises ArgumentError for missing @
    raises ArgumentError for missing domain
    accepts emails with subdomains
  .validate_age
    returns the age for valid input
    raises ArgumentError for nil
    raises ArgumentError for non-integer
    raises ArgumentError for negative age
    raises ArgumentError for unrealistic age
    accepts age 0 and 150 (boundary values)
  .validate_username
    returns a normalized username
    raises ArgumentError for nil or empty
    raises ArgumentError for too short
    raises ArgumentError for too long
    raises ArgumentError for invalid characters
    accepts underscores
  .validate_password
    accepts a strong password
    raises ArgumentError for too short
    raises ArgumentError for missing uppercase
    raises ArgumentError for missing lowercase
    raises ArgumentError for missing digit
    raises ArgumentError for missing special character
    raises ArgumentError with all issues listed

28 examples, 0 failures
```

## Completion Checklist

- [ ] You can write basic RSpec tests with `describe`, `it`, and `expect(...).to`
- [ ] You understand the Arrange-Act-Assert pattern and can apply it consistently
- [ ] You can use matchers: `eq`, `be`, `be_nil`, `include`, `raise_error`, `change`, `match`
- [ ] You can use `let` and `let!` for test data setup
- [ ] You can use `before(:each)` and `before(:all)` hooks
- [ ] You can stub methods with `allow(...).to receive(...).and_return(...)`
- [ ] You can set expectations with `expect(...).to receive(...)`
- [ ] You can create test doubles with `double("name", ...)` 
- [ ] You can use `change(object, :property).by(amount)` to test state changes
- [ ] You can use `subject` and `is_expected.to` for concise tests
- [ ] You can write shared examples with `shared_examples` and `it_behaves_like`
- [ ] You can test edge cases: nil, empty, boundary values, error conditions
- [ ] You can read RSpec output and identify failures
- [ ] You understand the difference between stubbing (providing a return value) and mocking (setting an expectation that a method is called)

## Hints

- Always test the happy path AND the error paths — don't just test the case that works
- Use `change { object.property }` (block form) when the property is a method call, or `change(object, :property)` (symbol form) for simple attribute access
- `let` is lazy — it's not evaluated until the first time you reference it in an example; `let!` forces evaluation before each example
- Use `described_class` instead of hardcoding the class name — it makes shared examples work across classes
- Keep tests focused: one behavior per `it` block, clear descriptions that say WHAT is being tested, not HOW
- When testing exceptions, always use the block form: `expect { ... }.to raise_error(...)` — if you call the method directly, the exception propagates out of the `expect` and the test framework catches it differently
- Favor test doubles (fakes, stubs) over real dependencies in unit tests — they make tests faster and more isolated
- Integration-style tests with fake implementations (like the `FakeRepo` in Exercise 2) are valuable for testing end-to-end behavior without a real database
- Run `rspec --format documentation` for readable output during development; `rspec --format progress` (default) is compact for CI
