// ex6-map-and-set.js
// Use Map and Set, their methods, and when to prefer them over objects/arrays.

// Map with object keys
const cache = new Map();
const user1 = { id: 1 };
const user2 = { id: 2 };

cache.set(user1, 'User 1 data');
cache.set(user2, 'User 2 data');

console.log('Map.has(user1):', cache.has(user1));
console.log('Map.get(user1):', cache.get(user1));
console.log('Map.size:', cache.size);

// Iterate over Map
console.log('Iterating Map:');
for (const [key, value] of cache) {
  console.log(`  Key id: ${key.id}, Value: ${value}`);
}

// Map.entries(), keys(), values()
console.log('Map.keys():', Array.from(cache.keys()));
console.log('Map.values():', Array.from(cache.values()));

// Set for unique values
const numbers = [1, 2, 2, 3, 3, 3, 4];
const uniqueNumbers = new Set(numbers);
console.log('Set from array:', uniqueNumbers);
console.log('Set.size:', uniqueNumbers.size);

// Set methods
const tags = new Set(['js', 'web', 'frontend']);
tags.add('react');
console.log('After add:', tags);
console.log('tags.has("web"):', tags.has('web'));

tags.delete('web');
console.log('After delete:', tags);

// Iterate over Set
console.log('Set iteration:');
for (const tag of tags) {
  console.log('  ', tag);
}

// Map and Set to array
const setAsArray = Array.from(uniqueNumbers);
console.log('Set as array:', setAsArray);
