# Project 07 — Modules and Packages

Use ES modules to organize code. Understand import/export, dependencies, the package.json, and how Node.js resolves modules.

## Goals

- Create and use ES modules with `import` and `export`.
- Understand default exports vs named exports.
- Create a package with npm.
- Manage dependencies: `dependencies` vs `devDependencies`.
- Use published packages from npm.
- Understand module resolution and file extensions.

## Concepts

### ES Modules

- `export` makes values available to other modules.
- `import` brings in values from other modules.
- Each module has its own scope.
- Circular dependencies are handled (with care).

### Export Types

- **Default export**: `export default value` — one per module, imported without braces.
- **Named exports**: `export const x = ...` — multiple per module, imported with braces.
- **Re-export**: `export { x } from 'module'` — forward exports.

### Import Types

- `import x from 'module'` — default import.
- `import { x, y } from 'module'` — named imports.
- `import * as module from 'file.js'` — import everything.
- `import 'module'` — side-effect import (no bindings).

### Package.json

- Metadata about your project: name, version, description, entry point.
- `dependencies`: packages your code needs to run.
- `devDependencies`: packages needed only for development (testing, linting).
- `scripts`: npm commands (e.g., `npm test`, `npm start`).

### Dependencies

- `npm install <package>` installs a dependency.
- `npm install --save-dev <package>` installs a dev dependency.
- `node_modules` directory contains all installed packages.
- `package-lock.json` locks down exact versions.

### Module Resolution

- Node.js looks for modules in `node_modules`.
- For local files, use relative paths: `./utils.js`, `../config.js`.
- Without an extension, Node.js tries `.js`, `.json`, `.mjs`.
- `type: "module"` in package.json makes `.js` files ES modules.

## Prerequisites

Projects 01.

## Completion checklist

- [ ] Create ES modules with `export` and `import`.
- [ ] Use both default and named exports.
- [ ] Create a package.json with npm init.
- [ ] Understand the difference between dependencies and devDependencies.
- [ ] Install packages from npm.
- [ ] Import and use an npm package.
- [ ] Organize code into multiple files and modules.
- [ ] Understand how Node.js resolves module paths.

## Exercises

### ex1-named-exports.js (module)

- Create a module with named exports.
- Export multiple functions and constants.
- Show that named exports must be imported with braces.

### ex2-default-export.js (module)

- Create a module with a default export.
- Import the default export without braces.
- Show that each module can have only one default export.

### ex3-mixed-exports.js (module)

- Create a module with both default and named exports.
- Import both in the same statement.

### ex4-re-exports.js (module)

- Re-export values from another module.
- Use the `export { x } from 'module'` syntax.

### ex5-side-effects.js (module)

- Create a module that runs code on import (side effects).
- Import it without extracting bindings.

### ex6-importing.js (main file)

- Import from all the modules above.
- Show different import styles.
- Use modules to organize code.

### ex7-package-json.js

- Create a package.json with npm init.
- Install a package from npm (e.g., lodash, chalk, or another).
- Import and use it.
- Show dependencies in package.json.

## Running exercises

```bash
# Initialize package and set type to module
npm init -y
npm pkg set type=module

# Run the main importing file
node exercises/ex6-importing.js
node exercises/ex7-package-json.js
```

## Running tests

```bash
node --test tests/*.test.js
```

## What "done" looks like

All exercises run without errors. You've created modules and imported/exported from them. You understand the difference between default and named exports and can use npm packages.
