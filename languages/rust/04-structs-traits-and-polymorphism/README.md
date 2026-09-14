# 04 — Structs, Traits, and Polymorphism

**Difficulty:** intermediate · **Prerequisites:** 01, 02

## Goals

- Define and implement structs.
- Write methods and associated functions.
- Define and implement traits.
- Use generics with trait bounds.
- Apply derive macros.

## Concepts

- Struct definitions: named fields, tuple structs, unit structs
- `impl` blocks: methods (`&self`, `&mut self`, `self`) and associated functions
- Traits: definition, implementation, trait objects (brief)
- Generics with trait bounds: `fn foo<T: Display>(x: T)`
- Derive macros: `Debug`, `Clone`, `Copy`, `PartialEq`, `Eq`, `PartialOrd`, `Ord`, `Hash`
- When to derive vs when to implement manually

## Completion checklist

- [ ] Complete each exercise in `src/`.
- [ ] All exercises compile and pass tests.
- [ ] You can define a trait and implement it for two different types.

## Starter files

- `Cargo.toml` — library crate
- `src/lib.rs` — re-exports exercise modules
- `src/exercise_structs.rs`
- `src/exercise_impl_blocks.rs`
- `src/exercise_traits.rs`
- `src/exercise_generics.rs`
- `src/exercise_derive.rs`
