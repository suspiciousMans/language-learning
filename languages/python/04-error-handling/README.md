# 04 — Error Handling

## Goals

Learn how Python handles errors: exceptions, try/except/else/finally, custom exception classes, and context managers. Write code that fails gracefully and reports problems clearly.

## Concepts

- Exceptions: `Exception`, `ValueError`, `TypeError`, `KeyError`, `FileNotFoundError`, etc.
- `try`/`except`/`else`/`finally` blocks
- Raising exceptions with `raise`
- Custom exception classes (inheritance from `Exception`)
- Context managers: `with` statement, `contextlib.contextmanager`
- EAFP vs. LBYL (Easier to Ask Forgiveness than Permission vs. Look Before You Leap)
- Assertions (`assert`) and when not to use them for control flow

## Completion Checklist

- [ ] Each exercise file runs without errors when filled in
- [ ] Happy-path and error-path tests pass (see `tests/`)
- [ ] Custom exceptions are used where appropriate
- [ ] Context managers are used for resource handling

## Exercises

### exercise_1_basic_exceptions.py

Practice catching and raising exceptions.

Tasks:
1. Write a function `divide(a: float, b: float) -> float` that returns `a / b`. Raise a `ValueError` with a clear message if `b == 0`.
2. Write a function `get_element(lst: list, index: int)` that returns `lst[index]`. Catch `IndexError` and print a friendly message instead of crashing.
3. Write a function `parse_int(s: str) -> int` that tries to convert a string to int. Return `None` if conversion fails (catch `ValueError`).
4. Write a function `read_file(path: str) -> str` that reads a file. If the file doesn't exist, return an empty string instead of crashing.

### exercise_2_custom_exceptions.py

Define and use custom exceptions.

Tasks:
1. Define `class ValidationError(Exception)` — raised when input data is invalid.
2. Write a function `validate_user(name: str, age: int) -> dict` that raises `ValidationError` if:
   - `name` is empty or whitespace-only
   - `age` is not a positive integer
   Returns `{"name": name, "age": age}` on success.
3. Define `class InsufficientFundsError(Exception)` with a `balance` and `amount` attribute.
4. Write a class `BankAccount` with:
   - `__init__(self, balance: float)` — initial balance, must be >= 0 (raise `ValueError` otherwise)
   - `deposit(self, amount: float)` — add to balance, amount must be > 0
   - `withdraw(self, amount: float)` — subtract from balance, raise `InsufficientFundsError` if amount > balance
   - `balance` property that returns the current balance

### exercise_3_context_managers.py

Practice writing and using context managers.

Tasks:
1. Write a context manager `timer(label: str)` that prints how long a block took (use `time.monotonic()`).
2. Write a context manager `suppress_errors(*exceptions)` that silently catches the given exception types (like a scoped `contextlib.suppress`).
3. Write a function `read_lines(path: str) -> list[str]` that uses a `with open(...)` block to read lines from a file, stripping newlines.

## Tests

See `tests/` for pytest-based tests covering happy paths and error paths.
