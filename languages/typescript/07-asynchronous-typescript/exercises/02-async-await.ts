/**
 * 02-async-await.ts — project 07 exercise.
 *
 * Convert promise-based code to async/await; type async function returns.
 *
 * Run: npx tsx exercises/02-async-await.ts
 */

// An async function always returns a Promise. Even if you don't
// explicitly return a promise, TS infers the return type.
async function fetchUser(id: number): Promise<{ id: number; name: string }> {
  // Simulate a network call.
  return new Promise((resolve) => {
    setTimeout(() => resolve({ id, name: `user-${id}` }), 10);
  });
}

// Parallel execution with Promise.all.
async function fetchTwoUsers(idA: number, idB: number) {
  const results = await Promise.all([fetchUser(idA), fetchUser(idB)]);
  return results; // inferred as Array<{ id: number; name: string }>
}

// Sequential vs parallel: sequential awaits one at a time.
async function fetchSequential(ids: number[]) {
  const users: { id: number; name: string }[] = [];
  for (const id of ids) {
    users.push(await fetchUser(id));
  }
  return users;
}

// async function with explicit return type annotation.
async function greet(name: string): Promise<string> {
  return `hello, ${name}`;
}

async function main() {
  const user = await fetchUser(1);
  console.log("user:", user);

  const [a, b] = await fetchTwoUsers(1, 2);
  console.log("parallel:", a, b);

  const seq = await fetchSequential([3, 4, 5]);
  console.log("sequential:", seq);

  const msg = await greet("world");
  console.log(msg);
}

main().catch(console.error);
