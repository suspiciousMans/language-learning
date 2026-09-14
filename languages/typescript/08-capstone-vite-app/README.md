# 08 — Capstone: Vite App

**Difficulty:** advanced  
**Concepts:** full Vite + TypeScript app, strict types, npm deps, build pipeline, framework choice (React or vanilla)  
**Prerequisites:** all previous projects

## Goals

Ship a real, working Vite + TypeScript application. Choose your own framework (React or vanilla TS), implement a small but complete app (todo list, kanban board, or similar), use at least a couple of npm dependencies, and prove the build pipeline works end to end.

## Concepts

- **Vite** — fast dev server and build tool; TypeScript-first, ESM-native.
- **`vite.config.ts`** — configure the build, dev server, plugins.
- **`tsconfig.json`** — strict TypeScript config for the project; shares typed code between source and tests.
- **Strict types in a real app** — no `any` without an explanatory comment; typed component props, typed state, typed events.
- **npm dependencies** — at least two real packages (e.g., a UI utility, a state helper, a date library, uuid, etc.).
- **Build and preview** — `vite build` produces output under `dist/`; `vite preview` serves it.

## Your task

Build a small app. Suggested scope:

- **Todo app** — add, complete, delete, filter (all / active / completed), persist to localStorage.
- **Kanban board** — columns (todo / in progress / done), drag between columns, add/edit cards.

You may use React, Preact, or vanilla TypeScript. If you use React, install `react`, `react-dom`, and `@vitejs/plugin-react`. If you use vanilla, use the Vite vanilla TS template.

## Requirements

- [ ] **Framework of your choice** — React or vanilla TS. Document your choice in a comment at the top of `src/main.ts` (or `src/App.tsx`).
- [ ] **Strict TypeScript** — `tsconfig.json` with `"strict": true` (or strict-family flags). No `any` without a comment explaining why.
- [ ] **At least two npm dependencies** — list them in `package.json`.
- [ ] **`vite.config.ts`** — present and configured.
- [ ] **`vite build` succeeds** — produces `dist/` with output.
- [ ] **`vite preview` runs** — the built app serves and works in a browser.
- [ ] **Typed app logic** — the core domain logic (todos, cards, state transitions) is fully typed, not `any`.

## Acceptance criteria

1. `npm install` completes without errors.
2. `npx tsc --noEmit` (or `vite build`, which type-checks in strict setups) passes with zero type errors.
3. `npx vite build` succeeds and produces a `dist/` directory with built assets.
4. `npx vite preview` starts and the app loads in a browser.
5. No `any` type in the source except where a comment explains the justification (e.g. `// eslint-disable-next-line @typescript-eslint/no-explicit-any — external callback we don't control`).
6. At least two npm dependencies are used meaningfully in the app.

## Suggested dependencies

- `uuid` — generate IDs for todos/cards.
- `date-fns` — format dates (completion time, created time).
- `@react-hookz/web` or similar — if using React, a small utility.
- `lodash` or `lodash-es` — a utility you actually use (e.g., `orderBy`).

Pick what fits your app; you don't need many.

## Files in this project

```
08-capstone-vite-app/
├── README.md            # this file
├── package.json
├── vite.config.ts
├── tsconfig.json
├── index.html
└── src/
    ├── main.ts          # entry point (vanilla TS starter)
    ├── todo.ts          # typed todo domain logic (starter)
    └── style.css        # minimal styling (starter)
```

## Starter

A vanilla TypeScript todo starter is provided. If you prefer React, replace
`main.ts` with a React entry point, install `react`/`react-dom`/`@vitejs/plugin-react`,
and adjust `vite.config.ts` accordingly.

### Vanilla starter — `src/main.ts`

The starter implements a working todo app in vanilla TypeScript:

- Typed `Todo` interface.
- Typed `TodoStore` class with add/complete/delete/filter/persist.
- DOM rendered from typed state.
- Event handlers typed with DOM types (`HTMLInputElement`, `MouseEvent`, etc.).

### `vite.config.ts` (vanilla)

```ts
import { defineConfig } from "vite";

export default defineConfig({
  // Vanilla TS project — no React plugin needed.
});
```

### `tsconfig.json` (strict base)

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "module": "ESNext",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "isolatedModules": true,
    "moduleDetection": "force",
    "noEmit": true,
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src"]
}
```

## Running the starter

```bash
cd projects/08-capstone-vite-app

npm install
npx vite build
npx vite preview   # serves dist/ — open the URL it prints
```

## From starter to your app

1. Read the starter files.
2. Decide: vanilla or React.
3. If React: install `react`, `react-dom`, `@vitejs/plugin-react`; update `vite.config.ts`; rewrite `main.ts` as a React entry.
4. Implement your feature set (todo or kanban).
5. Add at least one more npm dependency and use it.
6. Verify the acceptance criteria.
