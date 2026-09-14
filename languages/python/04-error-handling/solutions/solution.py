# 04 — Error Handling: Reference Solutions

# exercise_1_basic_exceptions.py
# --------------------------------
# def divide(a: float, b: float) -> float:
#     if b == 0:
#         raise ValueError("division by zero is not allowed")
#     return a / b
#
# def get_element(lst: list, index: int):
#     try:
#         return lst[index]
#     except IndexError:
#         print(f"index {index} is out of range for list of length {len(lst)}")
#         return None
#
# def parse_int(s: str) -> int | None:
#     try:
#         return int(s)
#     except ValueError:
#         return None
#
# def read_file(path: str) -> str:
#     try:
#         return pathlib.Path(path).read_text()
#     except FileNotFoundError:
#         return ""


# exercise_2_custom_exceptions.py
# --------------------------------
# class ValidationError(Exception):
#     """Raised when input data fails validation."""
#
# class InsufficientFundsError(Exception):
#     def __init__(self, balance: float, amount: float):
#         self.balance = balance
#         self.amount = amount
#         super().__init__(
#             f"cannot withdraw {amount}: balance is {balance}"
#         )
#
# def validate_user(name: str, age: int) -> dict:
#     if not name or not name.strip():
#         raise ValidationError("name must not be empty")
#     if not isinstance(age, int) or age <= 0:
#         raise ValidationError("age must be a positive integer")
#     return {"name": name, "age": age}
#
# class BankAccount:
#     def __init__(self, balance: float):
#         if balance < 0:
#             raise ValueError("initial balance must be >= 0")
#         self._balance = balance
#
#     def deposit(self, amount: float) -> None:
#         if amount <= 0:
#             raise ValueError("deposit amount must be > 0")
#         self._balance += amount
#
#     def withdraw(self, amount: float) -> None:
#         if amount > self._balance:
#             raise InsufficientFundsError(self._balance, amount)
#         if amount <= 0:
#             raise ValueError("withdrawal amount must be > 0")
#         self._balance -= amount
#
#     @property
#     def balance(self) -> float:
#         return self._balance


# exercise_3_context_managers.py
# --------------------------------
# @contextmanager
# def timer(label: str):
#     start = time.monotonic()
#     try:
#         yield
#     finally:
#         elapsed = time.monotonic() - start
#         print(f"{label}: {elapsed:.3f}s")
#
# @contextmanager
# def suppress_errors(*exceptions):
#     try:
#         yield
#     except exceptions:
#         pass
#
# def read_lines(path: str) -> list[str]:
#     with open(path) as f:
#         return [line.rstrip("\n") for line in f]
