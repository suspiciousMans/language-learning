# 01 — Basics

**Difficulty:** beginner  
**Concepts:** TypeScript type annotations, basic types, functions, compilation with `tsc`  
**Prerequisites:** 00 (tooling check)

## Goals

Get comfortable with the TypeScript type system's surface area — annotations on variables, function parameters and return types, and the most common primitive types. Learn to run `tsc` and read its output.

## Concepts

- **Type annotations** — `: type` after a variable, parameter, or function.
- **Primitives** — `string`, `number`, `boolean`, `null`, `undefined`, `symbol`, `bigint`.
- **Arrays and tuples** — `string[]`, `Array<number>`, `[string, number]`.
- **Functions** — annotated parameters, return types, arrow functions.
- **Type inference** — when TS fills in the type for you; when you should annotate anyway.
- **`tsc` compilation** — emit JavaScript from TypeScript, configurable via `tsconfig.json`.

## Exercises

The exercises live in `exercises/`. Each file is a self-contained task.

| File | Task |
|------|------|
| `exercises/01-variables.ts` | Annotate variables with correct primitive types. Fix the type errors. |
| `exercises/02-functions.ts` | Annotate function parameters and return types. Write arrow functions with types. |
| `exercises/03-arrays-tuples.ts` | Work with arrays, tuples, and array typing. |
| `exercises/04-objects.ts` | Type simple object literals and function parameters that are objects. |

## Completion checklist

- [ ] All exercises compile with `tsc --noEmit` (or `npx tsc --noEmit`) with zero errors.
- [ ] You can explain when TS infers a type vs. when you should write one explicitly.
- [ ] You can run `tsc` and point to the emitted `.js` file.
- [ ] You understand the difference between `string[]`, `Array<string>`, and `[string, number]`.

## Running the exercises

```bash
cd projects/01-basics

# Type-check all exercises without emitting JS:
npx tsc --noEmit exercises/*.ts

# Or check one at a time:
npx tsc --noEmit exercises/01-variables.ts
npx tsc --noEmit exercises/02-functions.ts
npx tsc --noEmit exercises/03-arrays-tuples.ts
npx tsc --noEmit exercises/04-objects.ts
```

Files are written to fail initially (intentional red squiggles) and the learner fixes them. The `solution/` folder shows one working version.

## Files in this project

```
01-basics/
├── README.md
├── exercises/
│   ├── 01-variables.ts
│   ├── 02-functions.ts
│   ├── 03-arrays-tuples.ts
│   └── 04-objects.ts
└── solution/
    ├── 01-variables.solution.ts
    ├── 02-functions.solution.ts
    ├── 03-arrays-tuples.solution.ts
    └── 04-objects.solution.ts
```
