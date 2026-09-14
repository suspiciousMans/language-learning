// ex5-closure-pitfalls.js
// Common closure pitfall: loops capturing variables.

console.log('Pitfall with var:');
const functionsVar = [];
for (var i = 0; i < 3; i++) {
  functionsVar.push(() => i);
}
console.log('var loop:', functionsVar.map(f => f()));

console.log('\nFix with let:');
const functionsLet = [];
for (let i = 0; i < 3; i++) {
  functionsLet.push(() => i);
}
console.log('let loop:', functionsLet.map(f => f()));

console.log('\nFix with IIFE:');
const functionsIIFE = [];
for (var j = 0; j < 3; j++) {
  functionsIIFE.push(
    (function(captured) {
      return () => captured;
    })(j)
  );
}
console.log('IIFE loop:', functionsIIFE.map(f => f()));
