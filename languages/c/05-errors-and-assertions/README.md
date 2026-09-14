# Project 05: Errors and Assertions

**Difficulty:** intermediate
**Prerequisites:** project 01 (basics), project 02 (pointers and memory), project 04 (modularity)

## Goals

- Understand error handling in C: return codes and errno.
- Use assertions to detect programming errors and unexpected conditions.
- Implement pre-conditions, post-conditions, and invariant checks.
- Practice defensive programming: validate inputs and handle edge cases.
- Distinguish between recoverable errors and fatal logic errors.

## Concepts

- Error return codes: functions return status (0 for success, non-zero for failure).
- `errno`: the global error variable; `perror()` and `strerror()`.
- `assert()` and `assert.h`: compile-time debug checks; disable with `-DNDEBUG`.
- Defensive programming: check preconditions, postconditions, invariants.
- Error handling patterns: early return, error chaining, cleanup on failure.
- Testing error paths: ensure error conditions are properly detected and reported.

## Completion checklist

- [ ] Write a function that returns an error code (0 for success, non-zero for failure).
- [ ] Use `assert()` to check preconditions (e.g., pointer is not NULL).
- [ ] Use `assert()` to check postconditions (e.g., array is sorted after a sort function).
- [ ] Call `perror()` to print an error message associated with `errno`.
- [ ] Implement a division function that checks for division by zero and returns an error code.
- [ ] Write a string validation function and return error codes for invalid input.
- [ ] Implement cleanup code that always runs (use manual bookkeeping or a pattern like goto cleanup).
- [ ] Write unit tests that verify correct error handling (test both success and failure paths).
- [ ] Compile with and without `-DNDEBUG` to verify assertion behavior.

## Exercises

### Exercise 1: Simple error codes

File: `ex_error_codes.c`

Write functions that return error codes:
- `int divide(int a, int b, int *result)`: return 0 on success, -1 if b == 0. Set `*result` only on success.
- `int parse_int(const char *str, int *out)`: return 0 if successful, -1 if the string is not a valid integer.

In `main()`, call these functions and print error messages when they fail.

### Exercise 2: Assertions in action

File: `ex_assertions.c`

Write functions and use assertions to validate assumptions:
- `void sort_array(int *arr, int len)`: use `assert(arr != NULL)` before processing. After sorting, use `assert_sorted(arr, len)` to verify the result.
- `int* find_max(int *arr, int len)`: use precondition `assert(len > 0)` and postcondition `assert(*result >= all other elements)`.
- Use `assert()` for internal logic checks (e.g., loop invariants).

Compile with `-DNDEBUG` to show that assertions disappear.

### Exercise 3: Defensive validation

File: `ex_defensive.c`

Write a "user input validator" module:
- `int validate_email(const char *email)`: return 1 if email looks valid (contains `@`), 0 otherwise.
- `int validate_age(int age)`: return 1 if age is in range [0, 150], 0 otherwise.
- `int validate_password(const char *pwd)`: return 1 if length >= 8, 0 otherwise.

Test all paths: valid inputs, boundary cases, invalid inputs.

### Exercise 4: Error propagation

File: `ex_error_propagation.c`

Write a small program that computes a result from multiple operations, each of which can fail:
- `int read_numbers(const char *input, int *a, int *b)`: parse two integers from a string, return error code.
- `int compute(int a, int b, int *result)`: apply some operation (e.g., division, sqrt of difference), return error code.

In `main()`, call both functions and propagate errors upward: if `read_numbers()` fails, stop; if `compute()` fails, report it.

### Exercise 5: Unit tests for error handling

File: `test_errors.c`

Write unit tests using a simple assertion-based framework (or just `assert()` from libc):
- Test successful cases (divide by non-zero, valid parse, valid validation).
- Test error cases (divide by zero, invalid parse, invalid validation).
- Verify that error codes are set correctly.
- Verify that output is not modified on error.

Compile both the exercise code and the tests, then run them to verify error handling.

## Hints

- An error-handling function should be consistent: always return error codes in the same way (e.g., 0 = success, negative = failure).
- Use `assert()` for conditions that should never happen if the code is correct (programmer errors). Use error codes for conditions that can happen at runtime (user input, resource exhaustion).
- The `<errno.h>` header defines `errno`, `EDOM`, `ERANGE`, etc. Call `perror(msg)` to print the current `errno`.
- To disable assertions, compile with `-DNDEBUG` and assertions vanish (zero overhead).
- Test error paths as rigorously as you test success paths. A function that never fails is often more dangerous than one that fails correctly.
