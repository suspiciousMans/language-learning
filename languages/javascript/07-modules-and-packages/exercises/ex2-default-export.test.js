// ex2-default-export.test.js
import test from 'node:test';
import assert from 'node:assert';
import calculate from './calculator.js';

test('default export: calculate', () => {
  assert.strictEqual(calculate(10, '+', 5), 15);
  assert.strictEqual(calculate(10, '-', 5), 5);
  assert.strictEqual(calculate(10, '*', 5), 50);
  assert.strictEqual(calculate(10, '/', 5), 2);
});

test('default export: division by zero', () => {
  assert.strictEqual(calculate(10, '/', 0), 'Cannot divide by zero');
});

test('default export: unknown operator', () => {
  assert.strictEqual(calculate(10, '%', 5), 'Unknown operator');
});
