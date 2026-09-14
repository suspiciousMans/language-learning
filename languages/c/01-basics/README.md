# Project 01: Basics

**Difficulty:** beginner
**Prerequisites:** project 00 (tooling check)

## Goals

- Learn the fundamental C types and how to declare variables.
- Use `sizeof` to understand type sizes on your platform.
- Write control flow: `if`, `for`, `while`, `switch`.
- Define and call functions, including understanding pass-by-value.
- Read and write basic I/O: `printf`, `scanf`, and `fgets`.
- Work with arrays and understand strings as `char` arrays.

## Concepts

- Basic types: `int`, `float`, `char`, and their signed/unsigned variants
- `sizeof` and the difference between compile-time and runtime size
- Control flow: conditionals and loops
- Functions: declaration, definition, call, return value, parameters
- I/O: `printf` formatting, `scanf` format specifiers, `fgets` for safe line input
- Arrays: declaration, indexing, size, and the relationship to pointers (introduced formally in project 02)
- Strings: null-terminated `char` arrays, string literals, basic string operations by hand

## Completion checklist

- [ ] Write a program that declares variables of type `int`, `float`, `char` and prints their values and `sizeof` each.
- [ ] Write a program that uses `if`/`else` to categorize a number (e.g., negative, zero, positive).
- [ ] Write a `for` loop that sums the numbers 1..N and prints the result.
- [ ] Write a `while` loop that reads integers until a sentinel value (e.g., 0) and reports the count and sum.
- [ ] Write a `switch` statement that maps an integer 1..7 to a weekday name.
- [ ] Write a function that takes two `int`s and returns their maximum; call it from `main`.
- [ ] Write a program that uses `printf` with multiple format specifiers and `fgets` to read a line from the user.
- [ ] Write a program that declares a character array, initializes it as a string, and prints it character by character.
- [ ] Write a program that copies one `char` array into another (a manual `strcpy` equivalent) and null-terminates correctly.

## Exercises

Each exercise lives in its own `.c` file under this folder. Starter code is provided where helpful; many exercises ask you to write the program from scratch.

### Exercise A: Types and sizeof

File: `ex_types_sizeof.c` (starter provided)

Declare an `int`, a `float`, a `char`, and a `double`. Print each value and its `sizeof`. Observe that the sizes depend on your platform/compile target.

### Exercise B: Control flow — if

File: `ex_if_categorize.c`

Write a program that reads an `int` from the user (via `scanf` or `fgets`+`sscanf`) and prints "negative", "zero", or "positive".

### Exercise C: Control flow — for loop sum

File: `ex_for_sum.c`

Sum the integers from 1 to N (read N from the user or hardcode it for testing). Print the result.

### Exercise D: Control flow — while with sentinel

File: `ex_while_sentinel.c`

Read integers in a loop until the user enters 0. Print the count of numbers read (excluding the sentinel) and their sum.

### Exercise E: Control flow — switch weekdays

File: `ex_switch_weekdays.c`

Given an integer 1..7, print the corresponding weekday name ("Monday".."Sunday"). Handle out-of-range input gracefully.

### Exercise F: Functions — max of two ints

File: `ex_func_max.c`

Define `int max_of(int a, int b)` and call it from `main` with a few test values.

### Exercise G: Basic I/O — printf and fgets

File: `ex_io_printf_fgets.c`

Demonstrate formatted output with `printf` (%d, %f, %s, %c) and read a full line of input with `fgets`. Print the line back.

### Exercise H: Arrays — declaration and indexing

File: `ex_arrays_indexing.c`

Declare an array of 10 ints, fill it with values 0..9, and print each element by index. Also compute the sum using a loop.

### Exercise I: Strings as char arrays

File: `ex_strings_char_arrays.c`

Declare a `char` array initialized with a string literal. Print it using `%s` and character-by-character using a loop that stops at the null terminator. Observe the null byte.

### Exercise J: Manual string copy

File: `ex_strcpy_manual.c`

Write a function `void my_strcpy(char *dst, const char *src)` that copies `src` into `dst` (including the null terminator). Demonstrate it in `main` with a destination buffer large enough to hold the source.

## Starter files

- `ex_types_sizeof.c` — partially filled; you add the prints.
- `ex_strcpy_manual.c` — provides a skeleton with `main`; you write `my_strcpy`.

## Hints

- `scanf` leaves newlines in the input buffer; mixing `scanf` and `fgets` requires care. Prefer `fgets` + `sscanf` when you need to read lines.
- Always null-terminate strings you build manually.
- `sizeof` a `char` is guaranteed to be 1 by the C standard; `sizeof` an `int` is typically 4 on modern platforms but is not guaranteed.
