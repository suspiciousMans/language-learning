# 02 — Ownership and Borrowing

**Difficulty:** beginner→intermediate · **Prerequisites:** 01

## Goals

- Internalize Rust's ownership model.
- Use references (`&` and `&mut`) correctly.
- Work with slices and understand lifetime elision.
- Read and fix borrow-checker errors.

## Concepts

- Ownership: each value has one owner; dropping runs at end of scope
- Moving vs copying (non-Copy types)
- Borrowing: shared references `&T` and mutable references `&mut T`
- The borrow rules: one mutable XOR many shared
- Slices (`&[T]`, `&str`) as borrowed views
- Lifetime elision rules and common patterns (functions returning references, struct fields that borrow)

## Completion checklist

- [ ] Complete each exercise in `src/`.
- [ ] Each exercise deliberately fails to compile at first — your job is to fix it.
- [ ] You can explain why the borrow checker rejected your first attempt and how your fix satisfies it.

## Starter files

- `Cargo.toml` — library crate
- `src/lib.rs` — re-exports exercise modules
- `src/exercise_ownership.rs` — ownership moves
- `src/exercise_borrowing.rs` — `&` and `&mut`
- `src/exercise_slices.rs` — slice and &str exercises
- `src/exercise_lifetimes.rs` — lifetime elision and common patterns
