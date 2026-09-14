require_relative "bank_account"

RSpec.describe BankAccount do
  subject(:account) { described_class.new(123, 100) }

  before(:each) do
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

  shared_examples "a closable resource" do
    it "starts as not closed" do
      expect(subject.closed?).to be false
    end

    it "can be closed" do
      subject.close
      expect(subject.closed?).to be true
    end
  end

  it_behaves_like "a closable resource"
end

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
