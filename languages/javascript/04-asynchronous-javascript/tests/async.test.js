import test from 'node:test';
import assert from 'node:assert';

// Test Promise basics
test('Promise resolves correctly', async (t) => {
  const promise = new Promise((resolve) => {
    resolve(42);
  });
  
  const result = await promise;
  assert.strictEqual(result, 42);
});

test('Promise rejects correctly', async (t) => {
  const promise = Promise.reject(new Error('fail'));
  
  await assert.rejects(
    async () => {
      await promise;
    },
    (err) => err.message === 'fail'
  );
});

// Test Promise.all
test('Promise.all waits for all', async (t) => {
  const promises = [Promise.resolve(1), Promise.resolve(2), Promise.resolve(3)];
  const results = await Promise.all(promises);
  assert.deepStrictEqual(results, [1, 2, 3]);
});

// Test async/await
test('async function returns a Promise', async (t) => {
  async function getValue() {
    return 42;
  }
  
  const result = await getValue();
  assert.strictEqual(result, 42);
});

// Test error handling in async
test('try/catch catches Promise rejection', async (t) => {
  let caught = false;
  try {
    await Promise.reject(new Error('test'));
  } catch (err) {
    caught = true;
    assert.strictEqual(err.message, 'test');
  }
  assert(caught);
});

// Test event loop order
test('Microtasks before macrotasks', async (t) => {
  const order = [];
  
  order.push('sync');
  
  Promise.resolve().then(() => {
    order.push('microtask');
  });
  
  setTimeout(() => {
    order.push('macrotask');
  }, 0);
  
  // Give event loop time to process
  await new Promise((resolve) => setTimeout(resolve, 50));
  
  assert.deepStrictEqual(order, ['sync', 'microtask', 'macrotask']);
});
