# 03 — Generics and Utilities

**Difficulty:** intermediate  
**Concepts:** generics, conditional types, mapped types, built-in utility types (Partial, Pick, Omit, Record, ReturnType, Parameters)  
**Prerequisites:** 02 (types)

## Goals

Write reusable, type-safe abstractions. Learn to parameterize types with generics, derive types from other types using conditional and mapped types, and use TypeScript's built-in utility types to transform types concisely.

## Concepts

- **Generics** — type parameters like `<T>` that let a function, type, or interface work across many types while preserving type information.
- **Generic constraints** — `T extends SomeShape` to limit what `T` can be.
- **Conditional types** — `T extends U ? X : Y`. Types that branch on a condition.
- **Mapped types** — transform each property of a type: `{ [K in keyof T]: ... }`.
- **`Partial<T>`** — all properties of `T` become optional.
- **`Pick<T, K>`** — select a subset of keys from `T`.
- **`Omit<T, K>`** — remove keys from `T`.
- **`Record<K, V>`** — a map from keys of type `K` to values of type `V`.
- **`ReturnType<T>`** — extract the return type of a function type.
- **`Parameters<T>`** — extract the parameter tuple of a function type.
- **Inference in generics** — `function identity<T>(x: T): T` infers `T` from the argument.

## Exercises

| File | Task |
|------|------|
| `exercises/01-generic-functions.ts` | Write generic identity, swap, and wrap functions; add constraints. |
| `exercises/02-generic-interfaces.ts` | Model a generic `Box<T>`, `Pair<A, B>`, and a generic repository interface. |
| `exercises/03-conditional-types.ts` | Write conditional types: `IsString<T>`, `ElementType<T>`, and a practical example. |
| `exercises/04-mapped-types.ts` | Write a mapped type that makes every property readonly; a type that renames keys. |
| `exercises/05-utility-types.ts` | Use `Partial`, `Pick`, `Omit`, `Record`, `ReturnType`, `Parameters` in realistic scenarios. |

## Completion checklist

- [ ] All exercises compile with `npx tsc --noEmit exercises/*.ts` with zero errors.
- [ ] You can write a generic function that preserves type information through inference.
- [ ] You can add a constraint (`T extends ...`) to a generic and explain why.
- [ ] You can read and write a conditional type and a mapped type.
- [ ] You can use each of `Partial`, `Pick`, `Omit`, `Record`, `ReturnType`, `Parameters` in a realistic snippet.

## Running the exercises

```bash
cd projects/03-generics-and-utilities

npx tsc --noEmit exercises/*.ts
```

Files are written to fail initially; the learner fixes them. The `solution/` folder shows one working version.

## Files in this project

```
03-generics-and-utilities/
├── README.md
├── exercises/
│   ├── 01-generic-functions.ts
│   ├── 02-generic-interfaces.ts
│   ├── 03-conditional-types.ts
│   ├── 04-mapped-types.ts
│   └── 05-utility-types.ts
└── solution/
    ├── 01-generic-functions.solution.ts
    ├── 02-generic-interfaces.solution.ts
    ├── 03-conditional-types.solution.ts
    ├── 04-mapped-types.solution.ts
    └── 05-utility-types.solution.ts
```
