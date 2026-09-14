// ex2-objects.js
// Create objects, access with dot and bracket notation, merge with spread.

const person = {
  name: 'Alice',
  age: 30,
  city: 'Portland',
};

console.log('Dot notation:', person.name, person.age);
console.log('Bracket notation:', person['name'], person['city']);

// Property shorthand
const firstName = 'Bob';
const userAge = 25;
const user = { firstName, userAge };
console.log('Shorthand object:', user);

// Merge two objects with spread
const defaults = { theme: 'light', language: 'en' };
const overrides = { theme: 'dark' };
const merged = { ...defaults, ...overrides };
console.log('Merged:', merged);

// Iterate with for...in
console.log('Keys via for...in:');
for (const key in person) {
  console.log(`  ${key}: ${person[key]}`);
}

// Iterate with Object.keys()
console.log('Keys via Object.keys():', Object.keys(person));
console.log('Values via Object.values():', Object.values(person));
console.log('Entries via Object.entries():', Object.entries(person));
