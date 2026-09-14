import test from 'node:test';
import assert from 'node:assert';

// Test prototypes
test('Prototype chain property lookup', () => {
  const parent = { age: 30 };
  const child = Object.create(parent);
  child.name = 'Alice';
  
  assert.strictEqual(child.name, 'Alice');
  assert.strictEqual(child.age, 30);
  assert.strictEqual(Object.getPrototypeOf(child), parent);
});

// Test constructor functions
test('Constructor functions create instances', () => {
  function Person(name) {
    this.name = name;
  }
  
  Person.prototype.greet = function() {
    return `Hi, ${this.name}`;
  };
  
  const alice = new Person('Alice');
  assert.strictEqual(alice.name, 'Alice');
  assert.strictEqual(alice.greet(), 'Hi, Alice');
  assert(alice instanceof Person);
});

// Test class syntax
test('Class syntax is syntactic sugar', () => {
  class Dog {
    constructor(name) {
      this.name = name;
    }
    
    bark() {
      return `${this.name} barks`;
    }
  }
  
  const buddy = new Dog('Buddy');
  assert.strictEqual(buddy.bark(), 'Buddy barks');
  assert(buddy instanceof Dog);
});

// Test inheritance
test('Inheritance with extends and super', () => {
  class Animal {
    constructor(name) {
      this.name = name;
    }
    
    sound() {
      return `${this.name} makes a sound`;
    }
  }
  
  class Dog extends Animal {
    sound() {
      return `${this.name} barks`;
    }
  }
  
  const dog = new Dog('Rex');
  assert.strictEqual(dog.sound(), 'Rex barks');
  assert(dog instanceof Animal);
  assert(dog instanceof Dog);
});

// Test getters and setters
test('Getters and setters', () => {
  class Temperature {
    constructor(celsius) {
      this._celsius = celsius;
    }
    
    get fahrenheit() {
      return (this._celsius * 9/5) + 32;
    }
    
    set fahrenheit(f) {
      this._celsius = (f - 32) * 5/9;
    }
  }
  
  const temp = new Temperature(0);
  assert.strictEqual(temp.fahrenheit, 32);
  
  temp.fahrenheit = 212;
  assert.strictEqual(Math.round(temp._celsius), 100);
});
