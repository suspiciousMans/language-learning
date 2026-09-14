# Project 00: Tooling Check

**Difficulty:** trivial
**Prerequisites:** nothing

## Goals

- Confirm your C toolchain (compiler, build tool, runtime) actually works.
- Get comfortable compiling, running, and checking the output of a minimal C program.
- Establish the habit of verifying your setup before diving in.

## Concepts

- C source files (`.c`)
- Compiling with `gcc` or `clang`
- A simple Makefile or an explicit compile command
- Running an executable and inspecting its output
- A rudimentary assertion: does the program print the expected string?

## Completion checklist

- [ ] You can compile `toolchain_check.c` with the provided Makefile or compile command.
- [ ] Running the resulting binary prints `toolchain ok` (or a clearly labeled equivalent).
- [ ] You can verify the output programmatically (a shell one-liner or a tiny script).
- [ ] You understand what the two stages (compile → run) do.

## Starter files

- `toolchain_check.c` — minimal program that prints a toolchain status message.
- `Makefile` — a tiny build target so you can type `make` instead of a long compiler invocation.
- `run_and_assert.sh` — a shell snippet that compiles, runs, and checks the output.

## Hints

- If your toolchain requires a different compiler name, adjust `CC` in the Makefile.
- If you get a linker error, make sure you're not missing required libraries (there are none here, so a linker error means the compiler installation is broken).
- The assertion step can be as simple as `./toolchain_check | grep -q "toolchain ok" && echo PASS || echo FAIL`.
