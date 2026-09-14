/**
 * 01-variables.ts — exercise for project 01.
 *
 * Annotate each variable with the correct primitive type so that
 * tsc --noEmit passes with zero errors. Some annotations are
 * intentionally missing or wrong — fix them.
 */

// Primitives — annotate each one.
const greeting = "hello, TypeScript";
const count = 42;
const isActive = true;
const nothing = null;
const notDefined = undefined;
const sym = Symbol("desc");
const big = BigInt(100);

// Arrays and tuples — annotate each one.
const scores = [1, 2, 3];
const names = ["a", "b"];
const point = [10, 20];

// Hint: arrays can be `number[]` or `Array<number>`.
//       tuples are `[number, number]`.
