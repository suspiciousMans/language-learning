// ex1-named-exports.test.js
import test from 'node:test';
import assert from 'node:assert';
import { add, subtract, multiply, PI, E } from './utils.js';

test('named exports: add', () => {
  assert.strictEqual(add(2, 3), 5);
  assert.strictEqual(add(0, 0), 0);
});

test('named exports: subtract', () => {
  assert.strictEqual(subtract(5, 2), 3);
});

test('named exports: multiply', () => {
  assert.strictEqual(multiply(3, 4), 12);
});

test('named exports: constants', () => {
  assert(PI > 3);
  assert(E > 2);
});
