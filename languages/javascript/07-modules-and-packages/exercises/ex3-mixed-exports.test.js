// ex3-mixed-exports.test.js
import test from 'node:test';
import assert from 'node:assert';
import sayHello, { greet, goodbye } from './ex3-mixed-exports.js';

test('default and named imports together', () => {
  assert.strictEqual(sayHello('Alice'), 'Hello, Alice!');
  assert.strictEqual(greet('Hi', 'Bob'), 'Hi, Bob!');
  assert.strictEqual(goodbye('Charlie'), 'Goodbye, Charlie!');
});
