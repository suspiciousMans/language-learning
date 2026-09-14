// ex2-promises.js
// Create, resolve, and reject Promises. Chain with .then().

const resolvedPromise = Promise.resolve(42);
resolvedPromise.then((value) => {
  console.log('Resolved:', value);
});

// Create a Promise manually
const promise = new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve('Success!');
  }, 100);
});

promise.then((result) => {
  console.log('Result:', result);
});

// Promise that rejects
const rejectedPromise = new Promise((resolve, reject) => {
  setTimeout(() => {
    reject(new Error('Something went wrong'));
  }, 100);
});

rejectedPromise
  .then((result) => console.log('Success:', result))
  .catch((error) => console.log('Caught error:', error.message));

// Chaining .then()
new Promise((resolve) => {
  resolve(1);
})
  .then((x) => {
    console.log('First .then:', x);
    return x + 1;
  })
  .then((x) => {
    console.log('Second .then:', x);
    return x + 1;
  })
  .then((x) => {
    console.log('Final .then:', x);
  });
