// ex4-async-await.js
// Use async/await for cleaner asynchronous code.

// Simple async function
async function simpleAsync() {
  return 'Hello';
}

simpleAsync().then((msg) => console.log(msg));

// async with await
async function fetchData() {
  const promise = new Promise((resolve) => {
    setTimeout(() => resolve({ id: 1, name: 'Alice' }), 100);
  });
  
  const data = await promise;
  console.log('Fetched:', data);
  return data;
}

fetchData();

// Multiple awaits
async function fetchMultiple() {
  const user = await Promise.resolve({ id: 1, name: 'Bob' });
  const posts = await Promise.resolve([{ id: 1, title: 'Post' }]);
  console.log('User:', user, 'Posts:', posts);
}

fetchMultiple();

// Error handling with try/catch
async function fetchWithError() {
  try {
    const result = await Promise.reject(new Error('API failed'));
  } catch (error) {
    console.log('Caught error in async:', error.message);
  } finally {
    console.log('Cleanup done');
  }
}

fetchWithError();
