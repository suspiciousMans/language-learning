// ex4-closures.js
// Creating and using closures.

function makeGreeter(greeting) {
  return function(name) {
    return `${greeting}, ${name}!`;
  };
}

const sayHello = makeGreeter('Hello');
const sayHi = makeGreeter('Hi');

console.log('Closure 1:', sayHello('Alice'));
console.log('Closure 2:', sayHi('Bob'));

function makeCounter() {
  let count = 0;
  return {
    increment() {
      count++;
      return count;
    },
    decrement() {
      count--;
      return count;
    },
    getCount() {
      return count;
    },
  };
}

const counter1 = makeCounter();
const counter2 = makeCounter();

console.log('\nCounter 1:', counter1.increment(), counter1.increment());
console.log('Counter 2:', counter2.increment());
console.log('Counter 1 again:', counter1.getCount());
console.log('Counter 2 again:', counter2.getCount());
