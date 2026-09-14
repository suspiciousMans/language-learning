# Project 01 — Basics

Learn the building blocks of JavaScript: variables, primitives, control flow, functions, and output.

## Goals

- Declare variables with `let`, `const`, and understand why `var` is avoided.
- Use all of JavaScript's primitive types.
- Write control flow with `if/else`, `for`, `while`, and `switch`.
- Declare functions three ways: declarations, expressions, and arrow functions.
- Print output with `console.log` and use template literals.

## Concepts

### Variables

- **`let`**: block-scoped, reassignable. Use for values that change.
- **`const`**: block-scoped, not reassignable. Use by default.
- **`var`**: function-scoped, hoisted, can be redeclared. Avoid it — it has surprising behavior.

### Primitives

- `string` — text, quoted with `'`, `"`, or backticks.
- `number` — all numbers are IEEE 754 doubles; there is no `int` vs `float`.
- `boolean` — `true` or `false`.
- `null` — intentional absence of a value.
- `undefined` — a value that hasn't been assigned yet.
- `symbol` — unique, immutable identifier, often used as object keys.
- `bigint` — integers larger than `Number.MAX_SAFE_INTEGER` (`9007199254740991`).

### Control flow

- `if / else if / else` — conditional branches.
- `for (init; condition; update)` — classic counter loop.
- `while (condition)` — loop while a condition holds.
- `do { } while (condition)` — run at least once.
- `switch (expr) { case ... }` — multi-way branch.

### Functions

- **Declaration**: `function name(params) { body }` — hoisted, named.
- **Expression**: `const fn = function(params) { body }` — not hoisted, can be anonymous.
- **Arrow**: `const fn = (params) => body` — concise, no `this` binding of its own.

### I/O

- `console.log(...values)` — print to stdout.
- Template literals: `` `hello ${name}` `` — embed expressions in strings.

## Prerequisites

Project 00 — tooling check.

## Completion checklist

- [ ] Read each exercise file and run it with `node`.
- [ ] Understand why `const` is preferred over `var`.
- [ ] Be able to list all 7 primitive types from memory.
- [ ] Write a function using each of the three declaration styles.
- [ ] Use a `for` loop, a `while` loop, and a `switch`.
- [ ] Write a template literal that interpolates a variable.

## Exercises

### ex1-let-const.js

Demonstrate `let` and `const`. Show that `const` cannot be reassigned and explain why `var` is avoided.

### ex2-primitives.js

Declare one variable of each primitive type and log its type with `typeof`. Handle the `typeof null === 'object'` gotcha.

### ex3-control-flow.js

- Use `if/else` to classify a number as positive, negative, or zero.
- Use a `for` loop to sum numbers 1..10.
- Use a `while` loop to count down from 5 to 1.
- Use a `switch` to map a numeric day (0=Sun..6=Sat) to a name.

### ex4-functions.js

Write the same function three ways: declaration, expression, arrow. Show the difference in hoisting behavior with a commented example.

### ex5-template-literals.js

Build a short bio string using template literals with embedded expressions. Show multiline strings.

## Starter files

Each exercise file is a self-contained script you run with `node exercises/<file>.js`. Fill in the body of each file — starter code with comments is provided.

### Running exercises

```bash
node exercises/ex1-let-const.js
node exercises/ex2-primitives.js
node exercises/ex3-control-flow.js
node exercises/ex4-functions.js
node exercises/ex5-template-literals.js
```

## What "done" looks like

All five exercise files run without errors, print meaningful output that demonstrates the concept, and you can explain the answers to the questions in each file's comments.
