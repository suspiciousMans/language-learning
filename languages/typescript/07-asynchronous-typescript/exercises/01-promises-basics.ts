/**
 * 01-promises-basics.ts — project 07 exercise.
 *
 * Learn to create and consume promises with explicit type arguments.
 *
 * Run: npx tsx exercises/01-promises-basics.ts
 */

// Promise that resolves to a string after a delay.
function resolveString(delayMs: number, value: string): Promise<string> {
  return new Promise((resolve) => {
    setTimeout(() => resolve(value), delayMs);
  });
}

// Promise that rejects with a string error.
function rejectError(delayMs: number, message: string): Promise<never> {
  return new Promise((_, reject) => {
    setTimeout(() => reject(new Error(message)), delayMs);
  });
}

// Promise that resolves to a number.
function resolveNumber(delayMs: number, value: number): Promise<number> {
  return new Promise((resolve) => {
    setTimeout(() => resolve(value), delayMs);
  });
}

async function demo() {
  // Await a Promise<string>
  const greeting = await resolveString(10, "hello");
  console.log(greeting.toUpperCase());

  // Await a Promise<number> and use the typed result
  const n = await resolveNumber(10, 42);
  console.log(n + 8);

  // Chain with .then/.catch, annotating the promise explicitly
  const p: Promise<number> = resolveNumber(10, 7);
  p.then((value) => {
    console.log(value * 2);
  });
}

demo().catch((err) => {
  console.error("demo failed:", err);
});
