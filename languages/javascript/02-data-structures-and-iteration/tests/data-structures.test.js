import test from 'node:test';
import assert from 'node:assert';

// Test array methods
test('Array.map() squares numbers', () => {
  const nums = [1, 2, 3];
  const squared = nums.map(n => n * n);
  assert.deepStrictEqual(squared, [1, 4, 9]);
});

test('Array.filter() keeps even numbers', () => {
  const nums = [1, 2, 3, 4, 5];
  const evens = nums.filter(n => n % 2 === 0);
  assert.deepStrictEqual(evens, [2, 4]);
});

test('Array.reduce() sums numbers', () => {
  const nums = [1, 2, 3, 4];
  const sum = nums.reduce((acc, n) => acc + n, 0);
  assert.strictEqual(sum, 10);
});

test('Array.slice() does not mutate', () => {
  const arr = [1, 2, 3, 4];
  const sliced = arr.slice(1, 3);
  assert.deepStrictEqual(sliced, [2, 3]);
  assert.deepStrictEqual(arr, [1, 2, 3, 4]); // unchanged
});

test('Array.splice() mutates array', () => {
  const arr = [1, 2, 3, 4];
  const removed = arr.splice(1, 2);
  assert.deepStrictEqual(removed, [2, 3]);
  assert.deepStrictEqual(arr, [1, 4]); // changed
});

// Test object operations
test('Object property access via dot and bracket notation', () => {
  const obj = { name: 'Alice', age: 30 };
  assert.strictEqual(obj.name, 'Alice');
  assert.strictEqual(obj['age'], 30);
});

test('Object property shorthand', () => {
  const name = 'Bob';
  const obj = { name };
  assert.deepStrictEqual(obj, { name: 'Bob' });
});

test('Object.keys() returns all keys', () => {
  const obj = { a: 1, b: 2, c: 3 };
  assert.deepStrictEqual(Object.keys(obj).sort(), ['a', 'b', 'c']);
});

test('Spread operator merges objects', () => {
  const obj1 = { a: 1, b: 2 };
  const obj2 = { b: 3, c: 4 };
  const merged = { ...obj1, ...obj2 };
  assert.deepStrictEqual(merged, { a: 1, b: 3, c: 4 });
});

// Test destructuring
test('Array destructuring extracts values', () => {
  const [a, b, c] = [1, 2, 3];
  assert.strictEqual(a, 1);
  assert.strictEqual(b, 2);
  assert.strictEqual(c, 3);
});

test('Array destructuring with defaults', () => {
  const [a, b, c = 0] = [1, 2];
  assert.strictEqual(c, 0);
});

test('Object destructuring extracts properties', () => {
  const { x, y } = { x: 10, y: 20 };
  assert.strictEqual(x, 10);
  assert.strictEqual(y, 20);
});

test('Object destructuring with rename', () => {
  const { x: xVal } = { x: 5 };
  assert.strictEqual(xVal, 5);
});

test('Rest in array destructuring', () => {
  const [a, ...rest] = [1, 2, 3, 4];
  assert.strictEqual(a, 1);
  assert.deepStrictEqual(rest, [2, 3, 4]);
});

// Test spread and rest
test('Spread concatenates arrays', () => {
  const arr1 = [1, 2];
  const arr2 = [3, 4];
  const combined = [...arr1, ...arr2];
  assert.deepStrictEqual(combined, [1, 2, 3, 4]);
});

test('Rest parameters collect arguments', () => {
  function sum(...nums) {
    return nums.reduce((a, b) => a + b, 0);
  }
  assert.strictEqual(sum(1, 2, 3, 4), 10);
});

// Test iteration
test('for...of iterates over array values', () => {
  const arr = [1, 2, 3];
  const result = [];
  for (const val of arr) {
    result.push(val);
  }
  assert.deepStrictEqual(result, [1, 2, 3]);
});

test('forEach iterates with index', () => {
  const arr = ['a', 'b', 'c'];
  const indices = [];
  arr.forEach((_, idx) => indices.push(idx));
  assert.deepStrictEqual(indices, [0, 1, 2]);
});

// Test Map
test('Map stores and retrieves values', () => {
  const m = new Map();
  const key = { id: 1 };
  m.set(key, 'value');
  assert.strictEqual(m.get(key), 'value');
  assert.strictEqual(m.has(key), true);
});

test('Map.size reports element count', () => {
  const m = new Map();
  m.set('a', 1);
  m.set('b', 2);
  assert.strictEqual(m.size, 2);
});

test('Map deletes entries', () => {
  const m = new Map();
  m.set('x', 10);
  m.delete('x');
  assert.strictEqual(m.has('x'), false);
});

// Test Set
test('Set stores unique values', () => {
  const s = new Set([1, 2, 2, 3, 3, 3]);
  assert.strictEqual(s.size, 3);
  assert.deepStrictEqual(Array.from(s).sort(), [1, 2, 3]);
});

test('Set.has() checks membership', () => {
  const s = new Set([1, 2, 3]);
  assert.strictEqual(s.has(2), true);
  assert.strictEqual(s.has(5), false);
});

test('Set.add() and Set.delete()', () => {
  const s = new Set([1, 2]);
  s.add(3);
  assert.strictEqual(s.size, 3);
  s.delete(2);
  assert.strictEqual(s.size, 2);
});

// Test custom iterables
test('Custom iterable with Symbol.iterator', () => {
  const range = {
    start: 1,
    end: 3,
    [Symbol.iterator]() {
      let current = this.start;
      const end = this.end;
      return {
        next: () => {
          if (current <= end) {
            return { value: current++, done: false };
          }
          return { done: true };
        },
      };
    },
  };
  
  const result = [];
  for (const val of range) {
    result.push(val);
  }
  assert.deepStrictEqual(result, [1, 2, 3]);
});

test('Custom iterable works with spread', () => {
  const range = {
    start: 1,
    end: 3,
    [Symbol.iterator]() {
      let current = this.start;
      const end = this.end;
      return {
        next: () => {
          if (current <= end) {
            return { value: current++, done: false };
          }
          return { done: true };
        },
      };
    },
  };
  
  const arr = [...range];
  assert.deepStrictEqual(arr, [1, 2, 3]);
});
