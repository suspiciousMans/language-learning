# Project 06 — Classes and Prototypes

Understand prototypal inheritance, the class syntax, and how they work together. Master inheritance, polymorphism, and the `this` keyword.

## Goals

- Understand the prototype chain and prototypal inheritance.
- Create classes and understand how they desugar to functions.
- Use inheritance with `extends` and `super`.
- Implement getters and setters.
- Use static methods and properties.
- Understand the difference between `this` in classes vs functions.

## Concepts

### Prototypes

- Every object has an internal `[[Prototype]]` link to another object.
- Property lookup follows the prototype chain.
- `Object.create(proto)` creates an object with a specific prototype.
- `Object.getPrototypeOf(obj)` and `Object.setPrototypeOf(obj, proto)` manipulate prototypes.

### Constructor Functions

- Functions called with `new` are constructors.
- `this` inside a constructor refers to the newly created object.
- Properties added to `this` become instance properties.
- Methods should be added to `Constructor.prototype`.

### Class Syntax

- `class` is syntactic sugar over constructor functions and prototypes.
- `constructor()` is the initialization method.
- Methods are defined on the prototype.
- `static` methods belong to the class itself.

### Inheritance

- `extends` creates a subclass that inherits from a superclass.
- `super()` calls the parent constructor.
- `super.method()` calls parent methods.
- Subclass methods override parent methods (polymorphism).

### Getters and Setters

- `get prop()` defines a computed getter.
- `set prop(value)` defines a setter.
- Getters and setters are called like properties, not methods.

### `this` Binding

- `this` in methods refers to the instance (with some exceptions).
- Arrow functions don't have their own `this`.
- Use arrow functions in classes for methods that are passed as callbacks.

## Prerequisites

Projects 01, 03.

## Completion checklist

- [ ] Understand how prototypes work and how to inspect the prototype chain.
- [ ] Create a constructor function and add methods to its prototype.
- [ ] Create a class and instantiate it with `new`.
- [ ] Create a subclass using `extends` and implement inheritance.
- [ ] Use `super()` to call the parent constructor.
- [ ] Implement getters and setters.
- [ ] Create static methods.
- [ ] Understand how classes desugar to functions and prototypes.

## Exercises

### ex1-prototypes.js

- Create objects and inspect their prototypes with `Object.getPrototypeOf()`.
- Create a prototype chain manually.
- Show property lookup following the chain.
- Use `Object.create()` to create objects with specific prototypes.

### ex2-constructor-functions.js

- Create a constructor function and use `new` to instantiate it.
- Add methods to the prototype.
- Show that instances share prototype methods but have separate properties.
- Use `instanceof` to check if an object is an instance of a constructor.

### ex3-classes.js

- Create a simple class with a constructor and methods.
- Show that classes are syntactic sugar over functions.
- Use `new` to instantiate a class.
- Understand how `this` works in class methods.

### ex4-inheritance.js

- Create a subclass using `extends`.
- Use `super()` to call the parent constructor.
- Override parent methods.
- Use `super.method()` to call parent methods.

### ex5-getters-setters.js

- Create getters and setters in a class.
- Show that getters are called like properties.
- Use getters for computed properties.
- Use setters for validation or side effects.

### ex6-static-members.js

- Create static methods and properties in a class.
- Show that static members belong to the class, not instances.
- Use static methods for factory functions or utilities.

## Running exercises

```bash
node exercises/ex1-prototypes.js
node exercises/ex2-constructor-functions.js
node exercises/ex3-classes.js
node exercises/ex4-inheritance.js
node exercises/ex5-getters-setters.js
node exercises/ex6-static-members.js
```

## Running tests

```bash
node --test tests/*.test.js
```

## What "done" looks like

All exercises run without errors. All tests pass. You understand the prototype chain and can explain how classes desugar to functions and prototypes.
