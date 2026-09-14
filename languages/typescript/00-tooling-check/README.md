# 00 — Tooling Check

**Difficulty:** trivial  
**Concepts:** compiler, build tool, test runner, tsx runner  
**Prerequisites:** nothing

## Goals

Verify your TypeScript toolchain is installed and working before you write a single line of code. A smooth toolchain removes friction later.

## Concepts

- **TypeScript compiler (`tsc`)** — transpiles `.ts` to `.js`; also type-checks.
- **`tsx`** — fast TS executor that runs `.ts` files directly without a separate build step (great for exercises and scripts).
- **`node --version`** — confirm you're on Node 20+.

## What you'll do

1. Confirm Node 20+ is installed: `node --version`.
2. Confirm TypeScript is available: `tsc --version`.
3. Confirm `tsx` is available: `npx tsx --version` or `tsx --version` if installed globally.
4. Run the provided `src/index.ts` via `npx tsx src/index.ts` and verify the output.

## Completion checklist

- [ ] `node --version` prints 20.x or higher.
- [ ] `tsc --version` prints 5.x.
- [ ] `npx tsx src/index.ts` runs without errors and prints `toolchain ok`.
- [ ] You can explain the difference between `tsc` (compile + type-check) and `tsx` (run directly).

## Running the starter

```bash
cd projects/00-tooling-check
npx tsx src/index.ts
# expected output: toolchain ok
```

## Files in this project

```
00-tooling-check/
├── README.md          # this file
└── src/
    └── index.ts       # logs 'toolchain ok' — the thing you run
```
