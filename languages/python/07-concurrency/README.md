# 07 — Concurrency

## Goals

Understand two approaches to concurrency in Python: threading and asyncio. Learn when to use each, how to coordinate work, and the implications of the Global Interpreter Lock (GIL).

## Concepts

- Threading: `threading.Thread`, `threading.Lock`, `threading.Event`, `join()`
- The GIL and its effect on CPU-bound vs. I/O-bound work
- asyncio: event loop, coroutines, `async`/`await`, `asyncio.gather`, `asyncio.create_task`
- `asyncio.to_thread` for mixing blocking I/O with async code
- Queues: `queue.Queue` (threading), `asyncio.Queue` (asyncio)
- When to use threads vs. asyncio vs. multiprocessing (brief)
- Pitfalls: race conditions, deadlocks, blocking the event loop

## Completion Checklist

- [ ] The threading exercise runs and demonstrates concurrent execution
- [ ] The asyncio exercise runs and demonstrates async/await
- [ ] Each exercise has a README section explaining what it demonstrates

## Exercises

### exercise_threading.py

Practice threading with a concrete problem.

Tasks:
1. Write a function `download_many(urls: list[str]) -> dict[str, int]` that "downloads" a list of URLs concurrently using threads. For each URL, simulate a download with `time.sleep(random.uniform(0.1, 0.5))` and return a dict mapping URL → status code (always 200 for this exercise).
2. Use a `threading.Thread` per URL (or `concurrent.futures.ThreadPoolExecutor` — both acceptable).
3. Use a `threading.Lock` to safely update a shared results dict.
4. Print the total elapsed time and assert it's less than the sum of all sleep times (demonstrating concurrency).

### exercise_asyncio.py

Practice asyncio with a concrete problem.

Tasks:
1. Write an async function `fetch_many(session, urls: list[str]) -> list[dict]` that fetches multiple URLs concurrently using `aiohttp` or `httpx` (or `asyncio.to_thread` with `requests` if you prefer not to add a dependency).
2. Write an async function `main()` that calls `fetch_many` with a list of 3-5 URLs (use httpbin.org or similar).
3. Use `asyncio.gather` to run fetches concurrently.
4. Print results and elapsed time.

## Notes

For the asyncio exercise, the learner may install `aiohttp` or `httpx` if they want a real async HTTP client. Alternatively, use `asyncio.to_thread` with `requests` to demonstrate bridging sync and async code without new dependencies.

## Running

```bash
python3 projects/07-concurrency/exercise_threading.py
python3 projects/07-concurrency/exercise_asyncio.py
```
