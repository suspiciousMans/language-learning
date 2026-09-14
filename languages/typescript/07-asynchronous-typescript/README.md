# 07 — Asynchronous TypeScript

**Difficulty:** intermediate→advanced  
**Concepts:** promises, async/await, fetch with typed responses, async error handling  
**Prerequisites:** 02 (types), 06 (ecosystem)

## Goals

Get comfortable with TypeScript and asynchronous code. Learn to type promises, use async/await idiomatically, annotate the shape of data you expect from `fetch`, and handle errors in async flows without losing type information.

## Concepts

- **Promises** — `Promise<T>`. A promise that resolves to `T`.
- **`async/await`** — syntactic sugar over promises; an `async` function always returns a `Promise`.
- **Fetch and typed responses** — `fetch(url)` returns `Promise<Response>`. You read the body with `.json()` → `Promise<T>` where `T` is the shape you expect.
- **Typing the API response** — define an interface for the JSON you expect, cast/parse into it. Trust but verify (runtime validation is a separate concern).
- **Async error handling** — `try/catch` around `await`, `.catch()` on a promise chain.
- **Parallel vs. sequential** — `Promise.all`, `Promise.allSettled`, sequential `await`s.
- **`unknown` in async catch** — the same catch-typing rules apply; network errors are often not `Error` instances.

## Exercises

| File | Task |
|------|------|
| `exercises/01-promises-basics.ts` | Create and consume promises; annotate `Promise<T>`. |
| `exercises/02-async-await.ts` | Convert promise chains to async/await; type async function returns. |
| `exercises/03-fetch-typed-response.ts` | Use `fetch` against a typed endpoint; define the response type. |
| `exercises/04-jsonplaceholder.ts` | Fetch from jsonplaceholder, assert the typed response, handle errors. |
| `exercises/05-parallel-and-error.ts` | Use `Promise.all` and `Promise.allSettled`; handle partial failures. |

## jsonplaceholder exercise

The file `exercises/04-jsonplaceholder.ts` fetches the first todo from
`https://jsonplaceholder.typicode.com/todos/1` and asserts the response
matches a typed interface:

```ts
interface JsonPlaceholderTodo {
  userId: number;
  id: number;
  title: string;
  completed: boolean;
}
```

The learner writes the fetch call, parses the JSON as `JsonPlaceholderTodo`,
logs the result, and handles errors. The exercise expects a network request,
so it only runs when online.

## Completion checklist

- [ ] All exercises compile with `npx tsc --noEmit exercises/*.ts` with zero errors.
- [ ] You can explain the type of an `async` function's return value.
- [ ] You can write a typed fetch: define the response interface, parse as that type, and handle errors.
- [ ] You can explain the difference between `Promise.all` and `Promise.allSettled`.
- [ ] You can handle a network error without assuming the caught value is an `Error`.

## Running the exercises

```bash
cd projects/07-asynchronous-typescript

npx tsc --noEmit exercises/*.ts

# Run the working exercises (those that don't require network):
npx tsx exercises/01-promises-basics.ts
npx tsx exercises/02-async-await.ts
npx tsx exercises/05-parallel-and-error.ts

# Run the fetch exercise when online:
npx tsx exercises/03-fetch-typed-response.ts
npx tsx exercises/04-jsonplaceholder.ts
```

## Files in this project

```
07-asynchronous-typescript/
├── README.md
└── exercises/
    ├── 01-promises-basics.ts
    ├── 02-async-await.ts
    ├── 03-fetch-typed-response.ts
    ├── 04-jsonplaceholder.ts
    └── 05-parallel-and-error.ts
```
