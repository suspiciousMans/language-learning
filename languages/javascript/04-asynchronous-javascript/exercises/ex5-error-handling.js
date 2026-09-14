// ex5-error-handling.js
// Error handling patterns with Promises and async/await.

// .catch() for Promise rejection
Promise.reject(new Error('Promise rejected'))
  .catch((error) => console.log('Caught with .catch():', error.message));

// .finally() for cleanup
Promise.resolve('Done')
  .then((val) => console.log(val))
  .finally(() => console.log('Finally block runs'));

// try/catch with async
async function asyncWithTryCatch() {
  try {
    const result = await Promise.reject(new Error('Async error'));
  } catch (error) {
    console.log('Caught error:', error.message);
  }
}

asyncWithTryCatch();

// Combining multiple error handlers
async function multipleCatches() {
  try {
    const p1 = await Promise.resolve(1);
    const p2 = await Promise.reject(new Error('Step 2 failed'));
    const p3 = await Promise.resolve(3);
  } catch (error) {
    console.log('Error in step:', error.message);
  }
}

multipleCatches();

// Unhandled rejection (bad practice)
// const unhandled = Promise.reject(new Error('unhandled'));
// Better: always handle rejections
const handled = Promise.reject(new Error('properly handled'))
  .catch(() => {});
