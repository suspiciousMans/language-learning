/**
 * 02-functions.solution.ts — reference solution for project 01, exercise 02.
 */

function add(a: number, b: number): number {
  return a + b;
}

const multiply = (a: number, b: number): number => a * b;

function greet(name: string, age?: number): string {
  if (age !== undefined) {
    return `hello, ${name}, age ${age}`;
  }
  return `hello, ${name}`;
}

function sumAll(...nums: number[]): number {
  return nums.reduce((acc, n) => acc + n, 0);
}
