# 05 — Error Handling

**Difficulty:** intermediate · **Prerequisites:** 01, 02, 03

## Goals

- Use `Result` and `Option` combinators fluently.
- Propagate errors with the `?` operator.
- Build custom error types with enums.
- Understand when to panic and when to return a `Result`.
- Document the `thiserror`/`anyhow` pattern.

## Concepts

- `Result<T, E>` and `Option<T>` refresher
- Combinators: `map`, `and_then`, `unwrap_or`, `unwrap_or_else`, `ok_or`, `transpose`
- The `?` operator and `From` coercion
- Custom error types: an enum implementing `std::error::Error` + `Display`
- `thiserror` (derive-based custom errors) and `anyhow` (context-rich dyn errors) — pattern documented, not required to depend on them here
- Panic vs Result: when `unwrap`/`expect` is acceptable (prototypes, tests) vs production code

## Completion checklist

- [ ] Complete each exercise in `src/`.
- [ ] Each exercise has both a happy path and an error path covered by tests.
- [ ] You can explain why a given function returns `Result` instead of panicking.

## Starter files

- `Cargo.toml` — library crate
- `src/lib.rs` — re-exports exercise modules
- `src/exercise_result_option_combinators.rs`
- `src/exercise_propagation.rs`
- `src/exercise_custom_error.rs`
- `src/exercise_panic_vs_result.rs`
