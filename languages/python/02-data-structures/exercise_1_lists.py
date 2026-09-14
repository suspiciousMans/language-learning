#!/usr/bin/env python3
"""Exercise 1: Lists — manipulation, slicing, and comprehensions."""


def squares(n: int) -> list[int]:
    """Return a list of squares from 1 to n using a list comprehension."""
    # TODO: implement
    pass


def filter_even(numbers: list[int]) -> list[int]:
    """Return only the even numbers from the input list."""
    # TODO: implement
    pass


def running_sum(numbers: list[int]) -> list[int]:
    """Return the prefix-sum list: each element is the sum of all previous + itself."""
    # TODO: implement
    pass


def flatten(matrix: list[list]) -> list:
    """Flatten a 2D list into a 1D list."""
    # TODO: implement
    pass


if __name__ == "__main__":
    print(squares(5))
    print(filter_even([1, 2, 3, 4, 5, 6]))
    print(running_sum([1, 2, 3, 4]))
    print(flatten([[1, 2], [3, 4], [5]]))
