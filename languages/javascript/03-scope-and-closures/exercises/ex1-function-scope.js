// ex1-function-scope.js
// Function scope with var, contrast with let/const.

function demo() {
  var funcVar = 'function-scoped';
  let blockLet = 'block-scoped';
  
  if (true) {
    var funcVar2 = 'also in function scope';
    let blockLet2 = 'block-scoped in if';
    console.log('Inside if — funcVar:', funcVar);
    console.log('Inside if — blockLet2:', blockLet2);
  }
  
  console.log('After if — funcVar2:', funcVar2); // visible (function scope)
  // console.log('After if — blockLet2:', blockLet2); // ReferenceError (block scope)
}

demo();

// Hoisting with var
console.log('\nHoisting demo:');
function hoistingDemo() {
  console.log('Before declaration, x =', x); // undefined (hoisted, not assigned yet)
  var x = 5;
  console.log('After declaration, x =', x); // 5
}

hoistingDemo();

// let does NOT have the same hoisting behavior
function hoistingLet() {
  // console.log('Before let, y =', y); // ReferenceError (temporal dead zone)
  let y = 10;
  console.log('After let declaration, y =', y);
}

hoistingLet();
