// ex5-iteration.js
// Different ways to iterate: for...of, for...in, forEach, map/filter/reduce.

const numbers = [10, 20, 30, 40];

// for...of — iterate over values (preferred for arrays)
console.log('for...of:');
for (const num of numbers) {
  console.log('  ', num);
}

// for...in — iterate over indices/keys (avoid for arrays)
console.log('for...in (indices):');
for (const idx in numbers) {
  console.log('  ', idx, ':', numbers[idx]);
}

// forEach with value and index
console.log('forEach:');
numbers.forEach((num, idx) => {
  console.log('  ', idx, ':', num);
});

// Functional chain: map, filter, reduce
const result = numbers
  .filter(n => n > 15)
  .map(n => n * 2)
  .reduce((sum, n) => sum + n, 0);
console.log('Functional chain (filter > map > reduce):', result);

// Object iteration
const person = { name: 'Diana', age: 28, city: 'Seattle' };

// for...in on object
console.log('Object with for...in:');
for (const key in person) {
  console.log(`  ${key}: ${person[key]}`);
}

// Object.entries with for...of
console.log('Object.entries with for...of:');
for (const [key, value] of Object.entries(person)) {
  console.log(`  ${key}: ${value}`);
}
