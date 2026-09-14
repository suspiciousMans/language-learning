#!/usr/bin/env python3
"""Exercise 3: Functions — writing reusable, composable functions."""


def is_palindrome(s: str) -> bool:
    """Return True if s reads the same forwards and backwards (case-insensitive)."""
    # TODO: implement
    pass


def factorial(n: int) -> int:
    """Return n! using recursion. factorial(0) == 1."""
    # TODO: implement recursively
    pass


def apply_twice(f, x):
    """Apply function f to x twice: f(f(x))."""
    # TODO: implement
    pass


if __name__ == "__main__":
    # Quick smoke tests
    print(is_palindrome("racecar"))
    print(is_palindrome("hello"))
    print(factorial(5))
    print(apply_twice(lambda x: x + 1, 5))
