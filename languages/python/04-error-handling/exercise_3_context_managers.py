#!/usr/bin/env python3
"""Exercise 3: Context managers — manage resources with `with` blocks."""

import time
from contextlib import contextmanager


@contextmanager
def timer(label: str):
    """Print how long a block of code took to execute."""
    start = time.monotonic()
    try:
        yield
    finally:
        elapsed = time.monotonic() - start
        print(f"{label}: {elapsed:.3f}s")


@contextmanager
def suppress_errors(*exceptions):
    """Silently catch the given exception types within the block."""
    try:
        yield
    except exceptions:
        pass


def read_lines(path: str) -> list[str]:
    """Read lines from a file, stripping newlines. Use a `with open(...)` block."""
    with open(path) as f:
        return [line.rstrip("\n") for line in f]


if __name__ == "__main__":
    with timer("sleep"):
        time.sleep(0.1)

    with suppress_errors(ZeroDivisionError):
        print("this runs")
        1 / 0
        print("this does not")

    print(read_lines(__file__))
