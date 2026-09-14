// ex1-callbacks.js
// Callbacks, callback hell, and their problems.

// Simple callback
function fetchUser(id, callback) {
  setTimeout(() => {
    callback({ id, name: 'Alice' });
  }, 100);
}

fetchUser(1, (user) => {
  console.log('User:', user);
});

// Callback hell (pyramid of doom)
function fetchUserWithPosts(id, callback) {
  setTimeout(() => {
    const user = { id, name: 'Bob' };
    setTimeout(() => {
      const posts = [{ id: 1, title: 'Post 1' }];
      setTimeout(() => {
        const comments = [{ id: 1, text: 'Great!' }];
        callback(user, posts, comments);
      }, 50);
    }, 50);
  }, 50);
}

console.log('\nCallback hell:');
fetchUserWithPosts(1, (user, posts, comments) => {
  console.log('User:', user);
  console.log('Posts:', posts);
  console.log('Comments:', comments);
});

// Error handling with callbacks is error-prone
function fetchWithCallback(url, onSuccess, onError) {
  setTimeout(() => {
    if (url.includes('error')) {
      onError(new Error('Failed to fetch'));
    } else {
      onSuccess({ data: 'result' });
    }
  }, 50);
}

fetchWithCallback(
  '/api/data',
  (data) => console.log('Success:', data),
  (error) => console.error('Error:', error.message)
);
