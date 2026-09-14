# Project 01 — Basics

**Difficulty:** beginner  
**Prerequisites:** 00 (tooling check)

## Goals

- Learn the basic syntax of Go: variables, types, control flow, functions, pointers.
- Understand Go's stance on `while` (there is none — use `for`), named return values, and multiple return values.
- Write small exercises that compile and pass their tests.

## Concepts

- **Variables:** `var x int`, short declaration `x := 5`, `const`.
- **Basic types:** `int`, `int8`/`int16`/`int32`/`int64`, `float32`/`float64`, `string`, `bool`, `error` (as a type, not yet its contents).
- **Control flow:**
  - `if cond { ... } else if ... else ...`
  - `for init; cond; post { ... }` — the only loop in Go; acts as `while` when you omit init and post.
  - `switch expr { case x: ... default: ... }` — implicit break, no fallthrough unless `fallthrough`.
- **Functions:** multiple return values `func div(a, b int) (int, error)`, named returns `func div(a, b int) (res int, err error)`.
- **Pointers:** `&x`, `*p`, passing by value vs by pointer, `new(T)`.
- **Zero values:** each type has a zero value (`0`, `""`, `false`, `nil`).

## Completion Checklist

- [ ] All `.go` files in this folder compile with `go build ./...`.
- [ ] All tests pass with `go test ./...`.
- [ ] You can explain why Go has no `while` loop.
- [ ] You can write a function that returns `(int, error)` and call it with `res, err := f()`.
- [ ] You understand when to pass a pointer vs a value.

## Exercises

### ex01_variables.go + ex01_variables_test.go

Declare a `const`, a `var`, and a short-declared variable. Write functions
that return their values and tests that assert them.

### ex02_types.go + ex02_types_test.go

Play with `int`, `float64`, `string`, `bool`. Convert between types explicitly
(Go is strict — no implicit numeric conversions).

### ex03_control_flow.go + ex03_control_flow_test.go

Implement `absoluteValue`, `fibonacci`, and `isPrime` using `if`/`for`/`switch`.

### ex04_functions.go + ex04_functions_test.go

Write a function with multiple return values and named returns. Write a
function that takes a pointer argument and mutates it.

### ex05_pointers.go + ex05_pointers_test.go

Demonstrate `&`, `*`, `new`, and the difference between value and pointer
receivers on a small struct.

## Hints

- `go vet ./...` as well — it catches common mistakes.
- `gofmt` or `goimports` should be run on every file before committing.
- The `error` type is just an interface; we'll dissect it in project 03.
