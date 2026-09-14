#!/usr/bin/env python3
"""Exercise 2: Control flow — conditionals and loops."""


def grade(score: int) -> str:
    """Return a letter grade for a numeric score.

    >= 90: A, >= 80: B, >= 70: C, >= 60: D, else F.
    """
    # TODO: implement
    pass


def sum_to(n: int) -> int:
    """Return the sum of integers from 1 to n (inclusive)."""
    # TODO: implement using a for loop
    pass


def fizzbuzz(n: int) -> list[str]:
    """Return a fizzbuzz list for numbers 1 through n.

    - Multiples of 3: "fizz"
    - Multiples of 5: "buzz"
    - Multiples of both: "fizzbuzz"
    - Otherwise: the number as a string
    """
    # TODO: implement
    pass


if __name__ == "__main__":
    # Quick smoke tests — replace with real calls once implemented
    print(grade(95))
    print(sum_to(10))
    print(fizzbuzz(15))
