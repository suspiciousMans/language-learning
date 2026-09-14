/**
 * 02-types/exercises/02-unions-intersections.ts
 *
 * Write union and intersection types; use them in function signatures.
 * Fill in the missing type annotations so that `npx tsc --noEmit` passes.
 */

// Union type alias — values that can be string OR number.
type StringOrNum = /* your type here */;

function printId(id: StringOrNum): void {
  console.log(`id: ${id}`);
}

// Intersection type — combine A and B into one shape.
type A = { a: string };
type B = { b: number };

type AB = /* your intersection type here */;

const ab: AB = { a: "hi", b: 7 };
console.log(`${ab.a} ${ab.b}`);
