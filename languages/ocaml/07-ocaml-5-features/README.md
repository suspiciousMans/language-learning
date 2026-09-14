# 07 — OCaml 5 Features

**Difficulty:** advanced  
**Prerequisites:** 01, 02, 03

## Goals

- Understand effect handlers and structured concurrency.
- Work with the `effect` keyword and `perform` to raise computational effects.
- Use `match` with `effect` to handle effects.
- Build simple async/await patterns.
- Understand continuations and resumptions.
- Explore OCaml 5.0+ features.

## Concepts

- **Effects:** a way to express computational patterns without callbacks or monads.
- **Effect handlers:** catch and handle effects, transforming control flow.
- **Structured concurrency:** fork/join patterns for concurrent tasks.
- **Delimited continuations:** control flow that doesn't escape the handler.
- **Resumptions:** the `k` continuation passed to the handler.
- **Backtracking and search:** use effects to implement search strategies.

## Completion checklist

- [ ] You understand what an effect is and when to use one.
- [ ] You can define a custom effect type.
- [ ] You can raise an effect with `perform`.
- [ ] You can handle an effect with `match` and a handler.
- [ ] You can call a continuation `k` to resume after handling.
- [ ] You can write a simple async task that yields control.
- [ ] You can understand the difference between effects and exceptions.
- [ ] You can compose effect handlers.

## Starter files

| File | Topic |
|------|-------|
| [`simple_effect.ml`](simple_effect.ml) | defining and handling a simple effect |
| [`logging_effect.ml`](logging_effect.ml) | using effects for logging |
| [`async_simulation.ml`](async_simulation.ml) | simulating async with effects |
| [`search_with_effects.ml`](search_with_effects.ml) | backtracking search using effects |
| [`resource_management.ml`](resource_management.ml) | managing resources with effects |

### How to run

```sh
dune build
dune exec simple_effect
dune exec async_simulation
```

### Tests

```sh
dune runtest
```

## Hints

- Effects are available in OCaml 5.0+; check your version with `ocaml --version`.
- Think of effects as "asking the outside world for something."
- Handlers are the "outside world" that answers.
- Use effects instead of callbacks for cleaner control flow.
- Continuations let you pause and resume computations.
