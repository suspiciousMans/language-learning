"""string_utils — small string helper functions."""

from collections import Counter


def is_palindrome(s: str) -> bool:
    """Return True if s reads the same forwards and backwards (case-insensitive)."""
    s = s.lower()
    return s == s[::-1]


def word_count(text: str) -> dict[str, int]:
    """Count occurrences of each word (lowercased) in text.

    Splits on whitespace.
    """
    counts: dict[str, int] = {}
    for word in text.lower().split():
        counts[word] = counts.get(word, 0) + 1
    return counts


if __name__ == "__main__":
    print("is_palindrome('racecar') =", is_palindrome("racecar"))
    print("word_count('hello world hello') =", word_count("hello world hello"))
