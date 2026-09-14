# 03 — Functional Core

**Difficulty:** intermediate  
**Prerequisites:** 01 (Basics), 02 (Pattern Matching and ADTs)

## Goals

- Master higher-order functions and function composition.
- Use `List.map`, `List.filter`, `List.fold_left`, and `List.fold_right`.
- Write pipelines with function composition.
- Understand partial application and currying.
- Work with the `|>` operator for readable data flow.
- Build composable, reusable function libraries.

## Concepts

- **Higher-order functions:** functions that take or return other functions.
- **`List.map`:** apply a function to each element of a list.
- **`List.filter`:** keep elements that satisfy a predicate.
- **`List.fold_left`:** accumulate a result by iterating left to right.
- **`List.fold_right`:** accumulate a result by iterating right to left.
- **Partial application:** bind some arguments to a function, returning a new function.
- **Currying:** breaking a function into a chain of single-argument functions.
- **Pipe operator (`|>`):** pass the left side as the last argument of the right side.
- **Function composition:** `(f >> g) x = g (f x)`.

## Completion checklist

- [ ] You can write a function that takes another function as an argument.
- [ ] You can use `List.map` to transform a list.
- [ ] You can use `List.filter` to select elements.
- [ ] You can use `List.fold_left` and `List.fold_right` correctly.
- [ ] You understand the difference between fold_left and fold_right.
- [ ] You can chain operations with the `|>` operator.
- [ ] You can partially apply a function and use the result.
- [ ] You can compose multiple functions into a pipeline.
- [ ] You can write a function that returns a function.

## Starter files

| File | Topic |
|------|-------|
| [`higher_order.ml`](higher_order.ml) | functions as arguments, higher-order patterns |
| [`list_ops.ml`](list_ops.ml) | map, filter, fold, list transformations |
| [`composition.ml`](composition.ml) | function composition, the pipe operator |
| [`partial_application.ml`](partial_application.ml) | currying, partial application, custom operators |
| [`data_pipeline.ml`](data_pipeline.ml) | building composable data processing pipelines |

### How to run

```sh
dune build
dune exec higher_order
dune exec data_pipeline
```

### Tests

```sh
dune runtest
```

## Hints

- `List.map f lst` is equivalent to writing a recursive function that applies `f` to each element.
- `fold_left` processes from left to right: `fold_left f acc [a;b;c]` = `f (f (f acc a) b) c`.
- `fold_right` processes from right to left: `fold_right f [a;b;c] acc` = `f a (f b (f c acc))`.
- The pipe operator `|>` makes code more readable: `value |> f |> g` instead of `g (f value)`.
- Partial application naturally emerges with curried functions: `let add_five = add 5` creates a function that adds 5 to its argument.
- Think about what function composition enables: once you have small, focused functions, you can combine them to solve larger problems.
