# 04 — Modules and Signatures

**Difficulty:** intermediate  
**Prerequisites:** 01, 02, 03

## Goals

- Define module signatures (interfaces).
- Hide implementation details with signatures.
- Use functors to create parameterized modules.
- Work with module aliases and module types.
- Build composable, reusable modules.
- Understand the module system as a tool for abstraction and organization.

## Concepts

- **Module signature (`.mli`):** declares what a module exports; hides the implementation.
- **Abstract types:** `type t` with no definition; users can't access the internals.
- **Functors:** functions that take modules as arguments and return modules.
- **Module types:** constraints on modules (like interfaces in other languages).
- **Sealed modules:** apply a signature to a module to hide internal details.
- **Module composition:** build larger systems by combining smaller modules.

## Completion checklist

- [ ] You can write a `.mli` signature file.
- [ ] You can hide internal types and functions from the signature.
- [ ] You can define an abstract type (`type t`) in a signature.
- [ ] You can write a simple functor that takes one module parameter.
- [ ] You can instantiate a functor with a concrete module.
- [ ] You can understand why functors are useful for parameterization.
- [ ] You can use module aliases to simplify code.
- [ ] You can compose multiple modules to solve a problem.

## Starter files

| File | Topic |
|------|-------|
| [`queue_interface.mli`](queue_interface.mli) | defining an interface for a queue |
| [`queue_impl.ml`](queue_impl.ml) | implementation hidden behind the interface |
| [`stack_sig.mli`](stack_sig.mli) | signature for a generic stack |
| [`stack.ml`](stack.ml) | concrete stack implementation |
| [`container_functor.ml`](container_functor.ml) | functor taking a collection module |
| [`set_functor.ml`](set_functor.ml) | building a Set from a comparable module |

### How to run

```sh
dune build
dune exec queue_impl
dune exec stack
```

### Tests

```sh
dune runtest
```

## Hints

- Signatures hide implementation; they're your contract with the user of the module.
- Use abstract types (`type t`) to prevent outside code from pattern-matching on your data.
- Functors let you write generic code once and instantiate it for different types.
- A functor is most useful when multiple modules satisfy the same signature.
- Think: what does the outside world need to know about this module? Everything else goes in the `.ml` only.
