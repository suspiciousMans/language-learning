#!/usr/bin/env python3
"""Exercise 2: Custom exceptions — define and use domain-specific errors."""


class ValidationError(Exception):
    """Raised when input data fails validation."""


class InsufficientFundsError(Exception):
    def __init__(self, balance: float, amount: float):
        self.balance = balance
        self.amount = amount
        super().__init__(
            f"cannot withdraw {amount}: balance is {balance}"
        )


def validate_user(name: str, age: int) -> dict:
    """Validate user input.

    Raise ValidationError if:
    - name is empty or whitespace-only
    - age is not a positive integer

    Return {"name": name, "age": age} on success.
    """
    if not name or not name.strip():
        raise ValidationError("name must not be empty")
    if not isinstance(age, int) or age <= 0:
        raise ValidationError("age must be a positive integer")
    return {"name": name, "age": age}


class BankAccount:
    """A simple bank account with deposit and withdraw operations."""

    def __init__(self, balance: float):
        """Initialize with a balance (must be >= 0)."""
        if balance < 0:
            raise ValueError("initial balance must be >= 0")
        self._balance = balance

    def deposit(self, amount: float) -> None:
        """Deposit money. Amount must be > 0."""
        if amount <= 0:
            raise ValueError("deposit amount must be > 0")
        self._balance += amount

    def withdraw(self, amount: float) -> None:
        """Withdraw money. Raise InsufficientFundsError if amount > balance."""
        if amount <= 0:
            raise ValueError("withdrawal amount must be > 0")
        if amount > self._balance:
            raise InsufficientFundsError(self._balance, amount)
        self._balance -= amount

    @property
    def balance(self) -> float:
        """Return the current balance."""
        return self._balance


if __name__ == "__main__":
    print(validate_user("Alice", 30))
    try:
        validate_user("", 30)
    except ValidationError as e:
        print("caught:", e)

    acct = BankAccount(100)
    print("balance:", acct.balance)
    acct.deposit(50)
    print("after deposit:", acct.balance)
    acct.withdraw(30)
    print("after withdraw:", acct.balance)
    try:
        acct.withdraw(200)
    except InsufficientFundsError as e:
        print("caught:", e)
