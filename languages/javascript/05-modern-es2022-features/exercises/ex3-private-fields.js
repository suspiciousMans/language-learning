// ex3-private-fields.js
// Create classes with private fields.

class BankAccount {
  #balance = 0; // Private field
  #pin = '1234'; // Private pin

  constructor(initialBalance) {
    this.#balance = initialBalance;
  }

  // Public method
  deposit(amount) {
    if (amount > 0) {
      this.#balance += amount;
      return `Deposited ${amount}. Balance: ${this.#balance}`;
    }
    return 'Invalid amount';
  }

  // Public getter
  getBalance() {
    return this.#balance;
  }

  // Private method (also possible)
  #verify(pin) {
    return pin === this.#pin;
  }

  // Public method using private method
  withdraw(amount, pin) {
    if (!this.#verify(pin)) {
      return 'Invalid PIN';
    }
    if (amount <= this.#balance) {
      this.#balance -= amount;
      return `Withdrew ${amount}. Balance: ${this.#balance}`;
    }
    return 'Insufficient funds';
  }
}

const account = new BankAccount(1000);
console.log('Initial balance:', account.getBalance());
console.log(account.deposit(500));
console.log(account.withdraw(200, '1234'));
console.log(account.withdraw(200, '0000')); // Wrong PIN

// Private fields cannot be accessed from outside
console.log('\nTrying to access private fields:');
console.log('account.#balance:', typeof account.balance); // undefined
console.log('account.#pin:', typeof account.pin); // undefined
console.log('Private fields are inaccessible from outside the class');
