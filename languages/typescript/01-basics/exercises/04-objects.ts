/**
 * 04-objects.ts — exercise for project 01.
 *
 * Type simple object literals and function parameters that are objects.
 * Fill in the missing annotations so that tsc --noEmit passes with zero
 * errors.
 */

// Define the User interface and annotate the function and objects below.
interface User {
  // TODO: fill in the interface shape.
}

function formatUser(user) {
  const parts = [user.name, `age ${user.age}`];
  if (user.email) {
    parts.push(user.email);
  }
  return parts.join(" — ");
}

// Annotate these object literals with the User type.
const u = {
  name: "Ada",
  age: 36,
  email: "ada@example.com",
};

const anonymous = {
  name: "Anonymous",
  age: 0,
};

// Hint: User has name: string, age: number, and email?: string (optional).
