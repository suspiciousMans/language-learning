/**
 * 01-basics — solution: all four exercises, working.
 *
 * This is the reference solution for project 01. Compare your fixes
 * against these annotated versions.
 */

// ── 01-variables.ts ──────────────────────────────────────────────
// Annotate variables with correct primitive types.

const greeting: string = "hello, TypeScript";
const count: number = 42;
const isActive: boolean = true;
const nothing: null = null;
const notDefined: undefined = undefined;
const sym: symbol = Symbol("desc");
const big: bigint = BigInt(100);

// Array and tuple types.
const scores: number[] = [1, 2, 3];
const names: Array<string> = ["a", "b"];
const point: [number, number] = [10, 20];

// ── 02-functions.ts ──────────────────────────────────────────────
// Annotate function parameters and return types.

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

// ── 03-arrays-tuples.ts ──────────────────────────────────────────
// Work with arrays, tuples, and array typing.

function first<T>(arr: T[]): T | undefined {
  return arr[0];
}

function second<T>(arr: T[]): T | undefined {
  return arr[1];
}

function toPairs<T>(arr: T[]): [T, T][] {
  const pairs: [T, T][] = [];
  for (let i = 0; i < arr.length - 1; i += 2) {
    pairs.push([arr[i], arr[i + 1]]);
  }
  return pairs;
}

const rgb: [number, number, number] = [255, 128, 0];

// ── 04-objects.ts ────────────────────────────────────────────────
// Type simple object literals and function parameters that are objects.

interface User {
  name: string;
  age: number;
  email?: string;
}

function formatUser(user: User): string {
  const parts = [user.name, `age ${user.age}`];
  if (user.email) {
    parts.push(user.email);
  }
  return parts.join(" — ");
}

const u: User = {
  name: "Ada",
  age: 36,
  email: "ada@example.com",
};

const anonymous: User = {
  name: "Anonymous",
  age: 0,
};
