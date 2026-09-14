# Project 02 — Data Structures and Iteration

Learn JavaScript's core data structures: arrays, objects, and the protocols that power iteration. Master destructuring, spread syntax, and modern collection types.

## Goals

- Create and manipulate arrays and objects.
- Use destructuring to extract values efficiently.
- Understand and use the spread operator and rest parameters.
- Iterate with `for`, `for...of`, `for...in`, and `.forEach()`.
- Understand iteration protocols: iterables and iterators.
- Use `Map` and `Set` for specialized use cases.

## Concepts

### Arrays

- Arrays are ordered, zero-indexed collections.
- Use array methods: `.push()`, `.pop()`, `.shift()`, `.unshift()`, `.slice()`, `.splice()`, `.map()`, `.filter()`, `.reduce()`.
- Avoid mutating arrays; prefer methods that return new arrays.

### Objects

- Objects are key-value stores (also called maps, dicts, hashes in other languages).
- Keys are always strings (or symbols); values can be anything.
- Use dot notation (`obj.key`) and bracket notation (`obj['key']`).
- Property shorthand: `{ name }` is `{ name: name }`.

### Destructuring

- Extract values from arrays: `const [a, b, c] = array;`
- Extract values from objects: `const { x, y } = obj;`
- Rename on extraction: `const { x: xVal } = obj;`
- Use defaults: `const [a = 0] = array;`
- Nested destructuring works for both.

### Spread and Rest

- Spread operator `...` unpacks iterables: `[...arr1, ...arr2]`, `{ ...obj1, ...obj2 }`.
- Rest parameters in functions: `function fn(first, ...rest) { }`.
- Collect remaining array elements: `const [a, ...rest] = array;`

### Iteration

- `for (let i = 0; i < arr.length; i++)` — classic, works with arrays and indices.
- `for (const item of arr)` — `for...of`, works with any iterable, cleaner syntax.
- `for (const key in obj)` — `for...in`, iterates over object keys (avoid for arrays).
- `.forEach((item, index) => { })` — functional style, no `break`/`continue`.
- `.map()`, `.filter()`, `.reduce()` — functional transformations.

### Iteration Protocols

- **Iterable**: an object with a `Symbol.iterator` method that returns an iterator.
- **Iterator**: an object with a `.next()` method that returns `{ value, done }`.
- Arrays, strings, and `Map`/`Set` are built-in iterables.
- Custom iterables can be defined with `Symbol.iterator`.

### Map and Set

- **Map**: key-value store that can use any value as a key (including objects).
- **Set**: unordered collection of unique values.
- Both are iterable and have `.size`, `.has()`, `.add()`, `.delete()`, `.clear()`.

## Prerequisites

Project 01 — Basics.

## Completion checklist

- [ ] Create an array and use `.map()`, `.filter()`, and `.reduce()`.
- [ ] Create an object and access properties with dot and bracket notation.
- [ ] Destructure an array and an object.
- [ ] Use the spread operator to merge arrays and objects.
- [ ] Write a function with rest parameters.
- [ ] Iterate with `for...of` and understand why it's preferred over `for...in` for arrays.
- [ ] Create a `Map` and a `Set` and use their methods.
- [ ] Understand the difference between an iterable and an iterator.

## Exercises

### ex1-arrays.js

- Create an array of numbers and use `.map()` to square each one.
- Use `.filter()` to keep only even numbers.
- Use `.reduce()` to sum all numbers.
- Demonstrate `.slice()` and `.splice()` side-by-side to show immutability differences.

### ex2-objects.js

- Create an object with properties and access them with both dot and bracket notation.
- Use property shorthand.
- Merge two objects with the spread operator.
- Iterate over object keys with `for...in` and `.Object.keys()`.

### ex3-destructuring.js

- Destructure an array into multiple variables.
- Destructure an object and rename properties.
- Use default values in destructuring.
- Destructure nested structures.

### ex4-spread-and-rest.js

- Use the spread operator to concatenate arrays.
- Use the spread operator to merge objects.
- Write a function with rest parameters and call it with varying arguments.
- Destructure an array using rest (`const [first, ...rest] = array`).

### ex5-iteration.js

- Iterate over an array with `for...of`.
- Iterate over an object with `for...in` and `.Object.entries()`.
- Use `.forEach()` with both values and indices.
- Write a `.map()`, `.filter()`, and `.reduce()` chain.

### ex6-map-and-set.js

- Create a `Map` with object keys and perform lookups.
- Create a `Set` and demonstrate uniqueness.
- Iterate over `Map` and `Set` with `for...of`.
- Understand why `Map` is better than objects for non-string keys.

### ex7-custom-iterables.js

- Create a custom iterable object with a `Symbol.iterator` method.
- Make it work with `for...of`.
- Understand the iterator protocol: `.next()` returns `{ value, done }`.

## Starter files

Each exercise file is a self-contained script. Fill in the body of each file.

### Running exercises

```bash
node exercises/ex1-arrays.js
node exercises/ex2-objects.js
node exercises/ex3-destructuring.js
node exercises/ex4-spread-and-rest.js
node exercises/ex5-iteration.js
node exercises/ex6-map-and-set.js
node exercises/ex7-custom-iterables.js
```

## Running tests

```bash
node --test tests/*.test.js
```

## What "done" looks like

All exercise files run without errors and produce meaningful output. All tests pass.
