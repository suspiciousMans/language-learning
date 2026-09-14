// ex1-arrays.js
// Create an array of numbers and use .map(), .filter(), and .reduce().
// Demonstrate .slice() and .splice() side-by-side.

const numbers = [1, 2, 3, 4, 5];

// Use .map() to square each number
const squared = numbers.map(n => n * n);
console.log('Original:', numbers);
console.log('Squared:', squared);

// Use .filter() to keep only even numbers
const evens = numbers.filter(n => n % 2 === 0);
console.log('Even numbers:', evens);

// Use .reduce() to sum all numbers
const sum = numbers.reduce((acc, n) => acc + n, 0);
console.log('Sum:', sum);

// Demonstrate .slice() (immutable)
const sliced = numbers.slice(1, 4);
console.log('Sliced [1, 4):', sliced);
console.log('Original after slice:', numbers); // unchanged

// Demonstrate .splice() (mutates)
const spliceCopy = [...numbers]; // make a copy to show mutation
const removed = spliceCopy.splice(1, 2);
console.log('Removed with splice:', removed);
console.log('Array after splice:', spliceCopy); // changed
