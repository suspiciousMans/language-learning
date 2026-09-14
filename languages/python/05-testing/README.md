# 05 — Testing

## Goals

Learn how to write tests in Python using `pytest`. Write tests that catch bugs, document intended behavior, and run fast.

## Concepts

- pytest basics: test discovery, assertions, running tests
- Assertions: `assert` with expressions, `pytest.raises`
- Fixtures: `@pytest.fixture`, dependency injection, scope
- Parametrize: `@pytest.mark.parametrize` for data-driven tests
- Mocking: `unittest.mock.patch`, when and why to mock
- Test organization: `tests/` directory, naming conventions
- Coverage (brief intro): `pytest-cov`

## Completion Checklist

- [ ] `pytest projects/05-testing/tests/ -v` passes all tests
- [ ] The function under test (`src/calculator.py`) has at least 3 public functions
- [ ] Tests use at least one fixture and one parametrize marker
- [ ] Edge cases and error paths are tested

## Function under test

The module `src/calculator.py` provides:

- `add(a, b)` — return a + b
- `divide(a, b)` — return a / b; raise `ValueError` on division by zero
- `fibonacci(n)` — return the nth Fibonacci number (0-indexed: fib(0)=0, fib(1)=1)
- `reverse_string(s)` — return s reversed

## Exercises

### test_calculator.py

Write tests for the calculator module.

Requirements:
1. At least one test per function (happy path).
2. Use `@pytest.mark.parametrize` to test `add` with multiple input pairs.
3. Use a fixture to provide a pre-built Calculator-like context (e.g., a dict of test cases).
4. Test that `divide` raises `ValueError` on zero divisor.
5. Test edge cases: `fibonacci(0)`, `fibonacci(1)`, `reverse_string("")`.

### test_mock_example.py

Write a test that mocks an external dependency.

Tasks:
1. Create a function `get_weather(city: str) -> dict` in `src/weather.py` that calls `requests.get(...)` and returns JSON.
2. Write a test that mocks `requests.get` and asserts the function parses the response correctly without making a real network call.

## Running tests

```bash
cd projects/05-testing
pytest tests/ -v
```

Install pytest: `pip install pytest`
