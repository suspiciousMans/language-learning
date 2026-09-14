"""mypackage — small utility modules for learning package structure."""

__version__ = "0.1.0"

from .math_utils import factorial, is_prime, gcd
from .string_utils import is_palindrome, word_count

__all__ = ["factorial", "is_prime", "gcd", "is_palindrome", "word_count"]
