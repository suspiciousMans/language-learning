/**
 * 04-error-handling-and-exceptions/exercises/02-typed-catch.ts
 *
 * Narrow the caught `unknown` with instanceof.
 * Fill in the missing logic so that `npx tsc --noEmit` passes.
 */

function parseNumber(s: string): number {
  const n = Number(s);
  if (isNaN(n)) {
    throw new Error(`cannot parse "${s}" as a number`);
  }
  return n;
}

// Safely parse a string; return null on failure, logging the error.
function safeParse(s: string): number | null {
  try {
    return parseNumber(s);
  } catch (err) {
    // err is `unknown` in strict TS. Narrow it.
    if (err instanceof Error) {
      console.error("parse failed:", err.message);
    } else {
      console.error("parse failed with non-Error:", err);
    }
    return null;
  }
}
