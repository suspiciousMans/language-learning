# Project 03 — Scope and Closures

Master JavaScript's execution contexts: function scope, block scope, hoisting, and closures. These concepts power advanced patterns in real-world code.

## Goals

- Understand function scope, block scope, and global scope.
- Grasp hoisting: how declarations are moved to the top of their scope.
- Create and use closures to capture and manipulate lexical environments.
- Recognize and avoid common closure pitfalls.
- Use Immediately Invoked Function Expressions (IIFEs) for encapsulation.

## Concepts

### Function Scope

- Variables declared with `var` are function-scoped: visible anywhere in the function.
- `var` is hoisted: the declaration moves to the top, but not the assignment.
- This is why `var` is avoided — it leads to surprising behavior.

### Block Scope

- `let` and `const` are block-scoped: visible only in the block they're declared in.
- Blocks include `{}` in `if`, `for`, `while`, and standalone blocks.
- Block scope prevents accidental re-declarations and confuses fewer people.

### Temporal Dead Zone (TDZ)

- `let` and `const` are not hoisted in the traditional sense.
- Between the start of the block and the declaration, they're in a "temporal dead zone."
- Accessing them raises a `ReferenceError`.

### Closures

- A closure is a function that has access to its lexical environment (outer scope).
- Every function creates a closure; they're not special, just common.
- Closures are used to create private variables and factory functions.

### IIFE (Immediately Invoked Function Expression)

- A function that is declared and invoked at the same time: `(function() { })()`.
- Used to create a new scope and avoid polluting the global scope.
- Less necessary with modules, but still useful in certain patterns.

## Prerequisites

Projects 01 — Basics.

## Completion checklist

- [ ] Understand the difference between function scope and block scope.
- [ ] Know how `var` hoisting differs from `let`/`const` hoisting.
- [ ] Explain why `let` has a temporal dead zone.
- [ ] Create a closure and show it captures variables from its lexical environment.
- [ ] Use a closure to create private variables.
- [ ] Avoid the common closure pitfall with loops.
- [ ] Use an IIFE to create encapsulation.

## Exercises

### ex1-function-scope.js

- Declare a `var` inside a function and show it's visible throughout the function.
- Demonstrate that `var` hoisting moves declarations to the top.
- Contrast with `let`/`const` which are block-scoped.

### ex2-block-scope.js

- Show that `let` and `const` are block-scoped, not visible outside the block.
- Demonstrate block scope in `if`, `for`, and standalone blocks.
- Show that variables with the same name can exist in different blocks.

### ex3-temporal-dead-zone.js

- Attempt to access a `let` or `const` before it's declared (commented example).
- Explain what a temporal dead zone is.
- Show that `typeof` doesn't help detect temporal dead zone (throws anyway).

### ex4-closures.js

- Create a function that returns a function, showing the inner function accesses the outer scope.
- Use a closure to create a counter with private state.
- Create multiple closures from the same factory and show they have separate state.

### ex5-closure-pitfalls.js

- Show the common loop closure pitfall: a loop that captures `i`.
- Fix it with an IIFE or `let`.
- Understand why the pitfall exists.

### ex6-private-variables.js

- Use closures to create private variables in an object.
- Create getter and setter methods that manipulate private state.
- Show that private variables are not accessible from outside.

### ex7-iife.js

- Create an IIFE and use it for encapsulation.
- Show that variables inside an IIFE are not in the global scope.
- Use an IIFE pattern to create a module-like object with private and public members.

## Running exercises

```bash
node exercises/ex1-function-scope.js
node exercises/ex2-block-scope.js
node exercises/ex3-temporal-dead-zone.js
node exercises/ex4-closures.js
node exercises/ex5-closure-pitfalls.js
node exercises/ex6-private-variables.js
node exercises/ex7-iife.js
```

## Running tests

```bash
node --test tests/*.test.js
```

## What "done" looks like

All exercise files run without errors. All tests pass. You can explain the temporal dead zone and closure pitfalls.
