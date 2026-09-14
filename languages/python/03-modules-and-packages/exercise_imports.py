#!/usr/bin/env python3
"""Exercise: imports — demonstrate different ways to import from mypackage.

Fill in the calls to use functions from the mypackage package.
"""

# 1. Import the whole package
import sys
from pathlib import Path

# Add the project root so mypackage is importable from this script.
# (In real usage you'd install the package or use a proper package layout.)
project_root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(project_root / "projects" / "03-modules-and-packages"))

import mypackage

# 2. Import a submodule
from mypackage import math_utils

# 3. Import a specific function with an alias
from mypackage.math_utils import factorial as fact
from mypackage.string_utils import is_palindrome

# TODO: use the imported functions
print("mypackage version:", mypackage.__version__)
print("math_utils.factorial(5):", math_utils.factorial(5))
print("fact(6):", fact(6))
print("is_palindrome('racecar'):", is_palindrome("racecar"))
