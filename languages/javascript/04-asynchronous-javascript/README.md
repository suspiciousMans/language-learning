# Project 04 — Asynchronous JavaScript

Master callbacks, Promises, and async/await. Understand the event loop, microtasks, and macrotasks. Handle errors gracefully in async code.

## Goals

- Understand callbacks and callback hell.
- Create and chain Promises.
- Use async/await for cleaner asynchronous code.
- Understand the event loop and microtask vs macrotask queues.
- Handle errors with `.catch()`, `.finally()`, and try/catch.
- Use `Promise.all()`, `Promise.race()`, and other Promise utilities.

## Concepts

### Callbacks

- A callback is a function passed to another function to be called later.
- Simple but lead to "callback hell" (deeply nested callbacks).
- Difficult to handle errors consistently.

### Promises

- A Promise represents a value that may not be available yet.
- States: pending, fulfilled (resolved), rejected.
- Methods: `.then(onFulfilled, onRejected)`, `.catch(onRejected)`, `.finally(onFinally)`.
- Chainable: `.then()` returns a new Promise.

### Async/Await

- `async` makes a function always return a Promise.
- `await` pauses execution until a Promise resolves.
- Looks like synchronous code but is asynchronous.
- Use try/catch for error handling.

### Event Loop

- The event loop continuously checks for work to do.
- Microtasks (Promises, `queueMicrotask`) run before macrotasks (setTimeout, setInterval, I/O).
- `console.log()` is synchronous and runs before any async code.

### Error Handling

- Use `.catch()` on Promises to handle rejections.
- Use `.finally()` to run code regardless of outcome.
- Use try/catch with async/await for readable error handling.
- Always handle Promise rejections to avoid unhandled rejection warnings.

## Prerequisites

Projects 01, 03.

## Completion checklist

- [ ] Use callbacks and understand why they're problematic.
- [ ] Create a Promise and use `.then()` and `.catch()`.
- [ ] Chain multiple Promises.
- [ ] Convert a callback-based function to use async/await.
- [ ] Use try/catch in async functions.
- [ ] Understand the event loop: microtasks before macrotasks.
- [ ] Use `Promise.all()` to run multiple Promises in parallel.
- [ ] Handle Promise rejection with `.catch()`.

## Exercises

### ex1-callbacks.js

- Write a simple callback function.
- Demonstrate callback hell with nested callbacks.
- Show why callbacks are hard to reason about and error-prone.

### ex2-promises.js

- Create a Promise that resolves and one that rejects.
- Use `.then()` to handle resolution.
- Use `.catch()` to handle rejection.
- Chain multiple `.then()` calls.

### ex3-promise-utilities.js

- Use `Promise.all()` to run multiple Promises in parallel.
- Use `Promise.race()` to get the first result.
- Use `Promise.allSettled()` to get all results regardless of success.
- Use `Promise.any()` to get the first success.

### ex4-async-await.js

- Write an `async` function and use `await` to pause execution.
- Convert a callback-based function to async/await.
- Use try/catch for error handling.
- Use `.finally()` for cleanup.

### ex5-error-handling.js

- Demonstrate error handling with `.catch()`.
- Use try/catch with async/await.
- Show the difference between synchronous and asynchronous errors.
- Handle both Promise rejection and thrown errors.

### ex6-event-loop.js

- Use `console.log()` and `Promise` callbacks to show execution order.
- Demonstrate that microtasks (Promises) run before macrotasks (setTimeout).
- Understand what happens with nested microtasks and macrotasks.

### ex7-advanced-async.js

- Use async generators or multiple awaits.
- Handle multiple async operations in sequence and in parallel.
- Create a function that times out if a Promise takes too long.

## Running exercises

```bash
node exercises/ex1-callbacks.js
node exercises/ex2-promises.js
node exercises/ex3-promise-utilities.js
node exercises/ex4-async-await.js
node exercises/ex5-error-handling.js
node exercises/ex6-event-loop.js
node exercises/ex7-advanced-async.js
```

## Running tests

```bash
node --test tests/*.test.js
```

## What "done" looks like

All exercises run without errors. All tests pass. You understand the event loop and can explain why `Promise.then()` runs before `setTimeout()`.
