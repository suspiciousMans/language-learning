#!/usr/bin/env python3
"""Exercise 3: Sets and tuples — uniqueness, operations, and unpacking."""


def common_elements(a: list, b: list) -> set:
    """Return the set of elements common to both lists."""
    # TODO: implement
    pass


def unique_words(sentences: list[str]) -> set[str]:
    """Return the set of all unique words across all sentences.

    Lowercase and split on whitespace.
    """
    # TODO: implement
    pass


def categorize(numbers: list[int]) -> dict[str, set[int]]:
    """Categorize numbers into positive, negative, and zero sets.

    Returns {"positive": ..., "negative": ..., "zero": ...}.
    """
    # TODO: implement
    pass


def swap_pairs(items: list) -> list:
    """Swap adjacent pairs: [a, b, c, d] -> [b, a, d, c].

    Odd-length lists: last element stays in place.
    Use tuple unpacking.
    """
    # TODO: implement
    pass


if __name__ == "__main__":
    print(common_elements([1, 2, 3], [2, 3, 4]))
    print(unique_words(["hello world", "hello there"]))
    print(categorize([1, -2, 0, 3, -4, 0]))
    print(swap_pairs([1, 2, 3, 4, 5]))
