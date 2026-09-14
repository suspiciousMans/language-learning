/**
 * 04-error-handling-and-exceptions/exercises/05-result-style-errors.ts
 *
 * Model a function that returns a Result type instead of throwing.
 * Fill in the missing branches so that `npx tsc --noEmit` passes.
 */

type Result<T, E = string> =
  | { success: true; value: T }
  | { success: false; error: E };

function parsePositive(s: string): Result<number, string> {
  const n = Number(s);
  if (isNaN(n)) {
    return { success: false, error: `not a number: "${s}"` };
  }
  if (n <= 0) {
    return { success: false, error: `not positive: ${n}` };
  }
  return { success: true, value: n };
}

function useResult(): void {
  const r = parsePositive("42");
  if (r.success) {
    console.log("parsed:", r.value);
  } else {
    console.error("parse failed:", r.error);
  }
}
