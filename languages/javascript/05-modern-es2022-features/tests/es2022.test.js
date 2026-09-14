import test from 'node:test';
import assert from 'node:assert';

// Test optional chaining
test('Optional chaining prevents errors on null/undefined', () => {
  const obj = { a: { b: 'value' } };
  const nullObj = null;
  
  assert.strictEqual(obj?.a?.b, 'value');
  assert.strictEqual(nullObj?.a?.b, undefined);
});

// Test nullish coalescing
test('Nullish coalescing provides defaults for null/undefined only', () => {
  assert.strictEqual(undefined ?? 'default', 'default');
  assert.strictEqual(null ?? 'default', 'default');
  assert.strictEqual(0 ?? 'default', 0);
  assert.strictEqual('' ?? 'default', '');
  assert.strictEqual(false ?? 'default', false);
});

// Test private fields
test('Private fields cannot be accessed from outside', () => {
  class Counter {
    #count = 0;
    
    increment() {
      this.#count++;
    }
    
    getCount() {
      return this.#count;
    }
  }
  
  const counter = new Counter();
  counter.increment();
  assert.strictEqual(counter.getCount(), 1);
  
  // Private field should not be accessible
  assert.strictEqual(counter.count, undefined);
});

// Test static members
test('Static members belong to the class', () => {
  class MathHelper {
    static PI = 3.14159;
    
    static area(radius) {
      return this.PI * radius * radius;
    }
  }
  
  assert.strictEqual(MathHelper.PI, 3.14159);
  assert(MathHelper.area(1) > 3);
  
  const instance = new MathHelper();
  assert.strictEqual(instance.PI, undefined);
});

// Test logical assignment
test('Logical assignment operators', () => {
  let a;
  a ??= 10;
  assert.strictEqual(a, 10);
  
  let b = 5;
  b ??= 20;
  assert.strictEqual(b, 5);
  
  let c = false;
  c ||= true;
  assert.strictEqual(c, true);
  
  let d = 5;
  d &&= 10;
  assert.strictEqual(d, 10);
});

// Test Array.at()
test('Array.at() supports negative indices', () => {
  const arr = [1, 2, 3, 4, 5];
  assert.strictEqual(arr.at(-1), 5);
  assert.strictEqual(arr.at(-2), 4);
  assert.strictEqual(arr.at(0), 1);
});
