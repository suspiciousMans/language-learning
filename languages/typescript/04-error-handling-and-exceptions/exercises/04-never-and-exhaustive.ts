/**
 * 04-error-handling-and-exceptions/exercises/04-never-and-exhaustive.ts
 *
 * Write exhaustive checks using the `never` type.
 * Fill in the missing switch/default branches so that `npx tsc --noEmit` passes.
 */

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
    default: {
      // Exhaustive check: if a new Shape is added without handling it
      // here, this line becomes a type error.
      const _exhaustiveCheck: never = s;
      throw new Error(`unhandled shape kind: ${_exhaustiveCheck}`);
    }
  }
}
