# 07 — Concurrency

**Difficulty:** intermediate→advanced · **Prerequisites:** 02, 03

## Goals

- Spawn threads with `std::thread`.
- Communicate between threads using channels (`std::sync::mpsc`).
- Share mutable state safely with `Arc<Mutex<T>>`.
- Understand the basics of async as the ecosystem direction.

## Concepts

- `std::thread::spawn`, `JoinHandle`, `join`
- Move closures and thread ownership
- `mpsc` channels: `channel()`, `Sender`, `Receiver`, iteration vs `recv`
- Shared state: `Arc` (atomic reference count) + `Mutex` (mutual exclusion)
- Deadlock awareness (brief)
- Async note: Rust's ecosystem favors `tokio` for async I/O; this project sticks to std threads for fundamentals, but the readme points at tokio as the next step

## Completion checklist

- [ ] Complete the threads+channels exercise.
- [ ] Complete the shared-state exercise.
- [ ] Both compile and pass tests.
- [ ] Read the async note and be able to name the two most common async runtimes.

## Starter files

- `Cargo.toml` — library crate
- `src/lib.rs` — re-exports exercise modules
- `src/exercise_threads_channels.rs`
- `src/exercise_shared_state.rs`
- `README.md` — includes the async direction note
