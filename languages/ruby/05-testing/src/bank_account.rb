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
