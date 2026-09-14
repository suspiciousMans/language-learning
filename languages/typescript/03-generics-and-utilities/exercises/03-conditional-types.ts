/**
 * 03-generics-and-utilities/exercises/03-conditional-types.ts
 *
 * Write conditional types that branch on a type condition.
 * Fill in the right-hand sides so that `npx tsc --noEmit` passes.
 */

// IsString<T>: true if T extends string, false otherwise.
type IsString<T> = /* T extends string ? true : false */;

// ElementType<T>: extract the element type of an array, or never.
type ElementType<T> = /* T extends (infer U)[] ? U : never */;

// DefinitelyString<T>: T if T extends string, never otherwise.
type DefinitelyString<T> = /* T extends string ? T : never */;
