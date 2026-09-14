# Project 08 — Testing and Quality

Write tests using Node's built-in test runner. Learn TDD: write tests first, then code. Understand assertions and test coverage.

## Goals

- Use the Node built-in test runner.
- Write assertions with `assert`.
- Follow Test-Driven Development (TDD): RED-GREEN-REFACTOR.
- Test async code.
- Understand test coverage and why it matters.
- Use mocking and stubbing (basic).

## Concepts

### Node Built-in Test Runner

- Use `node --test` to run test files.
- Test files should export nothing; they have side effects (running tests).
- Use `import test from 'node:test'` to access the test function.

### Assertions

- `assert.strictEqual(actual, expected)` — strict equality.
- `assert.deepStrictEqual(actual, expected)` — deep object comparison.
- `assert.throws(fn)` — function should throw.
- `assert.rejects(promise)` — Promise should reject.
- `assert.match(str, regex)` — string should match regex.

### Test Structure

- One test per behavior.
- Test file names end with `.test.js`.
- Use descriptive test names.
- Arrange-Act-Assert: set up, execute, verify.

### TDD Workflow

1. **RED**: Write a test for a feature that doesn't exist yet.
2. **GREEN**: Write the minimum code to make the test pass.
3. **REFACTOR**: Improve the code without breaking the test.

### Testing Async Code

- Use `async (t)` in the test function.
- Use `assert.rejects()` for Promises that reject.
- `await` Promises to wait for completion.

### Test Coverage

- Coverage reports show what code is executed during tests.
- Goal: high coverage (70-90%), but coverage is not quality.
- Tests should verify behavior, not just execute code.

### Mocking and Stubbing

- Replace real dependencies with test doubles.
- Node 20+ has `node:test` with basic mocking via `mock.method()`.
- Allows testing without external dependencies.

## Prerequisites

Projects 01, 07.

## Completion checklist

- [ ] Write tests using the Node built-in test runner.
- [ ] Use assertions to verify behavior.
- [ ] Write at least one async test.
- [ ] Follow TDD: write a failing test, then code, then refactor.
- [ ] Use `assert.throws()` to test error cases.
- [ ] Organize tests in a logical structure.
- [ ] Understand what code coverage means.
- [ ] Use mock methods to stub dependencies.

## Exercises

### ex1-basic-assertions.js (test file)

- Test basic functions with `assert.strictEqual()` and `assert.deepStrictEqual()`.
- Test error cases with `assert.throws()`.
- Verify that assertions work correctly.

### ex2-array-functions.test.js (test for a utility module)

- Create a module with array manipulation functions.
- Write tests for `.map()`, `.filter()`, `.reduce()` behavior.
- Use TDD: write tests first.

### ex3-string-functions.test.js (test for a utility module)

- Create a module with string functions (uppercase, reverse, etc.).
- Write tests for each function.
- Use TDD.

### ex4-async-tests.test.js

- Write async functions that return Promises.
- Use `async (t)` and `await` in tests.
- Use `assert.rejects()` for rejected Promises.
- Test both success and failure cases.

### ex5-object-validation.test.js

- Create a validation module with functions like `isEmail()`, `isPhoneNumber()`.
- Write tests for valid and invalid inputs.
- Use `assert.match()` for regex validation.

### ex6-mock-dependencies.test.js

- Create a module that depends on another module or external API.
- Use `t.mock.method()` to replace methods.
- Test the module in isolation.

### ex7-coverage-and-quality.test.js

- Write tests for a module with multiple branches and edge cases.
- Ensure all code paths are tested.
- Document which lines have coverage.

## Running exercises

```bash
node --test exercises/*.test.js
node --test tests/*.test.js
```

## What "done" looks like

All tests pass. You've written tests for real functions using TDD. You understand assertions and can test both sync and async code.
