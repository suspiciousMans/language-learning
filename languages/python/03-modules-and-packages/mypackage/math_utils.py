"""math_utils — small mathematical helper functions."""

from math import gcd as _gcd


def factorial(n: int) -> int:
    """Return n! (n factorial). factorial(0) == 1."""
    if n < 0:
        raise ValueError("factorial is not defined for negative integers")
    result = 1
    for i in range(2, n + 1):
        result *= i
    return result


def is_prime(n: int) -> bool:
    """Return True if n is a prime number."""
    if n < 2:
        return False
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    for i in range(3, int(n**0.5) + 1, 2):
        if n % i == 0:
            return False
    return True


def gcd(a: int, b: int) -> int:
    """Return the greatest common divisor of a and b."""
    return _gcd(abs(a), abs(b))


if __name__ == "__main__":
    print("factorial(5) =", factorial(5))
    print("is_prime(17) =", is_prime(17))
    print("gcd(48, 18) =", gcd(48, 18))
