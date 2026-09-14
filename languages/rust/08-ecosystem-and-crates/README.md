# 08 — Ecosystem and Crates

**Difficulty:** advanced · **Prerequisites:** 01

## Goals

- Add an external dependency to `Cargo.toml`.
- Use `serde` and `serde_json` to serialize and deserialize a struct.
- Read and write Cargo.toml dependency documentation.

## Concepts

- Cargo.toml `[dependencies]` section
- Semver versioning and caret requirements (`"1.0"`)
- `serde` derive macros: `Serialize`, `Deserialize`
- `serde_json::to_string`, `serde_json::from_str`
- Choosing crate versions: reading crates.io, CHANGELOG, and docs.rs

## Completion checklist

- [ ] Add `serde` and `serde_json` to `Cargo.toml`.
- [ ] Define a struct, derive `Serialize`/`Deserialize`, and serialize/deserialize it in an exercise.
- [ ] All exercises compile and pass tests.
- [ ] You can explain what a caret requirement (`^1.0`) means.

## Starter files

- `Cargo.toml` — with serde/serde_json dependency placeholders (learner fills versions)
- `src/lib.rs` — re-exports exercise modules
- `src/exercise_serde.rs`
- `README.md` — includes Cargo.toml docs
