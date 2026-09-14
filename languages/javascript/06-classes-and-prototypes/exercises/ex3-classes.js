// ex3-classes.js
// Classes as syntactic sugar over constructor functions.

class Animal {
  constructor(name) {
    this.name = name;
  }

  sound() {
    return `${this.name} makes a sound`;
  }

  static info() {
    return 'This is the Animal class';
  }
}

const dog = new Animal('Dog');
console.log('dog.sound():', dog.sound());
console.log('Animal.info():', Animal.info());

// Classes are still functions under the hood
console.log('\nClasses are functions:');
console.log('typeof Animal:', typeof Animal); // 'function'
console.log('dog instanceof Animal:', dog instanceof Animal); // true

// Show that methods are on the prototype
console.log('Animal.prototype.sound === dog.sound:', 
  Animal.prototype.sound === dog.sound); // true (methods are shared)

// Constructor property
console.log('dog.constructor === Animal:', dog.constructor === Animal); // true
