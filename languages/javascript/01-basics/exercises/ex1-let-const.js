// ex1-let-const.js
// Demonstrate let, const, and why var is avoided.

// const: cannot be reassigned
const pi = 3.14159;
console.log('const pi:', pi);
// pi = 3; // TypeError: Assignment to constant variable

// let: can be reassigned, block-scoped
let counter = 0;
counter = counter + 1;
console.log('let counter after increment:', counter);

// Block scope demo
{
  let blockLet = 'visible inside block';
  const blockConst = 'also visible inside block';
  console.log('inside block — let:', blockLet, 'const:', blockConst);
}
// console.log(blockLet);   // ReferenceError: blockLet is not defined
// console.log(blockConst); // ReferenceError: blockConst is not defined

// Why var is avoided:
// var is function-scoped, NOT block-scoped
function varDemo() {
  var x = 1;
  if (true) {
    var x = 2; // same variable, redeclared!
    console.log('inside if — var x:', x);
  }
  console.log('after if — var x:', x); // 2, not 1
}
varDemo();

// var is hoisted (declaration moved to top of scope, initialized as undefined)
console.log('hoistedVar (before declaration):', hoistedVar); // undefined, not ReferenceError
var hoistedVar = 'I am hoisted';
console.log('hoistedVar (after declaration):', hoistedVar);

// let/const are NOT hoisted in the same way — they are in a "temporal dead zone"
// console.log(temporalDeadZone); // ReferenceError
let temporalDeadZone = 'I am NOT hoisted like var';
