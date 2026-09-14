"""Tests for the calculator module."""

import pytest
import sys
from pathlib import Path

# Make src importable
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from calculator import add, divide, fibonacci, reverse_string


# ---- Fixtures ----

@pytest.fixture
def add_test_cases():
    """Provide a list of (a, b, expected) tuples for add()."""
    return [
        (1, 2, 3),
        (0, 0, 0),
        (-1, 1, 0),
        (1.5, 2.5, 4.0),
        (-5, -3, -8),
    ]


@pytest.fixture
def fibonacci_expected():
    """Return a dict mapping n -> expected fibonacci(n)."""
    return {
        0: 0,
        1: 1,
        2: 1,
        3: 2,
        4: 3,
        5: 5,
        10: 55,
    }


# ---- Tests ----

@pytest.mark.parametrize("a,b,expected", [
    (1, 2, 3),
    (0, 0, 0),
    (-1, 1, 0),
    (1.5, 2.5, 4.0),
])
def test_add_happy(a, b, expected):
    assert add(a, b) == expected


def test_add_with_fixture(add_test_cases):
    for a, b, expected in add_test_cases:
        assert add(a, b) == expected


def test_divide_happy():
    assert divide(10, 2) == 5.0
    assert divide(7, 2) == 3.5


def test_divide_by_zero():
    with pytest.raises(ValueError, match="zero"):
        divide(10, 0)


def test_divide_by_zero_negative():
    with pytest.raises(ValueError):
        divide(0, 0)


@pytest.mark.parametrize("n,expected", [
    (0, 0),
    (1, 1),
    (2, 1),
    (3, 2),
    (4, 3),
    (5, 5),
    (10, 55),
])
def test_fibonacci(n, expected):
    assert fibonacci(n) == expected


def test_fibonacci_with_fixture(fibonacci_expected):
    for n, expected in fibonacci_expected.items():
        assert fibonacci(n) == expected


def test_fibonacci_negative():
    with pytest.raises(ValueError, match="non-negative"):
        fibonacci(-1)


def test_reverse_string_happy():
    assert reverse_string("hello") == "olleh"


def test_reverse_string_empty():
    assert reverse_string("") == ""


def test_reverse_string_palindrome():
    assert reverse_string("racecar") == "racecar"


def test_reverse_string_unicode():
    assert reverse_string("αβγ") == "γβα"
