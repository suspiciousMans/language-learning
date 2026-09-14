# Project 04: Functions and Modularity

**Difficulty:** intermediate
**Prerequisites:** project 01 (basics), project 02 (pointers and memory), project 03 (arrays, strings, structs)

## Goals

- Understand function pointers: declaring, assigning, calling through them.
- Split a program into header (`.h`) and source (`.c`) files.
- Understand separate compilation: compile each `.c` to an object file, then link.
- Understand `static` (internal linkage) vs `extern` (external linkage).
- Write a multi-file Makefile that compiles and links several translation units.

## Concepts

- Function pointers: `int (*fp)(int, int)`, calling `fp(3, 4)`, arrays of function pointers
- Header files: declarations, include guards (`#ifndef HEADER_H ... #endif`)
- Source files: definitions, including the corresponding header
- Separate compilation: `gcc -c a.c`, `gcc -c b.c`, `gcc a.o b.o -o prog`
- Linkage: `static` (visible only in this translation unit), `extern` (declares a name defined elsewhere)
- Makefiles for multi-file projects: listing object files, linking step, header dependencies

## Completion checklist

- [ ] Write a small program that uses a function pointer to call a function chosen at runtime.
- [ ] Write a header file `utils.h` with include guards and function declarations, and a source file `utils.c` with definitions.
- [ ] Write a `main.c` that includes `utils.h` and uses the functions.
- [ ] Compile with separate compilation: `gcc -c utils.c`, `gcc -c main.c`, `gcc utils.o main.o -o prog`.
- [ ] Add a `static` function in one translation unit and demonstrate that it is not visible from another.
- [ ] Add an `extern` declaration in a header for a variable defined in a source file and use it.
- [ ] Write a Makefile that builds the multi-file project with a `make` invocation and a `make clean` target.

## Exercises

### Exercise 1: Function pointers

File: `ex_function_pointers.c`

Define two functions: `int add(int a, int b)` and `int mul(int a, int b)`. Declare a function pointer `int (*op)(int, int)`. Assign `add` and `mul` to it at different times and call through the pointer. Also demonstrate an array of function pointers and iterate over it.

### Exercise 2: Header and source split — utils

Files: `utils.h`, `utils.c`, `main_utils.c`

Create a small utility module:
- `utils.h`: include guard, declarations for `int max_of(int, int)`, `int min_of(int, int)`, `void swap_ints(int *, int *)`.
- `utils.c`: definitions of those functions.
- `main_utils.c`: includes `utils.h`, exercises each function.

### Exercise 3: Separate compilation

Same files as exercise 2, but the task is to compile them separately:

```
gcc -std=c11 -Wall -Wextra -c utils.c -o utils.o
gcc -std=c11 -Wall -Wextra -c main_utils.c -o main_utils.o
gcc utils.o main_utils.o -o main_utils
```

Observe that modifying only `utils.c` requires recompiling only `utils.c` (in a real project, a Makefile handles this).

### Exercise 4: static vs extern

Files: `internal.c`, `internal.h`, `use_internal.c`

- `internal.c`: define a `static` helper function `static int helper(int x)` and an `extern` variable `int counter` (defined in the `.c` file).
- `internal.h`: declare `extern int counter;` (but NOT the static function — it is not visible outside).
- `use_internal.c`: include `internal.h`, use `counter`, and observe that the static helper cannot be called from here.

### Exercise 5: Multi-file Makefile

File: `Makefile`

Write a Makefile for a small multi-file project (e.g., the utils module from exercise 2, plus an optional extra source). It should:

- Define `CC`, `CFLAGS`.
- Build each `.c` into a `.o`.
- Link all `.o` files into a target binary.
- Provide `make clean` to remove `.o` and the binary.
- Optionally, track header dependencies so changing a header triggers recompilation of dependents.

## Hints

- A function pointer type `int (*)(int, int)` is usually aliased with a typedef for readability: `typedef int (*binop_t)(int, int);`.
- Include guards prevent double-inclusion: `#ifndef UTILS_H`, `#define UTILS_H`, ... , `#endif`.
- A header should declare, not define (with rare exceptions). A definition belongs in a `.c` file.
- `static` at file scope (on a function or global variable) gives it internal linkage — visible only in that translation unit. `static` on a local variable gives it persistent storage across calls (but that is a different topic).
- `extern` at file scope declares that the name is defined in another translation unit. The definition (the actual storage) must appear exactly once across all translation units.
- When tracking header dependencies in a Makefile, a simple approach is to list the headers each `.o` depends on, or use `gcc -MM` to generate dependency rules automatically.
