/**
 * 04-error-handling-and-exceptions/exercises/03-custom-errors.ts
 *
 * Build a custom error hierarchy. Fill in the constructors so that
 * `npx tsc --noEmit` passes with zero errors.
 */

class AppError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "AppError";
    // Restore the prototype chain so instanceof works correctly.
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
