# Project 00 — Tooling Check

Verify your JavaScript toolchain is installed and working before starting the learning path.

## Goals

- Confirm Node.js and npm are installed with acceptable versions.
- Run a JavaScript file from the command line.
- Run a basic assertion to validate program output.

## Concepts

- **Node.js**: the JavaScript runtime that executes `.js` files outside the browser.
- **npm**: the Node package manager, ships with Node.
- **Running JS from the terminal**: `node <file>` executes a script.
- **Assertions**: checking that actual output matches expected output.

## Prerequisites

Nothing. This is the first project.

## Completion checklist

- [ ] `node -v` prints a version ≥ 20.0.0
- [ ] `npm -v` prints a version ≥ 9.0.0
- [ ] `verify.js` runs and prints `toolchain ok`
- [ ] The assert in `verify.js` passes without error

## Files

### verify.js

```js
// verify.js — tooling check
const expected = 'toolchain ok';
const actual = 'toolchain ok';

console.log(actual);

if (actual !== expected) {
  console.error(`FAIL: expected "${expected}", got "${actual}"`);
  process.exit(1);
}

console.log('PASS');
```

### How to run

```bash
node verify.js
```

Expected output:

```
toolchain ok
PASS
```

### Verify tool versions

```bash
node -v   # should be v20.x.x or higher
npm -v    # should be 9.x.x or higher
```

## What "done" looks like

Running `node verify.js` exits with code 0 and prints `toolchain ok` followed by `PASS`. `node -v` and `npm -v` report compatible versions.
