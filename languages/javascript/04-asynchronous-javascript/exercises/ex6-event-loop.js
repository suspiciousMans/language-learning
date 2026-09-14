// ex6-event-loop.js
// Understanding the event loop and microtasks vs macrotasks.

console.log('1. Start');

// Macrotask: setTimeout
setTimeout(() => {
  console.log('2. setTimeout (macrotask)');
}, 0);

// Microtask: Promise
Promise.resolve()
  .then(() => {
    console.log('3. Promise (microtask)');
  });

// Synchronous
console.log('4. End');

// Output order: 1, 4, 3, 2
// Sync code runs first, then microtasks, then macrotasks

console.log('\n--- Nested example ---');

console.log('A');

Promise.resolve()
  .then(() => {
    console.log('B (microtask 1)');
    Promise.resolve().then(() => {
      console.log('C (nested microtask)');
    });
  });

setTimeout(() => {
  console.log('D (macrotask 1)');
  Promise.resolve().then(() => {
    console.log('E (microtask in macrotask)');
  });
}, 0);

setTimeout(() => {
  console.log('F (macrotask 2)');
}, 0);

console.log('G');

// Output: A, G, B, C, D, E, F
