// ex1-prototypes.js
// Understanding prototypes and prototype chains.

// Create an object with Object.create
const person = {
  greet() {
    return `Hello, I'm ${this.name}`;
  },
};

const alice = Object.create(person);
alice.name = 'Alice';

console.log('alice.name:', alice.name);
console.log('alice.greet():', alice.greet());

// Check prototype
console.log('Object.getPrototypeOf(alice) === person:', Object.getPrototypeOf(alice) === person);

// Prototype chain
const animal = {
  sound: 'generic sound',
  makeSound() {
    return this.sound;
  },
};

const dog = Object.create(animal);
dog.sound = 'woof';

console.log('\nPrototype chain:');
console.log('dog.makeSound():', dog.makeSound());
console.log('dog.sound:', dog.sound);

// Property lookup follows the chain
for (const key in dog) {
  console.log(`  ${key}: ${dog[key]}`);
}

// hasOwnProperty vs in operator
console.log('\nProperty ownership:');
console.log('dog.hasOwnProperty("sound"):', dog.hasOwnProperty('sound')); // true
console.log('dog.hasOwnProperty("makeSound"):', dog.hasOwnProperty('makeSound')); // false
console.log('"makeSound" in dog:', 'makeSound' in dog); // true (in chain)
