// ex4-inheritance.js
// Inheritance with extends and super.

class Animal {
  constructor(name) {
    this.name = name;
  }

  sound() {
    return `${this.name} makes a generic sound`;
  }
}

class Dog extends Animal {
  constructor(name, breed) {
    super(name);
    this.breed = breed;
  }

  sound() {
    return `${this.name} barks`;
  }

  info() {
    return `${super.sound()} - Breed: ${this.breed}`;
  }
}

const dog = new Dog('Buddy', 'Golden Retriever');
console.log('dog.sound():', dog.sound());
console.log('dog.info():', dog.info());

// Inheritance chain
console.log('\nInheritance:');
console.log('dog instanceof Dog:', dog instanceof Dog);
console.log('dog instanceof Animal:', dog instanceof Animal);
console.log('dog instanceof Object:', dog instanceof Object);

// Override and super
class Cat extends Animal {
  sound() {
    return `${this.name} meows`;
  }
}

const cat = new Cat('Whiskers');
console.log('\ncat.sound():', cat.sound());
