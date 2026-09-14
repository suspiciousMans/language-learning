// ex6-new-array-object-methods.js
// New Array and Object methods in ES2022+.

// Array.prototype.at()
const arr = [10, 20, 30, 40, 50];
console.log('Array:', arr);
console.log('arr.at(0):', arr.at(0)); // 10
console.log('arr.at(-1):', arr.at(-1)); // 50
console.log('arr.at(-2):', arr.at(-2)); // 40

// Object.hasOwn()
const obj = { name: 'Alice', age: 30 };
console.log('\nObject.hasOwn():');
console.log('Object.hasOwn(obj, "name"):', Object.hasOwn(obj, 'name')); // true
console.log('Object.hasOwn(obj, "toString"):', Object.hasOwn(obj, 'toString')); // false
console.log('Old way - obj.hasOwnProperty("name"):', obj.hasOwnProperty('name')); // true

// String.prototype.replaceAll()
const text = 'The quick brown fox';
console.log('\nString.replaceAll():');
console.log('Original:', text);
console.log('Replace "o" with "0":', text.replaceAll('o', '0'));

// Array.prototype.includes()
console.log('\nArray.includes():');
console.log('arr.includes(30):', arr.includes(30)); // true
console.log('arr.includes(100):', arr.includes(100)); // false

// String.prototype.startsWith() and endsWith()
const url = 'https://example.com';
console.log('\nString startsWith/endsWith:');
console.log('url.startsWith("https"):', url.startsWith('https')); // true
console.log('url.endsWith(".com"):', url.endsWith('.com')); // true

// Object.entries() and Object.fromEntries()
const user = { name: 'Bob', age: 25 };
const entries = Object.entries(user);
console.log('\nObject.entries() and fromEntries():');
console.log('entries:', entries);
const reconstructed = Object.fromEntries(entries);
console.log('reconstructed:', reconstructed);
