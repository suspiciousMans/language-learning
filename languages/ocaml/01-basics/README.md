# 01 — Basics

**Difficulty:** beginner  
**Prerequisites:** 00 (Tooling check)

## Goals

- Learn OCaml's basic types and how to bind values.
- Write simple functions, including recursive ones.
- Use pattern matching for destructuring.
- Work with lists and understand cons.
- Distinguish basic recursion from tail recursion.

## Concepts

- **let bindings**: `let name = expr` (module-level) and `let name = expr in body` (local).
- **Types**: `int`, `float`, `string`, `bool`, `unit` (written `()`).
- **Functions**: `let f x y = ...`. Functions are first-class and can be nested.
- **Pattern matching basics**: `match expr with | pattern -> body`.
- **if-then-else**: `if cond then expr1 else expr2` — always returns a value.
- **Lists and cons**: `[1; 2; 3]` is syntactic sugar for `1 :: 2 :: 3 :: []`.
- **Recursion vs tail recursion**: a tail call is the last thing a function does; tail-recursive functions can be optimized to use constant stack space.

## Completion checklist

- [ ] You can declare `let` bindings for each basic type.
- [ ] You can write a function that takes arguments and returns a value.
- [ ] You can use `match` to branch on a value's shape.
- [ ] You can write an `if-then-else` expression.
- [ ] You can construct and destructure lists with `::` and `[]`.
- [ ] You can write a recursively defined function (e.g. factorial).
- [ ] You can rewrite that function in tail-recursive form (e.g. with an accumulator).

## Starter files

### Exercises

| File | Topic |
|------|-------|
| [`let_bindings.ml`](let_bindings.ml) | let bindings, basic types |
| [`functions.ml`](functions.ml) | function definitions, recursion |
| [`pattern_matching.ml`](pattern_matching.ml) | match/when, basic patterns |
| [`if_then_else.ml`](if_then_else.ml) | conditional expressions |
| [`lists.ml`](lists.ml) | cons, list destructuring |
| [`recursion.ml`](recursion.ml) | basic vs tail recursion |

### How to run

```sh
dune build
dune exec let_bindings   # or any other executable
```

### Tests

Each exercise file may have a corresponding test in [`tests/`](tests/). Run all with:

```sh
dune runtest
```

## Hints

- OCaml is strongly typed. If the compiler complains about a type, read the error — it usually tells you exactly what's wrong.
- `unit` is a type with one value `()`. Functions that do side effects (like `print_endline`) take `unit` and return `unit`.
- A `match` must be exhaustive. The compiler warns you if a case is missing.
- To make a function tail-recursive, introduce an accumulator argument (often a nested helper).
