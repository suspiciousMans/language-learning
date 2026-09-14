/**
 * 02-types/exercises/05-discriminated-unions.ts
 *
 * Model a state machine with a discriminated union and narrow on the
 * discriminant property.
 *
 * Fill in the missing types and the area() function body so that
 * `npx tsc --noEmit` passes.
 */

type Circle = { kind: "circle"; radius: number };
type Square = { kind: "square"; side: number };
type Rectangle = { kind: "rectangle"; width: number; height: number };

type Shape = Circle | Square | Rectangle;

function area(s: Shape): number {
  switch (s.kind) {
    case "circle":
      return /* Math.PI * s.radius * s.radius */;
    case "square":
      return /* s.side * s.side */;
    case "rectangle":
      return /* s.width * s.height */;
  }
}
