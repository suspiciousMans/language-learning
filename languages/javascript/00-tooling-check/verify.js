// verify.js — tooling check
const expected = 'toolchain ok';
const actual = 'toolchain ok';

console.log(actual);

if (actual !== expected) {
  console.error(`FAIL: expected "${expected}", got "${actual}"`);
  process.exit(1);
}

console.log('PASS');
