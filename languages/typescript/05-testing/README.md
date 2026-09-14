# 05 — Testing

**Difficulty:** intermediate  
**Concepts:** Vitest, typed tests, test runners, mocks  
**Prerequisites:** 01 (basics), 02 (types)

## Goals

Learn to write and run tests for TypeScript code using Vitest. Practice writing typed test suites, assertions, and simple mocks. Understand how a typed test runner catches mistakes at the test level too.

## Concepts

- **Vitest** — Vite-native test runner; fast, ESM-friendly, TypeScript-first.
- **`describe` / `it` / `expect`** — the test structure and assertion API.
- **Typed assertions** — `expect(value).toBe(...)`, `toEqual(...)`, `toBeTypeOf(...)`, etc.
- **Setup and teardown** — `beforeEach`, `afterEach`, `beforeAll`, `afterAll`.
- **Mocks** — `vi.fn()`, `vi.mock()`, spying on functions.
- **Testing typed modules** — importing a module under test and verifying its behavior, including edge cases and error paths.

## What you'll build

A small typed module (`src/counter.ts`) that tracks a counter with bounded operations, plus a test file (`tests/counter.test.ts`) that exercises its behavior with Vitest.

## Exercises

| File | Task |
|------|------|
| `src/counter.ts` | Implement the module under test (starter provided; learner can extend). |
| `tests/counter.test.ts` | Write the test suite for `counter.ts`. |

The module exposes:

- `createCounter(initial?: number)` — returns a counter object.
- `counter.value` — current value.
- `counter.increment()` — increment, respects a max bound.
- `counter.decrement()` — decrement, respects a min bound.
- `counter.reset()` — reset to initial.

## Completion checklist

- [ ] `npx vitest run` passes with all tests green.
- [ ] Tests cover the happy path and boundary conditions (min, max, reset).
- [ ] Tests include an error-path or edge-case assertion.
- [ ] You can explain what `vi.fn()` does and when you'd use it.

## Running the tests

```bash
cd projects/05-testing

# Install deps (one-time):
npm install

# Run tests:
npx vitest run

# Watch mode:
npx vitest
```

## Files in this project

```
05-testing/
├── README.md
├── package.json
├── src/
│   └── counter.ts
└── tests/
    └── counter.test.ts
```
