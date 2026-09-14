/**
 * 03-generics-and-utilities/exercises/04-mapped-types.ts
 *
 * Write mapped types that transform each property of a type.
 * Fill in the mapped type bodies so that `npx tsc --noEmit` passes.
 */

// Make every property readonly.
type Readonly<T> = {
  readonly [K in keyof T]: /* T[K] */;
};

// Make every property optional.
type Optional<T> = {
  [K in keyof T]?: /* T[K] */;
};

// Rename every key by prepending "renamed_".
type RenameKeys<T> = {
  [K in keyof T as `renamed_${string & K}`]: /* T[K] */;
};
