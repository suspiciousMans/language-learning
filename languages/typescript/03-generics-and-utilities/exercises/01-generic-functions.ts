/**
 * 03-generics-and-utilities/exercises/01-generic-functions.ts
 *
 * Write generic functions: identity, swap, wrap, and a constrained
 * longest function. Fill in the type parameters and constraints so
 * that `npx tsc --noEmit` passes.
 */

// Identity: return the input unchanged, preserving its type.
function identity<T>(x: T): /* return type */ {
  return x;
}

// Swap: return a tuple with the two arguments swapped.
function swap<A, B>(a: A, b: B): /* return type */ {
  return [b, a];
}

// Wrap: put a value into a single-element array.
function wrap<T>(x: T): /* return type */ {
  return [x];
}

// Constrained: only accepts values with a .length property.
function longest<T extends /* constraint */>(a: T, b: T): T {
  return a.length >= b.length ? a : b;
}
