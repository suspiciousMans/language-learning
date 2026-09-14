# 02 — Pattern Matching and Algebraic Data Types

**Difficulty:** beginner→intermediate  
**Prerequisites:** 01 (Basics)

## Goals

- Define and use variant (sum) types.
- Define and use record (product) types.
- Work with tuple types.
- Write exhaustive pattern matches.
- Use when clauses to refine patterns.
- Write nested patterns to destructure deep data.
- Model a small domain with ADTs and see how they make illegal states unrepresentable.

## Concepts

- **Variant types (sum types):** `type shape = Circle of float | Rectangle of float * float | Triangle of float * float * float`. A value is exactly one of the constructors.
- **Record types (product types):** `type person = { name: string; age: int; }`. A value bundles several fields together.
- **Tuple types:** `int * string * bool`. Anonymous products; access via `fst`, `snd`, or pattern matching.
- **Exhaustive pattern matching:** the compiler warns if a `match` doesn't cover all cases. Use `_` or a catch-all pattern deliberately.
- **When clauses:** `| pattern when guard -> body` refines a pattern with a boolean condition.
- **Nested patterns:** patterns compose — you can match inside variants, records, and tuples in one `match`.
- **ADTs to model a domain:** by choosing constructors carefully, you express the domain in the type system. Illegal states become unrepresentable.

## Completion checklist

- [ ] You can define a variant type with several constructors.
- [ ] You can construct a variant value and deconstruct it in a `match`.
- [ ] You can define a record type and create/update a record.
- [ ] You can write a tuple type and pattern-match on it.
- [ ] Your matches are exhaustive (no compiler warnings).
- [ ] You can use a `when` clause to add a guard.
- [ ] You can write nested patterns (e.g. matching inside a variant that contains a list).
- [ ] You can design a small ADT (e.g. a mini expression language, a shape hierarchy, or a message type) that models the domain.

## Starter files

| File | Topic |
|------|-------|
| [`variants.ml`](variants.ml) | variant types, constructors, pattern matching |
| [`records.ml`](records.ml) | record types, field access, record update |
| [`tuples.ml`](tuples.ml) | tuple types, pattern matching on tuples |
| [`exhaustive.ml`](exhaustive.ml) | exhaustive matching, when clauses, nested patterns |
| [`domain_model.ml`](domain_model.ml) | modeling a small domain with ADTs |

### How to run

```sh
dune build
dune exec variants
dune exec domain_model
```

### Tests

```sh
dune runtest
```

## Hints

- Prefer variants over string tags or integer enums — the compiler checks exhaustiveness for you.
- Records use `;` not `,` between fields.
- Record update syntax: `{ old_record with field = new_value }`.
- A `match` with a `when` clause: the guard is evaluated only if the pattern matches; if the guard fails, matching continues with the next case.
- Think of variant types as "a value is one of these shapes" and record types as "a value has all of these fields."
