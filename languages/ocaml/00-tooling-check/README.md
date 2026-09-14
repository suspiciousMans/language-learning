# 00 — Tooling Check

**Difficulty:** trivial  
**Prerequisites:** none

## Goals

- Verify that OCaml, dune, and opam are installed and working.
- Build and run a minimal Dune project.
- Run a test that asserts the output of the program.

## Concepts

- **ocamlfind**: OCaml's package discovery tool; used to locate installed libraries.
- **dune**: the standard OCaml build system. You will use it to build executables and run tests.
- **opam**: OCaml's package manager; used to install compiler versions and libraries.

## Completion checklist

- [ ] `ocamlfind` is available and can list installed packages.
- [ ] `dune` is available and can build the project in this folder.
- [ ] `opam` is available and reports a switch with OCaml 4.14+.
- [ ] Running the built executable prints exactly `toolchain ok`.
- [ ] Running `dune runtest` passes (the test asserts the output).

## Starter files

- [`dune-project`](dune-project) — declares the project language and minimum OCaml version.
- [`dune`](dune) — Dune stanza for the executable.
- [`toolchain_check.ml`](toolchain_check.ml) — the program that prints `toolchain ok`.

## How to run

```sh
dune build
dune exec toolchain_check
# expected output: toolchain ok

dune runtest
# expected: test passes
```

## Test

The test executable ([`test/test_toolchain.ml`](test/test_toolchain.ml)) runs the toolchain_check program and asserts its stdout is exactly `"toolchain ok\n"`.

## Hints

- If `ocamlfind` is not found, run `opam install ocamlfind`.
- If `dune` is not found, run `opam install dune`.
- If your OCaml version is below 4.14, create a new switch: `opam switch create 4.14.0`.
