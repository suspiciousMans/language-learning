// ex7-iife.js
// IIFE for encapsulation.

(function() {
  console.log('This runs immediately and has its own scope.');
  const privateVar = 'not global';
})();

(function(name, greeting) {
  console.log(`${greeting}, ${name}!`);
})('Bob', 'Howdy');

const module = (function() {
  let privateCounter = 0;
  
  return {
    increment() {
      privateCounter++;
      return privateCounter;
    },
    getCurrentCount() {
      return privateCounter;
    },
    reset() {
      privateCounter = 0;
    },
  };
})();

console.log('\nIIFE module pattern:');
console.log('Increment:', module.increment());
console.log('Increment:', module.increment());
console.log('Current:', module.getCurrentCount());
module.reset();
console.log('After reset:', module.getCurrentCount());
