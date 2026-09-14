#!/usr/bin/env python3
"""Reference solutions for the 01-basics exercises.

Copy or adapt these once you've attempted the exercises yourself.
"""

# --- Exercise 1: Variables ---


def solution_ex1():
    name = "Alice"
    age = 25
    print(f"Hello, {name}! You are {age} years old.")
    age += 1
    print(f"Next year you will be {age}.")


# --- Exercise 2: Control flow ---


def grade(score: int) -> str:
    if score >= 90:
        return "A"
    elif score >= 80:
        return "B"
    elif score >= 70:
        return "C"
    elif score >= 60:
        return "D"
    else:
        return "F"


def sum_to(n: int) -> int:
    total = 0
    for i in range(1, n + 1):
        total += i
    return total


def fizzbuzz(n: int) -> list[str]:
    result = []
    for i in range(1, n + 1):
        if i % 15 == 0:
            result.append("fizzbuzz")
        elif i % 3 == 0:
            result.append("fizz")
        elif i % 5 == 0:
            result.append("buzz")
        else:
            result.append(str(i))
    return result


# --- Exercise 3: Functions ---


def is_palindrome(s: str) -> bool:
    s = s.lower()
    return s == s[::-1]


def factorial(n: int) -> int:
    if n <= 1:
        return 1
    return n * factorial(n - 1)


def apply_twice(f, x):
    return f(f(x))


if __name__ == "__main__":
    print("=== Exercise 1 ===")
    solution_ex1()

    print("\n=== Exercise 2 ===")
    print(grade(95))
    print(grade(82))
    print(grade(40))
    print(sum_to(10))
    print(fizzbuzz(15))

    print("\n=== Exercise 3 ===")
    print(is_palindrome("Racecar"))
    print(is_palindrome("hello"))
    print(factorial(5))
    print(apply_twice(lambda x: x + 1, 5))
