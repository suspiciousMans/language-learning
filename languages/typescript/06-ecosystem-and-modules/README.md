# 06 — Ecosystem and Modules

**Difficulty:** advanced  
**Concepts:** npm, package.json, typed dependencies, DefinitelyTyped, consuming 3rd-party libs with types  
**Prerequisites:** 01 (basics)

## Goals

Learn how the TypeScript ecosystem fits together: installing packages with npm, reading `package.json`, understanding how types flow from a dependency into your code (built-in types, `package.json` `"types"`, and DefinitelyTyped `@types/` packages), and using a real library with full type safety.

## Concepts

- **npm and package.json** — project metadata, dependencies, devDependencies, scripts.
- **Typed dependencies** — a package can ship its own types (`"types"` / `"typings"` field, or `.d.ts` files alongside `.js`).
- **DefinitelyTyped (`@types/`)** — community-maintained type definitions for packages that don't ship types.
- **Resolving missing types** — TS error `Could not find a declaration file for module 'x'` and what to do about it.
- **ESM/CommonJS interop** — importing a CJS package from ESM TypeScript; default vs. named imports.

## Exercise

Install **date-fns** (or lodash) and use it in a small typed script.

date-fns ships its own types, so there's nothing extra to install. The exercise is:

1. Create a `package.json` (see below).
2. `npm install date-fns`.
3. Write `src/format-date.ts` that imports `format` and `parseISO` from `date-fns`, formats a parsed date, and logs the result.
4. Run it with `npx tsx src/format-date.ts`.
5. Optionally: install lodash as a second option and use `_.chunk` or `_.sortBy` with its types (lodash ships types; `@types/lodash` exists too if needed).

## Completion checklist

- [ ] `package.json` exists and lists the dependency.
- [ ] `node_modules/` contains the package (ignore it via .gitignore).
- [ ] The exercise file imports the library and compiles with `npx tsc --noEmit`.
- [ ] Running via `npx tsx` produces the expected output.
- [ ] You can explain how TS found the types for the library (built-in vs. `@types/`).
- [ ] You can explain what to do when a package has no types.

## Running the exercise

```bash
cd projects/06-ecosystem-and-modules

# One-time setup:
npm install

# Type-check:
npx tsc --noEmit src/format-date.ts

# Run:
npx tsx src/format-date.ts
```

## Files in this project

```
06-ecosystem-and-modules/
├── README.md
├── package.json
└── src/
    └── format-date.ts
```
