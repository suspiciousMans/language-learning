// ex2-constructor-functions.js
// Constructor functions and prototypes.

function Person(name, age) {
  this.name = name;
  this.age = age;
}

// Add methods to the prototype
Person.prototype.greet = function() {
  return `Hi, I'm ${this.name}`;
};

Person.prototype.haveBirthday = function() {
  this.age++;
};

const alice = new Person('Alice', 30);
const bob = new Person('Bob', 25);

console.log('alice.greet():', alice.greet());
console.log('bob.greet():', bob.greet());

alice.haveBirthday();
console.log('alice.age after birthday:', alice.age);

// Instances are independent
console.log('\nInstances are independent:');
console.log('alice === bob:', alice === bob); // false

// But share prototype methods
console.log('alice.greet === bob.greet:', alice.greet === bob.greet); // true (same method)

// Check instanceof
console.log('\ninstanceof checks:');
console.log('alice instanceof Person:', alice instanceof Person); // true
console.log('alice instanceof Object:', alice instanceof Object); // true

// Show prototype chain
console.log('\nPrototype chain:');
console.log('Object.getPrototypeOf(alice) === Person.prototype:', 
  Object.getPrototypeOf(alice) === Person.prototype);
