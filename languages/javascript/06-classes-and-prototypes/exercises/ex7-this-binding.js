// ex7-this-binding.js
// Understanding 'this' in classes and methods.

class Counter {
  constructor(initialValue = 0) {
    this.value = initialValue;
  }

  // Regular method - this is bound to the instance
  increment() {
    this.value++;
    return this.value;
  }

  // Arrow function - this is lexically bound
  incrementAsync = async () => {
    return this.value++;
  };

  // Regular method passed as callback loses this
  getIncrementMethod() {
    return this.increment;
  }

  // Better: use arrow function or bind
  getIncrementMethodBound() {
    return this.increment.bind(this);
  }
}

const counter = new Counter(10);
console.log('Initial:', counter.value);
console.log('After increment():', counter.increment()); // 11
console.log('After increment():', counter.increment()); // 12

// Problem: method as callback loses 'this'
const incrementMethod = counter.getIncrementMethod();
try {
  console.log('Calling unbound method:');
  incrementMethod(); // Error: Cannot read property 'value' of undefined
} catch (error) {
  console.log('Error:', error.message);
}

// Solution 1: Use bound method
const boundMethod = counter.getIncrementMethodBound();
console.log('With bound method:', boundMethod()); // Works: 13

// Solution 2: Arrow functions
counter.incrementAsync().then((result) => {
  console.log('Arrow function this:', result);
});
