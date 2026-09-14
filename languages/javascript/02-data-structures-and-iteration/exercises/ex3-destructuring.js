// ex3-destructuring.js
// Destructure arrays and objects with defaults and nesting.

// Array destructuring
const colors = ['red', 'green', 'blue'];
const [primary, secondary, tertiary] = colors;
console.log('Destructured array:', primary, secondary, tertiary);

// Array destructuring with defaults
const [a, b, c = 'default'] = [1, 2];
console.log('With defaults:', a, b, c);

// Object destructuring
const config = { host: 'localhost', port: 3000, debug: true };
const { host, port } = config;
console.log('Destructured object:', host, port);

// Rename on destructuring
const { debug: debugMode } = config;
console.log('Renamed:', debugMode);

// Nested destructuring
const user = {
  id: 1,
  profile: {
    name: 'Charlie',
    email: 'charlie@example.com',
  },
};
const { profile: { name, email } } = user;
console.log('Nested:', name, email);

// Destructure with rest
const [first, ...rest] = [1, 2, 3, 4, 5];
console.log('First:', first, 'Rest:', rest);
