# 03 — Data Structures

**Difficulty:** beginner→intermediate · **Prerequisites:** 01, 02

## Goals

- Use the standard library's core collections.
- Understand `String` vs `&str`.
- Work confidently with `Option` and `Result`.
- Master pattern matching with `match`, `if let`, and `while let`.
- Define enums that carry data.

## Concepts

- `Vec<T>`: push, pop, indexing, iteration
- `HashMap<K, V>` and `HashSet<T>`: insertion, lookup, iteration
- `String` (owned) vs `&str` (borrowed slice)
- `Option<T>`: `Some`/`None`, combinators
- `Result<T, E>`: `Ok`/`Err`, error propagation
- `match`, `if let`, `while let` patterns
- Enums with data (e.g. `enum Message { Quit, Move { x: i32, y: i32 }, Write(String), ChangeColor(i32, i32, i32) }`)

## Completion checklist

- [ ] Complete each exercise in `src/`.
- [ ] All exercises compile and pass tests.
- [ ] You can choose correctly between `String` and `&str` in a function signature.

## Starter files

- `Cargo.toml` — library crate
- `src/lib.rs` — re-exports exercise modules
- `src/exercise_vec.rs`
- `src/exercise_hashmap.rs`
- `src/exercise_string_vs_str.rs`
- `src/exercise_option_result.rs`
- `src/exercise_pattern_matching.rs`
- `src/exercise_enums_with_data.rs`
