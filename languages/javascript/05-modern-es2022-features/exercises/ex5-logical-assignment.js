// ex4-logical-assignment.js
// Logical assignment operators (??=, ||=, &&=).

let x;
x ??= 10;
console.log('x ??= 10 when x is undefined:', x); // 10

let y = 5;
y ??= 20;
console.log('y ??= 20 when y = 5:', y); // 5 (not overridden)

// ||= with falsy values
let name = '';
name ||= 'Anonymous';
console.log('name ||= "Anonymous" when name = "":', name); // 'Anonymous'

let count = 0;
count ||= 1;
console.log('count ||= 1 when count = 0:', count); // 1

// &&= only assigns if truthy
let active = true;
active &&= false;
console.log('active &&= false when active = true:', active); // false

let inactive = false;
inactive &&= true;
console.log('inactive &&= true when inactive = false:', inactive); // false

// Practical use: configuration defaults
const config = { timeout: 0 };
config.retries ??= 3;
config.timeout ??= 5000;

console.log('\nConfiguration:');
console.log('config.retries:', config.retries); // 3 (was undefined)
console.log('config.timeout:', config.timeout); // 0 (kept original)
