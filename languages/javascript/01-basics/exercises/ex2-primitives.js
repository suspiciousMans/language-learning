// ex2-primitives.js
// Declare one variable of each primitive type and log its typeof.

const myString = 'hello world';
const myNumber = 42;
const myBoolean = true;
const myNull = null;
const myUndefined = undefined;
const mySymbol = Symbol('description');
const myBigInt = 12345678901234567890n;

console.log('string:', myString, '→ typeof:', typeof myString);
console.log('number:', myNumber, '→ typeof:', typeof myNumber);
console.log('boolean:', myBoolean, '→ typeof:', typeof myBoolean);
console.log('null:', myNull, '→ typeof:', typeof myNull); // ⚠️ 'object' — a famous bug
console.log('undefined:', myUndefined, '→ typeof:', typeof myUndefined);
console.log('symbol:', mySymbol, '→ typeof:', typeof mySymbol);
console.log('bigint:', myBigInt, '→ typeof:', typeof myBigInt);

// typeof null === 'object' is a historical bug in JavaScript that can't be fixed
// because it would break existing code. Always check null with === null.
console.log('\n--- typeof gotchas ---');
console.log('typeof null === "object":', typeof null === 'object');
console.log('null === null:', myNull === null);
console.log('typeof array:', typeof []); // 'object' — arrays are objects
console.log('Array.isArray([]):', Array.isArray([]));
