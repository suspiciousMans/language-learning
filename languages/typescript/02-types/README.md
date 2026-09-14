# 02 — Types

**Difficulty:** beginner→intermediate  
**Concepts:** primitives, unions, intersections, type aliases, interfaces, literal types, type narrowing  
**Prerequisites:** 01 (basics)

## Goals

Move beyond simple annotations into the expressive parts of TypeScript's type system — unions, intersections, literal types, aliases vs. interfaces, and narrowing with `typeof`, `in`, and discriminated unions.

## Concepts

- **Union types** — `string | number`, `A | B | C`. Values that can be one of several types.
- **Intersection types** — `A & B`. Combine multiple types into one.
- **Type aliases** — `type Point = { x: number; y: number }`. Give a name to a shape.
- **Interfaces** — `interface Point { x: number; y: number }`. Similar to aliases for objects; can be merged/declared multiple times.
- **Literal types** — `"success" | "pending" | "error"`, `42`, `true`. Narrow literal values to specific constants.
- **Type narrowing** — `typeof x === "string"`, `x !== null`, `"prop" in obj`, discriminated unions with a shared discriminant field.
- **Discriminated unions** — a union of object types that share a discriminant property; TS narrows automatically on that property.

## Exercises

| File | Task |
|------|------|
| `exercises/01-primitives-and-literals.ts` | Annotate with primitives and string/numeric literal types. |
| `exercises/02-unions-intersections.ts` | Write union and intersection types; use them in function signatures. |
| `exercises/03-aliases-vs-interfaces.ts` | Define the same shape with a `type` alias and an `interface`; observe differences. |
| `exercises/04-narrowing.ts` | Narrow values using `typeof`, `in`, and discriminated unions. |
| `exercises/05-discriminated-unions.ts` | Model a state machine with a discriminated union and narrow on the discriminant. |

## Completion checklist

- [ ] All exercises compile with `npx tsc --noEmit exercises/*.ts` with zero errors.
- [ ] You can explain when to use a `type` alias vs. an `interface`.
- [ ] You can narrow a `string | number` down to `string` with `typeof`.
- [ ] You can model a discriminated union and explain why it's safer than a plain union of objects.
- [ ] You can write a function that accepts a union type and handles each member.

## Running the exercises

```bash
cd projects/02-types

npx tsc --noEmit exercises/*.ts
```

Files are written to fail initially; the learner fixes them. The `solution/` folder shows one working version.

## Files in this project

```
02-types/
├── README.md
├── exercises/
│   ├── 01-primitives-and-literals.ts
│   ├── 02-unions-intersections.ts
│   ├── 03-aliases-vs-interfaces.ts
│   ├── 04-narrowing.ts
│   └── 05-discriminated-unions.ts
└── solution/
    ├── 01-primitives-and-literals.solution.ts
    ├── 02-unions-intersections.solution.ts
    ├── 03-aliases-vs-interfaces.solution.ts
    ├── 04-narrowing.solution.ts
    └── 05-discriminated-unions.solution.ts
```
