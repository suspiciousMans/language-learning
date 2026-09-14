/**
 * 02-types/exercises/01-primitives-and-literals.ts
 *
 * Annotate each variable with the correct primitive or literal type
 * so that `npx tsc --noEmit` passes with zero errors.
 */

// Primitives — fill in the type annotations below.
const str: /* your type */ = "hello, TypeScript";
const num: /* your type */ = 42;
const bool: /* your type */ = true;
const nil: /* your type */ = null;
const undef: /* your type */ = undefined;
const bigintVal: /* your type */ = 100n;
const symVal: /* your type */ = Symbol("x");

// Literal types — narrow these constants to specific values.
type Status = "pending" | "approved" | "rejected";
const s: /* Status */ = "pending";
const port: /* 3000 | 8080 */ = 3000;
const answer: /* 42 */ = 42;
