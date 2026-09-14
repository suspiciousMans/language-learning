"""calculator — simple math and string functions for practicing testing."""

from typing import Union


Number = Union[int, float]


def add(a: Number, b: Number) -> Number:
    """Return the sum of a and b."""
    return a + b


def divide(a: Number, b: Number) -> float:
    """Return a divided by b.

    Raises ValueError if b is zero.
    """
    if b == 0:
        raise ValueError("division by zero")
    return a / b


def fibonacci(n: int) -> int:
    """Return the nth Fibonacci number (0-indexed).

    fib(0) == 0, fib(1) == 1.
    """
    if n < 0:
        raise ValueError("n must be non-negative")
    if n == 0:
        return 0
    if n == 1:
        return 1
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b


def reverse_string(s: str) -> str:
    """Return s reversed."""
    return s[::-1]
