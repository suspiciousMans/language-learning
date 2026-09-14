/**
 * 04-objects.solution.ts — reference solution for project 01, exercise 04.
 */

interface User {
  name: string;
  age: number;
  email?: string;
}

function formatUser(user: User): string {
  const parts = [user.name, `age ${user.age}`];
  if (user.email) {
    parts.push(user.email);
  }
  return parts.join(" — ");
}

const u: User = {
  name: "Ada",
  age: 36,
  email: "ada@example.com",
};

const anonymous: User = {
  name: "Anonymous",
  age: 0,
};
