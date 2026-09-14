# 03 — Modules and Packages

## Goals

Understand how Python organizes code into modules and packages. Learn to create your own package, manage dependencies with `pip` and `requirements.txt`, and use third-party libraries.

## Concepts

- Modules: `.py` files as importable units
- Packages: directories with `__init__.py`
- Import mechanics: `import`, `from X import Y`, `as` aliasing
- Absolute vs. relative imports
- `__name__ == "__main__"` guard
- `pip` and PyPI
- `requirements.txt` for dependency tracking
- Virtual environments (brief intro)
- Standard library highlights: `os`, `sys`, `pathlib`, `json`

## Completion Checklist

- [ ] The package skeleton in this project imports and runs correctly
- [ ] `python3 -m projects.03-modules-and-packages.mypackage` (or equivalent) executes
- [ ] `requirements.txt` lists at least one dependency (even if not installed)
- [ ] Each module has a docstring and the package `__init__.py` exposes the public API

## Package skeleton

Create the following structure inside `projects/03-modules-and-packages/`:

```
mypackage/
├── __init__.py      # exposes public API, version
├── math_utils.py    # small math helpers (factorial, is_prime, gcd)
└── string_utils.py  # small string helpers (is_palindrome, word_count)
```

Each module should have:
- A module-level docstring
- At least two functions with docstrings
- A `if __name__ == "__main__":` block with a quick demo

The `__init__.py` should:
- Define `__version__ = "0.1.0"`
- Import and expose selected functions from the submodules

## requirements.txt

Create a `requirements.txt` at the project root listing:
- One or two real PyPI packages (e.g., `requests`, `pydantic`) — learner installs as needed
- A comment explaining what each is for

## exercises

### exercise_imports.py

A script that imports from the `mypackage` package and uses its functions. Demonstrates:
- `import mypackage`
- `from mypackage import math_utils`
- `from mypackage.math_utils import factorial as fact`

### exercise_requirements.py

A script that reads `requirements.txt`, parses the package names, and prints them. (No network call — just file parsing.) Demonstrates `pathlib` or `open()`.

## Solutions

See `solutions/solution.md` for a reference package layout and import examples.
