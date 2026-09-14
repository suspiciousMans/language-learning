// ex7-advanced-async.js
// Advanced asynchronous patterns.

// Timeout promise
function timeout(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function fetchWithTimeout(url, timeoutMs) {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

  try {
    // Simulated fetch
    await timeout(100);
    clearTimeout(timeoutId);
    return 'Success';
  } catch (error) {
    clearTimeout(timeoutId);
    throw new Error('Timeout');
  }
}

// Parallel execution
async function fetchMultipleInParallel() {
  const p1 = timeout(100).then(() => 'Result 1');
  const p2 = timeout(50).then(() => 'Result 2');
  const p3 = timeout(150).then(() => 'Result 3');

  const results = await Promise.all([p1, p2, p3]);
  console.log('All completed:', results);
}

// Sequential execution
async function fetchSequential() {
  console.log('Start');
  await timeout(50);
  console.log('Step 1 done');
  await timeout(50);
  console.log('Step 2 done');
  await timeout(50);
  console.log('Step 3 done');
}

// Retry logic
async function fetchWithRetry(fn, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      return await fn();
    } catch (error) {
      console.log(`Attempt ${i + 1} failed:`, error.message);
      if (i === retries - 1) throw error;
      await timeout(100 * (i + 1));
    }
  }
}

// Run examples
(async () => {
  await fetchSequential();
  console.log('\n---');
  await fetchMultipleInParallel();
  console.log('\n---');
  const result = await fetchWithTimeout('url', 200);
  console.log('Timeout result:', result);
})();
