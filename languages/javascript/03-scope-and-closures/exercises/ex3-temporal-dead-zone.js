// ex3-temporal-dead-zone.js
// Temporal dead zone: let/const cannot be accessed before declaration.

function varDemo() {
  console.log('Before var declaration, x =', x);
  var x = 5;
}
varDemo();

function letDemo() {
  let y = 10;
  console.log('After let declaration, y:', y);
}

letDemo();

console.log('The temporal dead zone is where a variable exists but is not yet initialized.');
