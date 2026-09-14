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

begin
  account = bank.find_account(1)
  puts "Account #{account.id}: balance=#{account.balance}"
  puts account.withdraw(50)
rescue BankError => e
  puts "Bank error: #{e.message}"
end

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

begin
  bank.find_account(999)
rescue AccountNotFoundError => e
  puts "\nAccount not found: #{e.account_id}"
rescue BankError => e
  puts "Other bank error: #{e.message}"
end

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
