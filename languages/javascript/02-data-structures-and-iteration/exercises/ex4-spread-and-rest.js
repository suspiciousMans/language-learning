// ex4-spread-and-rest.js
// Use spread to concatenate/merge, rest parameters in functions.

// Spread with arrays
const arr1 = [1, 2, 3];
const arr2 = [4, 5, 6];
const combined = [...arr1, ...arr2];
console.log('Combined arrays:', combined);

// Spread with objects
const obj1 = { a: 1, b: 2 };
const obj2 = { c: 3, d: 4 };
const mergedObj = { ...obj1, ...obj2 };
console.log('Merged objects:', mergedObj);

// Rest parameters in function
function sum(...numbers) {
  return numbers.reduce((acc, n) => acc + n, 0);
}
console.log('Sum with rest params:', sum(1, 2, 3, 4, 5));

// Rest with leading parameters
function greet(greeting, ...names) {
  return `${greeting} ${names.join(', ')}!`;
}
console.log('Greet:', greet('Hello', 'Alice', 'Bob', 'Charlie'));

// Rest in destructuring
const [head, ...tail] = [10, 20, 30, 40];
console.log('Head:', head, 'Tail:', tail);

// Rest in object destructuring
const { x, y, ...others } = { x: 1, y: 2, z: 3, w: 4 };
console.log('x:', x, 'y:', y, 'others:', others);
