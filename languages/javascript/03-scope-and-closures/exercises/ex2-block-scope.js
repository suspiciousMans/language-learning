// ex2-block-scope.js
// Block scope with let and const.

if (true) {
  let ifLet = 'visible in if block';
  const ifConst = 'also visible in if block';
  console.log('Inside if:', ifLet, ifConst);
}

for (let i = 0; i < 3; i++) {
  console.log('Loop i:', i);
}

{
  const blockVar = 'only visible in this block';
  console.log('In standalone block:', blockVar);
}

const name = 'outer';
{
  const name = 'inner block 1';
  console.log('Block 1, name:', name);
}
{
  const name = 'inner block 2';
  console.log('Block 2, name:', name);
}
console.log('Outer, name:', name);
