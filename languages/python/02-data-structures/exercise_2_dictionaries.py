#!/usr/bin/env python3
"""Exercise 2: Dictionaries — key-value operations and counting patterns."""


def word_count(text: str) -> dict[str, int]:
    """Count occurrences of each word (lowercased) in text.

    Split on whitespace.
    """
    # TODO: implement
    pass


def invert_dict(d: dict) -> dict:
    """Swap keys and values.

    If multiple keys share a value, collect them in a list.
    """
    # TODO: implement
    pass


def merge_dicts(a: dict, b: dict) -> dict:
    """Merge two dicts. For keys in both, b's value wins."""
    # TODO: implement
    pass


def top_n(d: dict[str, int], n: int) -> list[tuple[str, int]]:
    """Return the top n key-value pairs sorted by value descending."""
    # TODO: implement
    pass


if __name__ == "__main__":
    print(word_count("hello world hello"))
    print(invert_dict({"a": 1, "b": 2, "c": 1}))
    print(merge_dicts({"a": 1, "b": 2}, {"b": 3, "c": 4}))
    print(top_n({"apple": 5, "banana": 3, "cherry": 7}, 2))
