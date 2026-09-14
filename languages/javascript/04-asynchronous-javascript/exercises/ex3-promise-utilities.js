// ex3-promise-utilities.js
// Promise.all(), Promise.race(), Promise.allSettled(), Promise.any().

// Promise.all() — wait for all
const p1 = Promise.resolve(1);
const p2 = Promise.resolve(2);
const p3 = Promise.resolve(3);

Promise.all([p1, p2, p3])
  .then((results) => console.log('All resolved:', results));

// Promise.race() — first to settle wins
const slow = new Promise((resolve) => setTimeout(() => resolve('slow'), 200));
const fast = new Promise((resolve) => setTimeout(() => resolve('fast'), 50));

Promise.race([slow, fast])
  .then((result) => console.log('Race winner:', result));

// Promise.allSettled() — get all results, success or failure
const succeeded = Promise.resolve('yes');
const failed = Promise.reject(new Error('no'));

Promise.allSettled([succeeded, failed])
  .then((results) => {
    console.log('All settled:');
    results.forEach((r, i) => {
      console.log(`  Result ${i}:`, r);
    });
  });

// Promise.any() — first success
const p4 = Promise.reject(new Error('fail 1'));
const p5 = Promise.resolve('success');
const p6 = Promise.reject(new Error('fail 2'));

Promise.any([p4, p5, p6])
  .then((result) => console.log('Any succeeded:', result))
  .catch((error) => console.error('All failed:', error.message));
