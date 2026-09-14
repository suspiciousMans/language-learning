/**
 * 02-functions.ts — exercise for project 01.
 *
 * Annotate function parameters and return types so that
 * tsc --noEmit passes with zero errors.
 */

// Fix the missing annotations.
function add(a, b) {
  return a + b;
}

const multiply = (a, b) => a * b;

function greet(name, age) {
  if (age !== undefined) {
    return `hello, ${name}, age ${age}`;
  }
  return `hello, ${name}`;
}

function sumAll(...nums) {
  return nums.reduce((acc, n) => acc + n, 0);
}

// Hint: add has two number params and returns a number.
//       multiply is an arrow function with the same shape.
//       greet takes a string and an optional number; returns a string.
//       sumAll takes a rest parameter of numbers and returns a number.
