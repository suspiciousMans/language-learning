/**
 * 03-generics-and-utilities/exercises/02-generic-interfaces.ts
 *
 * Model generic interfaces: Box<T>, Pair<A, B>, and Repository<T, Id>.
 * Fill in the type parameters and members so that `npx tsc --noEmit` passes.
 */

// A box that holds a single value of type T.
interface Box<T> {
  // TODO: a `value` property of type T
}

// A pair holding two values of (possibly different) types.
interface Pair<A, B> {
  // TODO: first: A, second: B
}

// A generic repository: find by id, save, delete.
interface Repository<T, Id> {
  // TODO: findById(id: Id): Promise<T | null>
  //       save(entity: T): Promise<void>
  //       delete(id: Id): Promise<void>
}
