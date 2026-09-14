/**
 * 02-types — solution: all five exercises, working.
 */

// ── 01-primitives-and-literals.ts ────────────────────────────────
const str: string = "hello";
const num: number = 42;
const bool: boolean = true;
const nil: null = null;
const undef: undefined = undefined;
const bigintVal: bigint = 100n;
const symVal: symbol = Symbol("x");

// Literal types
type Status = "pending" | "approved" | "rejected";
const s: Status = "pending";
const port: 3000 | 8080 = 3000;
const answer: 42 = 42;

// ── 02-unions-intersections.ts ───────────────────────────────────
type StringOrNum = string | number;
function printId(id: StringOrNum): void {
  console.log(`id: ${id}`);
}

type A = { a: string };
type B = { b: number };
type AB = A & B;

const ab: AB = { a: "hi", b: 7 };
console.log(`${ab.a} ${ab.b}`);

// ── 03-aliases-vs-interfaces.ts ──────────────────────────────────
// Type alias — cannot be merged/redeclared; good for unions, intersections.
type PointAlias = {
  x: number;
  y: number;
};

// Interface — can be declared multiple times and merged; good for
// object shapes you expect to extend.
interface PointInterface {
  x: number;
  y: number;
}

const p1: PointAlias = { x: 1, y: 2 };
const p2: PointInterface = { x: 3, y: 4 };

// ── 04-narrowing.ts ──────────────────────────────────────────────
function processValue(x: string | number | boolean): string {
  if (typeof x === "string") {
    return `string: ${x.toUpperCase()}`;
  }
  if (typeof x === "number") {
    return `number: ${x.toFixed(2)}`;
  }
  // x is boolean here
  return `boolean: ${x ? "yes" : "no"}`;
}

function handleNull(x: string | null): string {
  if (x !== null) {
    return x.toUpperCase();
  }
  return "(null)";
}

function hasLabel(obj: unknown): obj is { label: string } {
  return typeof obj === "object" && obj !== null && "label" in obj;
}

function extractLabel(obj: unknown): string {
  if (hasLabel(obj)) {
    return obj.label;
  }
  return "(no label)";
}

// ── 05-discriminated-unions.ts ───────────────────────────────────
type Circle = { kind: "circle"; radius: number };
type Square = { kind: "square"; side: number };
type Rectangle = { kind: "rectangle"; width: number; height: number };
type Shape = Circle | Square | Rectangle;

function area(s: Shape): number {
  switch (s.kind) {
    case "circle":
      return Math.PI * s.radius * s.radius;
    case "square":
      return s.side * s.side;
    case "rectangle":
      return s.width * s.height;
  }
}
