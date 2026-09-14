// ex4-functions.js
// Three ways to define functions: declarations, expressions, arrows.
// Also shows hoisting differences.

// --- Function Declaration ---
// Hoisted: can be called before its definition in the same scope.
function addDeclaration(a, b) {
  return a + b;
}

// --- Function Expression ---
// Not hoisted: the variable is hoisted (as undefined) but the function isn't assigned until the line runs.
const addExpression = function (a, b) {
  return a + b;
};

// --- Arrow Function ---
// Concise syntax, no `this` of its own, no `arguments` object.
const addArrow = (a, b) => a + b;

// --- Arrow with block body ---
const addArrowBlock = (a, b) => {
  console.log(`adding ${a} + ${b}`);
  return a + b;
};

// --- Test all three ---
console.log('declaration:', addDeclaration(2, 3));
console.log('expression:', addExpression(2, 3));
console.log('arrow (concise):', addArrow(2, 3));
console.log('arrow (block):', addArrowBlock(2, 3));

// --- Hoisting demo ---
// Declaration can be used before definition:
console.log('hoisted call:', hoistedFunction(10)); // works
function hoistedFunction(x) {
  return x * 2;
}

// Expression CANNOT be used before definition:
// console.log(notHoisted(5)); // ReferenceError: Cannot access 'notHoisted' before initialization
const notHoisted = function (x) {
  return x * 2;
};
console.log('notHoisted (after definition):', notHoisted(5));

// --- Arrow and `this` ---
// Arrow functions do NOT have their own `this`. They inherit from the enclosing scope.
const obj = {
  value: 42,
  declarationMethod() {
    console.log('declaration this.value:', this.value);
    function inner() {
      // `this` inside a regular function called as a plain function is undefined (strict mode)
      console.log('inner function this:', this);
    }
    inner();

    const arrowInner = () => {
      // arrow inherits `this` from declarationMethod's scope
      console.log('arrow inner this.value:', this.value);
    };
    arrowInner();
  },
};

obj.declarationMethod();

// --- Default parameters ---
function greet(name = 'world') {
  return `Hello, ${name}!`;
}
console.log(greet());
console.log(greet('Alice'));

// --- Rest parameters ---
function sumAll(...numbers) {
  return numbers.reduce((total, n) => total + n, 0);
}
console.log('sumAll(1,2,3,4):', sumAll(1, 2, 3, 4));
