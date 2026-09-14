/**
 * 04-error-handling-and-exceptions/exercises/01-try-catch-basics.ts
 *
 * Wrap risky operations in try/catch; handle the caught value correctly.
 * Fill in the missing logic so that `npx tsc --noEmit` passes.
 */

function riskyDivide(a: number, b: number): number {
  if (b === 0) {
    throw new Error("division by zero");
  }
  return a / b;
}

// Return a Result-style object instead of throwing.
function safeDivide(
  a: number,
  b: number
): { success: true; value: number } | { success: false; error: string } {
  try {
    const value = riskyDivide(a, b);
    return { success: true, value };
  } catch (err) {
    // err is `unknown`. Narrow it before using.
    if (err instanceof Error) {
      return { success: false, error: err.message };
    }
    return { success: false, error: "unknown error" };
  }
}
