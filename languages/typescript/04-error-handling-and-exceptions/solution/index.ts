/**
 * 04-error-handling-and-exceptions — solution: all five exercises, working.
 */

// ── 01-try-catch-basics.ts ────────────────────────────────────────

function riskyDivide(a: number, b: number): number {
  if (b === 0) {
    throw new Error("division by zero");
  }
  return a / b;
}

function safeDivide(a: number, b: number): { success: true; value: number } | { success: false; error: string } {
  try {
    const value = riskyDivide(a, b);
    return { success: true, value };
  } catch (err) {
    if (err instanceof Error) {
      return { success: false, error: err.message };
    }
    return { success: false, error: "unknown error" };
  }
}

// ── 02-typed-catch.ts ─────────────────────────────────────────────

function parseNumber(s: string): number {
  const n = Number(s);
  if (isNaN(n)) {
    throw new Error(`cannot parse "${s}" as a number`);
  }
  return n;
}

function safeParse(s: string): number | null {
  try {
    return parseNumber(s);
  } catch (err) {
    // In strict TS, `err` is `unknown`. Narrow with instanceof.
    if (err instanceof Error) {
      console.error("parse failed:", err.message);
    } else {
      console.error("parse failed with non-Error:", err);
    }
    return null;
  }
}

// ── 03-custom-errors.ts ───────────────────────────────────────────

class AppError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "AppError";
    // Restore prototype chain (needed for instanceof in some runtimes).
    Object.setPrototypeOf(this, AppError.prototype);
  }
}

class ValidationError extends AppError {
  constructor(message: string) {
    super(message);
    this.name = "ValidationError";
    Object.setPrototypeOf(this, ValidationError.prototype);
  }
}

class NotFoundError extends AppError {
  constructor(resource: string) {
    super(`${resource} not found`);
    this.name = "NotFoundError";
    Object.setPrototypeOf(this, NotFoundError.prototype);
  }
}

function validateUser(name: string | null): string {
  if (name === null || name.trim() === "") {
    throw new ValidationError("name must be a non-empty string");
  }
  return name.trim();
}

function getUser(id: number): string {
  if (id <= 0) {
    throw new NotFoundError("user");
  }
  return `user-${id}`;
}

// ── 04-never-and-exhaustive.ts ────────────────────────────────────

type Shape2 = Circle | Square | Rectangle;

function area2(s: Shape2): number {
  switch (s.kind) {
    case "circle":
      return Math.PI * s.radius * s.radius;
    case "square":
      return s.side * s.side;
    case "rectangle":
      return s.width * s.height;
    default: {
      // Exhaustive check: if a new Shape variant is added but not
      // handled here, this line becomes a type error.
      const _exhaustiveCheck: never = s;
      throw new Error(`unhandled shape kind: ${_exhaustiveCheck}`);
    }
  }
}

// ── 05-result-style-errors.ts ─────────────────────────────────────

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
