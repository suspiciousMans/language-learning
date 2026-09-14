# 06 — Testing in OCaml

**Difficulty:** intermediate  
**Prerequisites:** 01, 02, 03, 05

## Goals

- Write unit tests with OUnit2.
- Use test fixtures and setup/teardown.
- Write property-based tests with QCheck.
- Understand test organization and naming.
- Follow Test-Driven Development (TDD) discipline.
- Build confidence in code through comprehensive testing.

## Concepts

- **Unit testing:** test individual functions in isolation.
- **Test fixtures:** reusable test data and setup/teardown code.
- **Assertions:** `assert_equal`, `assert_bool`, etc.
- **Property-based testing:** generate random inputs and verify properties.
- **Test organization:** group related tests, clear test names.
- **TDD:** write tests before code, then implement to pass them.

## Completion checklist

- [ ] You can write a simple unit test with OUnit2.
- [ ] You can use `assert_equal` with custom printers.
- [ ] You can organize tests into test suites.
- [ ] You can write a test fixture with setup and teardown.
- [ ] You can understand basic QCheck property-based tests.
- [ ] You can write a property that holds for all inputs.
- [ ] You can debug a failing test.
- [ ] You can write tests before implementing the function (TDD).

## Starter files

| File | Topic |
|------|-------|
| [`math_functions.ml`](math_functions.ml) | functions to be tested |
| [`test_math.ml`](test_math.ml) | unit tests with OUnit2 |
| [`list_functions.ml`](list_functions.ml) | list operations |
| [`test_list.ml`](test_list.ml) | testing list operations |
| [`property_tests.ml`](property_tests.ml) | property-based tests with QCheck |

### How to run

```sh
dune build
dune runtest
```

### Tests

```sh
# Run all tests
dune runtest

# Run a specific test
dune runtest -- --verbose
```

## Hints

- Good test names describe what they test: `test_square_positive`, `test_reverse_empty`.
- Use custom printers in `assert_equal` to see helpful error messages.
- Organize tests into logical groups with descriptive names.
- Write the test first, then implement the function to pass it (TDD).
- Property-based tests find edge cases you didn't think of.
