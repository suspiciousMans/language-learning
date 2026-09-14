// string-utils.test.js
import test from 'node:test';
import assert from 'node:assert';
import { uppercase, lowercase, capitalize, reverse } from './string-utils.js';

test('uppercase converts to uppercase', () => {
  assert.strictEqual(uppercase('hello'), 'HELLO');
  assert.strictEqual(uppercase('WORLD'), 'WORLD');
});

test('lowercase converts to lowercase', () => {
  assert.strictEqual(lowercase('HELLO'), 'hello');
  assert.strictEqual(lowercase('World'), 'world');
});

test('capitalize capitalizes first letter', () => {
  assert.strictEqual(capitalize('hello'), 'Hello');
  assert.strictEqual(capitalize('WORLD'), 'WORLD');
});

test('reverse reverses string', () => {
  assert.strictEqual(reverse('hello'), 'olleh');
  assert.strictEqual(reverse('abc'), 'cba');
});
