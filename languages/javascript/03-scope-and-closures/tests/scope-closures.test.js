import test from 'node:test';
import assert from 'node:assert';

test('var is hoisted and initialized as undefined', () => {
  function demo() {
    assert.strictEqual(typeof x, 'undefined');
    var x = 5;
    assert.strictEqual(x, 5);
  }
  demo();
});

test('let and const are block-scoped', () => {
  {
    let x = 1;
    const y = 2;
    assert.strictEqual(x, 1);
    assert.strictEqual(y, 2);
  }
  assert.throws(() => { x; }, ReferenceError);
});

test('Basic closure captures outer scope', () => {
  function makeAdder(x) {
    return function(y) {
      return x + y;
    };
  }
  
  const add5 = makeAdder(5);
  assert.strictEqual(add5(3), 8);
  assert.strictEqual(add5(10), 15);
});

test('Closures have separate state', () => {
  function makeCounter() {
    let count = 0;
    return {
      increment: () => ++count,
      getCount: () => count,
    };
  }
  
  const c1 = makeCounter();
  const c2 = makeCounter();
  
  assert.strictEqual(c1.increment(), 1);
  assert.strictEqual(c1.increment(), 2);
  assert.strictEqual(c2.increment(), 1);
  assert.strictEqual(c2.getCount(), 1);
  assert.strictEqual(c1.getCount(), 2);
});

test('Closure loop with let captures each iteration', () => {
  const fns = [];
  for (let i = 0; i < 3; i++) {
    fns.push(() => i);
  }
  assert.deepStrictEqual(fns.map(f => f()), [0, 1, 2]);
});

test('Closure loop with var captures final value', () => {
  const fns = [];
  for (var i = 0; i < 3; i++) {
    fns.push(() => i);
  }
  assert.deepStrictEqual(fns.map(f => f()), [3, 3, 3]);
});

test('Private variables via closure', () => {
  function createUser(name) {
    let _name = name;
    return {
      getName: () => _name,
      setName: (n) => { _name = n; },
    };
  }
  
  const u = createUser('Alice');
  assert.strictEqual(u.getName(), 'Alice');
  u.setName('Bob');
  assert.strictEqual(u.getName(), 'Bob');
  assert.strictEqual(u._name, undefined);
});

test('IIFE creates isolated scope', () => {
  let outer = 'outside';
  const result = (function() {
    const inner = 'inside';
    return outer + inner;
  })();
  assert.strictEqual(result, 'outsideinside');
});

test('IIFE with parameters', () => {
  const result = (function(a, b) {
    return a + b;
  })(3, 4);
  assert.strictEqual(result, 7);
});

test('Multiple block scopes can have same variable name', () => {
  const results = [];
  {
    const x = 1;
    results.push(x);
  }
  {
    const x = 2;
    results.push(x);
  }
  assert.deepStrictEqual(results, [1, 2]);
});
