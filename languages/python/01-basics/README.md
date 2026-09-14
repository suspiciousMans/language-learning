# 01 — Basics

## Goals

Learn the core building blocks of Python: variables, data types, control flow, functions, and basic I/O.

## Concepts

- Variables and dynamic typing
- Primitive types: `int`, `float`, `str`, `bool`
- Control flow: `if`/`elif`/`else`, `for` loops, `while` loops
- Functions: definition, arguments, return values, scope
- String formatting and basic I/O (`print`, `input`)
- List literals and basic operations

## Completion Checklist

- [ ] All three exercise files run without errors when filled in
- [ ] Solutions in `solutions/solution.py` are readable and follow PEP 8
- [ ] Each exercise has a clear purpose stated in its docstring

## Exercises

### exercise_1_variables.py

Declare and manipulate variables. Print results to stdout.

Tasks:
1. Create a variable `name` with your name (string) and `age` with your age (int).
2. Print `"Hello, <name>! You are <age> years old."` using an f-string.
3. Increment `age` by 1 and print the new value.

### exercise_2_control_flow.py

Practice conditionals and loops.

Tasks:
1. Write a function `grade(score: int) -> str` that returns `"A"` for >= 90, `"B"` for >= 80, `"C"` for >= 70, `"D"` for >= 60, and `"F"` otherwise.
2. Write a function `sum_to(n: int) -> int` that returns the sum of integers from 1 to n (inclusive) using a `for` loop.
3. Write a function `fizzbuzz(n: int) -> list[str]` that returns a list of strings: `"fizz"` for multiples of 3, `"buzz"` for multiples of 5, `"fizzbuzz"` for multiples of both, and the number as a string otherwise — for numbers 1 through n.

### exercise_3_functions.py

Practice writing reusable functions.

Tasks:
1. Write a function `is_palindrome(s: str) -> bool` that returns True if the string reads the same forwards and backwards (ignore case).
2. Write a function `factorial(n: int) -> int` that returns n! using recursion.
3. Write a function `apply_twice(f, x)` that applies function `f` to `x` twice (i.e., `f(f(x))`).

## Starter files

The exercise files above contain skeleton functions with `pass` or `TODO` comments. Fill them in.

## Solutions

See `solutions/solution.py` for reference implementations.
