# 05 — Error Handling

**Difficulty:** intermediate  
**Prerequisites:** 01, 02

## Goals

- Understand the `option` type and its use for missing values.
- Work with the `result` type for error recovery.
- Use pattern matching to handle both success and failure.
- Chain operations with `Option.bind` and `Result.bind`.
- Build reliable error-handling pipelines.
- Distinguish when to use `option`, `result`, and exceptions.

## Concepts

- **Option type:** `Some x` represents a value, `None` represents absence.
- **Result type:** `Ok x` for success, `Error e` for failure with an error description.
- **Bind operations:** `Option.bind` and `Result.bind` for chaining dependent computations.
- **Exception handling:** raising and catching `exception`s for truly unexpected errors.
- **Error messages:** include context to help users understand what went wrong.
- **Railway-oriented programming:** chain operations that may fail.

## Completion checklist

- [ ] You can use `option` to represent optional values.
- [ ] You can pattern match on `option` types.
- [ ] You can use `Result.map` to transform success values.
- [ ] You can use `Result.bind` to chain operations.
- [ ] You can handle both Ok and Error cases in a `match`.
- [ ] You can write a function that returns `result`.
- [ ] You can use `Result.fold` to extract a value from a result.
- [ ] You understand when to use `option` vs `result` vs exceptions.

## Starter files

| File | Topic |
|------|-------|
| [`options.ml`](options.ml) | using Option: Some and None |
| [`results.ml`](results.ml) | using Result: Ok and Error |
| [`chaining.ml`](chaining.ml) | bind operations, railway-oriented programming |
| [`validation.ml`](validation.ml) | building validators that return results |
| [`error_recovery.ml`](error_recovery.ml) | handling errors and recovering |

### How to run

```sh
dune build
dune exec options
dune exec validation
```

### Tests

```sh
dune runtest
```

## Hints

- Use `option` when a value might not exist but failure is not exceptional.
- Use `result` when you want to communicate why something failed.
- Use exceptions for truly unexpected, unrecoverable errors.
- `bind` lets you chain operations that return `option` or `result` without nested pattern matches.
- Think: "Option for maybe, Result for why-not, Exception for oops!"
