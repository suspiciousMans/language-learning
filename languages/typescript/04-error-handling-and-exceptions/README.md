# 04 — Error Handling and Exceptions

**Difficulty:** intermediate  
**Concepts:** try/catch, typed catch, custom Error subclasses, never/exhaustive checks  
**Prerequisites:** 01 (basics), 02 (types)

## Goals

Learn TypeScript's approach to errors. Understand the limits of typed catch (TypeScript catches `unknown` by default in strict mode), design custom error hierarchies, and use `never` and exhaustive checks to make error handling impossible to forget.

## Concepts

- **`try/catch/finally`** — standard JS error handling; TS adds typing on top.
- **`unknown` in catch** — in strict mode, the caught value is `unknown`, not `Error`. You must narrow before using it.
- **Typed catch** — narrowing the caught value with `instanceof` or type predicates.
- **Custom Error subclasses** — extending `Error`, setting `name`, capturing `stack`.
- **`never`** — the type of values that never occur; used in exhaustive checks.
- **Exhaustive checks** — a `default` branch in a switch or a fallback in a conditional that assigns to a `never` variable, so TS raises an error when a case is missing.
- **Result-style error handling (optional)** — returning `{ success: true, value: T } | { success: false, error: E }` as an alternative to throwing.

## Exercises

| File | Task |
|------|------|
| `exercises/01-try-catch-basics.ts` | Wrap risky operations in try/catch; handle the caught value correctly. |
| `exercises/02-typed-catch.ts` | Narrow the caught `unknown` with `instanceof`; handle non-Error throws safely. |
| `exercises/03-custom-errors.ts` | Build a custom error hierarchy (base error, a few subclasses) with meaningful `name` values. |
| `exercises/04-never-and-exhaustive.ts` | Write exhaustive checks on discriminated unions and switch statements; watch TS complain when a case is missing. |
| `exercises/05-result-style-errors.ts` | Model a function that returns a Result type instead of throwing; handle both branches. |

## Completion checklist

- [ ] All exercises compile with `npx tsc --noEmit exercises/*.ts` with zero errors.
- [ ] You can explain why catch clauses receive `unknown` in strict TypeScript.
- [ ] You can narrow a caught value safely before using its properties.
- [ ] You can write a custom Error subclass that behaves like a built-in error.
- [ ] You can write an exhaustive check that makes adding a new union variant a type error if not handled.

## Running the exercises

```bash
cd projects/04-error-handling-and-exceptions

npx tsc --noEmit exercises/*.ts
```

Files are written to fail initially; the learner fixes them. The `solution/` folder shows one working version.

## Files in this project

```
04-error-handling-and-exceptions/
├── README.md
├── exercises/
│   ├── 01-try-catch-basics.ts
│   ├── 02-typed-catch.ts
│   ├── 03-custom-errors.ts
│   ├── 04-never-and-exhaustive.ts
│   └── 05-result-style-errors.ts
└── solution/
    ├── 01-try-catch-basics.solution.ts
    ├── 02-typed-catch.solution.ts
    ├── 03-custom-errors.solution.ts
    ├── 04-never-and-exhaustive.solution.ts
    └── 05-result-style-errors.solution.ts
```
