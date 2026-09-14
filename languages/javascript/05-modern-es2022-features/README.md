# Project 05 — Modern ES2022+ Features

Learn the latest JavaScript features: optional chaining, nullish coalescing, private fields, static methods, top-level await, and more.

## Goals

- Use optional chaining (`?.`) for safe property access.
- Use nullish coalescing (`??`) to provide defaults.
- Create classes with private fields and static members.
- Use logical assignment operators (`??=`, `&&=`, `||=`).
- Use `Promise.withResolvers()` and top-level await.
- Know the latest Array and Object methods.

## Concepts

### Optional Chaining (`?.`)

- `obj?.prop` returns `undefined` if `obj` is null/undefined, otherwise returns the property.
- Works with function calls: `obj?.method?.()`.
- Works with computed properties: `obj?.[key]`.
- Prevents "Cannot read property of null" errors.

### Nullish Coalescing (`??`)

- `a ?? b` returns `a` if not null/undefined, otherwise `b`.
- Different from `||`, which treats 0, '', and false as falsy.
- Useful for providing sensible defaults for configuration.

### Private Fields

- `#field` creates a truly private field in a class.
- Not accessible from outside the class or via reflection.
- Cannot be inspected or modified externally.

### Static Methods and Properties

- `static method() {}` belongs to the class, not instances.
- Useful for factory methods and utilities.
- `static fields` store shared state (ES2022).

### Logical Assignment Operators

- `a ??= b` assigns `b` to `a` if `a` is null/undefined (nullish assignment).
- `a ||= b` assigns `b` to `a` if `a` is falsy (logical OR assignment).
- `a &&= b` assigns `b` to `a` if `a` is truthy (logical AND assignment).

### Top-Level Await

- `await` can be used at the module level (in .mjs files or modules).
- Blocks module execution until the Promise resolves.
- Simplifies initialization code.

### New Array/Object Methods

- `Array.prototype.at()` — get element by index (supports negative indices).
- `Object.hasOwn()` — check if an object has a property.
- `String.prototype.replaceAll()` — replace all occurrences.

## Prerequisites

Projects 01, 06.

## Completion checklist

- [ ] Use optional chaining to safely access nested properties.
- [ ] Use nullish coalescing to provide defaults.
- [ ] Create a class with private fields.
- [ ] Use static methods in a class.
- [ ] Use logical assignment operators.
- [ ] Understand the difference between `??` and `||`.
- [ ] Use `.at()` for negative array indexing.
- [ ] Use `Object.hasOwn()` instead of `.hasOwnProperty()`.

## Exercises

### ex1-optional-chaining.js

- Use `?.` to safely access deeply nested properties.
- Show how it prevents errors without needing null checks.
- Use `?.()` to conditionally call methods.
- Use `?.[key]` for computed property access.

### ex2-nullish-coalescing.js

- Use `??` to provide defaults for null/undefined values.
- Contrast with `||` which treats falsy values differently.
- Use cases: configuration, API responses.

### ex3-private-fields.js

- Create a class with private fields (`#field`).
- Show that private fields cannot be accessed from outside.
- Use private fields for internal state.

### ex4-static-members.js

- Create a class with static methods and properties.
- Use static methods for factory functions.
- Show that static members belong to the class, not instances.

### ex5-logical-assignment.js

- Use `??=`, `||=`, and `&&=` operators.
- Show when each is useful.
- Understand the difference between them.

### ex6-new-array-object-methods.js

- Use `Array.prototype.at()` for indexing (including negative).
- Use `Object.hasOwn()` to check properties.
- Use `String.prototype.replaceAll()`.
- Explore other new methods.

## Running exercises

```bash
node exercises/ex1-optional-chaining.js
node exercises/ex2-nullish-coalescing.js
node exercises/ex3-private-fields.js
node exercises/ex4-static-members.js
node exercises/ex5-logical-assignment.js
node exercises/ex6-new-array-object-methods.js
```

## Running tests

```bash
node --test tests/*.test.js
```

## What "done" looks like

All exercises run without errors. All tests pass. You understand when to use `??` vs `||` and can create classes with private fields.
