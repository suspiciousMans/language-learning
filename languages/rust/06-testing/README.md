# 06 — Testing

**Difficulty:** intermediate · **Prerequisites:** 01, 02

## Goals

- Write unit tests inline in source files.
- Write integration tests in a `tests/` directory.
- Understand the difference between the two and when to use each.
- Use `cargo test` effectively.

## Concepts

- `#[cfg(test)]` modules and `#[test]` functions
- Assertions: `assert!`, `assert_eq!`, `assert_ne!`, `panic!` expected failures
- Integration tests: each file in `tests/` is a separate crate
- Test organization: unit tests near implementation, integration tests at the public API boundary
- Tips: test naming, running a single test with `--test`, `--nocapture`

## Completion checklist

- [ ] The `src/bin/hello.rs` binary under `src/` exercises the library.
- [ ] Unit tests in `src/lib.rs` or per-module `#[cfg(test)]` pass.
- [ ] Integration tests in `tests/` pass.
- [ ] Running `cargo test` shows all tests green.

## Starter files

- `Cargo.toml` — library + optional bin target
- `src/lib.rs` — a small public API with inline unit tests
- `src/bin/hello.rs` — a binary that uses the library (optional)
- `tests/integration_tests.rs` — integration tests against the public API
