# Project 06: Testing in C

**Difficulty:** intermediate
**Prerequisites:** project 01 (basics), project 02 (pointers and memory), project 05 (errors and assertions)

## Goals

- Understand test-driven development (TDD): write tests before implementations.
- Build a simple unit test framework from scratch (or use a minimalist approach).
- Write comprehensive unit tests that exercise all code paths.
- Use mocking and dependency injection for testability.
- Automate test execution with Makefile.
- Understand code coverage concepts (identifying untested paths).

## Concepts

- Test structure: setup, execute, verify, teardown (Arrange-Act-Assert).
- Unit test frameworks: custom minimal framework or CUnit.
- Mock objects: replace real implementations with test doubles.
- Test fixtures: common setup/teardown for multiple tests.
- Parameterized tests: run the same test with different inputs.
- Test runners: compile and execute tests, report results.
- Integration tests vs unit tests: testing in isolation vs with dependencies.

## Completion checklist

- [ ] Write a simple unit test framework with assertion macros (assert_equals, assert_true, etc.).
- [ ] Implement functions under test (simple math/string utilities) that pass their tests.
- [ ] Write test cases that cover success paths, error paths, and boundary conditions.
- [ ] Use a test fixture (setup/teardown) for common initialization.
- [ ] Write at least one parameterized test that runs the same test with multiple inputs.
- [ ] Create a mock object or test double for a dependency (e.g., replace a file I/O function).
- [ ] Write integration tests that test multiple functions together.
- [ ] Build and run all tests with a single `make test` command.
- [ ] Display a test report showing passed/failed counts and failing test names.

## Exercises

### Exercise 1: Minimal test framework

File: `test_framework.h`

Build a minimal header-only test framework with macros:
- `TEST_START(name)` / `TEST_END()`: define a test block.
- `ASSERT_EQ(expected, actual)` / `ASSERT_NE(a, b)`: integer comparisons.
- `ASSERT_STR_EQ(expected, actual)`: string comparisons.
- `ASSERT_TRUE(cond)` / `ASSERT_FALSE(cond)`: boolean tests.
- Track pass/fail counts and print a summary.

### Exercise 2: Test string utilities

Files: `string_utils.h`, `string_utils.c`, `test_string_utils.c`

Implement string utilities:
- `int str_equals(const char *a, const char *b)`: compare strings (like strcmp, but returns 1/0).
- `char* str_concat(const char *a, const char *b, char *out, int out_len)`: concatenate strings; return out or NULL on error.
- `int str_count_char(const char *s, char c)`: count occurrences of a character.

Write unit tests for each function covering:
- Success cases (normal strings).
- Boundary cases (empty strings, single character).
- Error cases (NULL pointers, buffer overflow).

### Exercise 3: Test array functions

Files: `array_utils.h`, `array_utils.c`, `test_array_utils.c`

Implement array utilities:
- `int array_sum(int *arr, int len)`: sum all elements.
- `int array_max(int *arr, int len)`: find maximum (assume len > 0).
- `void array_reverse(int *arr, int len)`: reverse in-place.
- `int array_search(int *arr, int len, int value)`: return index of value or -1 if not found.

Write unit tests with:
- Normal cases (various array sizes and values).
- Boundary cases (single-element arrays, empty arrays where applicable).
- Error cases (NULL pointers).
- Parameterized tests for array_search with multiple values.

### Exercise 4: Fixture-based tests

File: `test_with_fixtures.c`

Write tests that use setup/teardown fixtures:
- A `File` struct that manages a temporary file handle.
- Setup: create a test file with known content.
- Cleanup: close and delete the file.
- Test: write/read operations, verifying state changes.

Demonstrate that the same fixture is initialized fresh for each test.

### Exercise 5: Mocking and dependency injection

Files: `calculator.h`, `calculator.c`, `test_calculator.c`

Implement a calculator that "logs" results to a callback:
- `typedef void (*log_func)(const char *msg);`
- `int add(int a, int b, log_func callback)`: compute and log the result.
- `int divide(int a, int b, log_func callback)`: compute and log the result; return -1 if b==0.

Write tests that:
- Inject a mock log function that records calls.
- Verify that the correct results are computed.
- Verify that the log function was called with the expected message.
- Test error cases (division by zero).

## Hints

- TDD workflow: write a failing test, implement code to pass it, refactor.
- A minimal test framework need only track pass/fail and print results. Avoid over-engineering.
- Use assertion macros that print file, line number, and expected/actual values on failure.
- Test fixtures reduce duplication: setup runs before each test, teardown after each test.
- Mock objects replace real dependencies (e.g., file I/O, network I/O) with simpler test versions.
- Parameterized tests iterate over multiple inputs with the same test logic.
- A Makefile can compile all tests into a single executable or separate executables, then run them.
- Code coverage (percentage of lines executed by tests) is a useful metric but not a goal in itself — aim for meaningful tests, not high coverage.
