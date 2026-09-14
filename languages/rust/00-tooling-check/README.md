# 00 — Tooling Check

**Difficulty:** trivial · **Prerequisites:** none

## Goals

- Confirm your Rust toolchain is installed and working.
- Learn how to create a Cargo project, run it, and run its tests.
- Get a quick win before the harder projects.

## Concepts

- `cargo new`, `cargo run`, `cargo test`
- The `#[test]` attribute and `assert!` / `assert_eq!` macros
- What "toolchain ok" means: compiler, cargo, and test runner all functional

## Completion checklist

- [ ] Run `cargo run` inside this project and see `toolchain ok` printed.
- [ ] Run `cargo test` and see the test pass.
- [ ] Optionally run `cargo fmt` and `cargo clippy` — both should clean.

## Starter files

- `Cargo.toml` — minimal binary + lib manifest
- `src/main.rs` — prints `toolchain ok`
- `src/lib.rs` — a tiny lib with one unit test
