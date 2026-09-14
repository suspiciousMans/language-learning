/**
 * 02-types/exercises/03-aliases-vs-interfaces.ts
 *
 * Define the same shape with a `type` alias and an `interface`.
 * Observe the similarities and differences.
 *
 * Fill in the missing parts so that `npx tsc --noEmit` passes.
 */

// Use a type alias for this object shape.
type PointAlias = {
  // TODO: x and y, both number
};

// Use an interface for the same shape.
interface PointInterface {
  // TODO: x and y, both number
}

const p1: PointAlias = { x: 1, y: 2 };
const p2: PointInterface = { x: 3, y: 4 };
