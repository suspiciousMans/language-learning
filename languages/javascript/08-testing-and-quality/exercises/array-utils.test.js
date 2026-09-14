// array-utils.test.js
import test from 'node:test';
import assert from 'node:assert';
import { flatten, unique, chunk, shuffle } from './array-utils.js';

test('flatten: nested arrays', () => {
  assert.deepStrictEqual(flatten([[1, 2], [3, 4]]), [1, 2, 3, 4]);
  assert.deepStrictEqual(flatten([1, [2, [3, 4]]]), [1, 2, 3, 4]);
});

test('unique: removes duplicates', () => {
  assert.deepStrictEqual(unique([1, 2, 2, 3, 3, 3]).sort(), [1, 2, 3]);
  assert.deepStrictEqual(unique(['a', 'b', 'a']).sort(), ['a', 'b']);
});

test('chunk: splits array into groups', () => {
  assert.deepStrictEqual(chunk([1, 2, 3, 4, 5], 2), [[1, 2], [3, 4], [5]]);
  assert.deepStrictEqual(chunk(['a', 'b', 'c'], 1), [['a'], ['b'], ['c']]);
});

test('shuffle: returns array of same length', () => {
  const arr = [1, 2, 3, 4, 5];
  const shuffled = shuffle(arr);
  assert.strictEqual(shuffled.length, arr.length);
  assert(shuffled.every((x) => arr.includes(x)));
});
