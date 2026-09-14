#!/usr/bin/env python3
"""Exercise 1: Basic exceptions — catch, raise, and handle errors."""

import pathlib


def divide(a: float, b: float) -> float:
    """Return a / b. Raise ValueError if b == 0."""
    if b == 0:
        raise ValueError("division by zero is not allowed")
    return a / b


def get_element(lst: list, index: int):
    """Return lst[index]. Print a friendly message on IndexError instead of crashing."""
    try:
        return lst[index]
    except IndexError:
        print(f"index {index} is out of range for list of length {len(lst)}")
        return None


def parse_int(s: str) -> int | None:
    """Try to convert s to int. Return None if conversion fails."""
    try:
        return int(s)
    except ValueError:
        return None


def read_file(path: str) -> str:
    """Read a file and return its contents. Return empty string if file doesn't exist."""
    try:
        return pathlib.Path(path).read_text()
    except FileNotFoundError:
        return ""


if __name__ == "__main__":
    print(divide(10, 2))
    try:
        print(divide(10, 0))
    except ValueError as e:
        print("caught:", e)

    print(get_element([1, 2, 3], 1))
    print(get_element([1, 2, 3], 99))

    print(parse_int("42"))
    print(parse_int("hello"))
    print(read_file(__file__))
    print(read_file("/nonexistent/file.txt"))
