/**
 * 05-parallel-and-error.ts — project 07 exercise.
 *
 * Promise.all vs Promise.allSettled; handling partial failures.
 *
 * Run: npx tsx exercises/05-parallel-and-error.ts
 */

// A fake async operation that succeeds or fails.
async function fakeOp(id: number, shouldFail: boolean): Promise<string> {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (shouldFail) {
        reject(new Error(`op ${id} failed`));
      } else {
        resolve(`result-${id}`);
      }
    }, 10);
  });
}

// Promise.all: fails fast — if any promise rejects, the whole thing rejects.
async function withAll(ids: number[]) {
  const results = await Promise.all(
    ids.map((id) => fakeOp(id, id === 3))
  );
  return results;
}

// Promise.allSettled: waits for all, returns a settled status for each.
async function withAllSettled(ids: number[]) {
  const settled = await Promise.allSettled(
    ids.map((id) => fakeOp(id, id === 3))
  );
  return settled;
}

// Typed helper: extract successful values from allSettled results.
function extractSuccesses<T>(settled: PromiseSettledResult<T>[]): T[] {
  return settled
    .filter((r): r is PromiseFulfilledResult<T> => r.status === "fulfilled")
    .map((r) => r.value);
}

async function main() {
  const ids = [1, 2, 3, 4, 5];

  console.log("=== Promise.all (fails fast) ===");
  try {
    const results = await withAll(ids);
    console.log("all succeeded:", results);
  } catch (err) {
    if (err instanceof Error) {
      console.log("Promise.all rejected as soon as one failed:", err.message);
    } else {
      console.error("unknown error:", err);
    }
  }

  console.log("\n=== Promise.allSettled (waits for all) ===");
  const settled = await withAllSettled(ids);
  const successes = extractSuccesses(settled);
  const failures = settled.filter((r) => r.status === "rejected");

  console.log("fulfilled count:", successes.length);
  console.log("rejected count:", failures.length);
  console.log("successful results:", successes);
  for (const f of failures) {
    if (f.status === "rejected" && f.reason instanceof Error) {
      console.log("failure reason:", f.reason.message);
    }
  }

  console.log("\n=== Typed inference check ===");
  // Prove the types: settled is an array of PromiseSettledResult.
  const _typeCheck: PromiseSettledResult<string>[] = settled;
  console.log("Type check passed — settled is PromiseSettledResult<string>[]");
}

main();
