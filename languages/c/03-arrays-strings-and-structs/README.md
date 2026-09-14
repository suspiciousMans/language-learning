# Project 03: Arrays, Strings, and Structs

**Difficulty:** intermediate
**Prerequisites:** project 01 (basics), project 02 (pointers and memory)

## Goals

- Use arrays and indexing fluently.
- Use `string.h` functions (`strlen`, `strcpy`, `strcat`, `strcmp`, `memset`, `memcpy`, `memmove`).
- Define and use `struct` types.
- Use `typedef` to create aliases for types and structs.
- Understand unions and when they are useful.
- Use `enum` for named integer constants.
- Work with arrays of structs.

## Concepts

- Arrays: declaration, initialization, indexing, bounds
- Strings: `string.h` API, null termination, buffer sizes
- Structs: aggregating different types into one composite type
- `typedef`: naming types, especially struct types
- Unions: overlapping storage, size = size of largest member
- Enums: named integer constants, underlying type is `int`
- Arrays of structs: a common data structure pattern

## Completion checklist

- [ ] Write a program that declares a 1D array and a 2D array and accesses elements.
- [ ] Write a program that uses `strlen`, `strcpy`, `strcat`, `strcmp`, `memset`, `memcpy`, and `memmove` correctly, with attention to buffer sizes.
- [ ] Define a `struct Point { int x; int y; }`, create instances, and print them.
- [ ] Use `typedef` to define `typedef struct Point Point;` and use it.
- [ ] Define a `union` with two different types and observe that writing one member overwrites the other.
- [ ] Define an `enum` for weekdays and use it in a `switch`.
- [ ] Create an array of structs (e.g., an array of `Point`s), initialize it, and iterate over it.

## Exercises

### Exercise 1: 1D and 2D arrays

File: `ex_arrays_1d_2d.c`

Declare a 1D array of 10 ints initialized with values, and a 2D array `int matrix[3][3]`. Print both. Compute the sum of all elements in the 2D array.

### Exercise 2: string.h functions

File: `ex_string_h.c`

Demonstrate:
- `strlen` on a string
- `strcpy` into a buffer (with correct size)
- `strcat` to append
- `strcmp` to compare
- `memset` to zero a buffer
- `memcpy` to copy a block
- `memmove` to copy overlapping regions

Observe that `strcpy` does not check bounds; explain why `memcpy`/`memmove` need explicit sizes.

### Exercise 3: Struct Point

File: `ex_struct_point.c`

Define `struct Point { int x; int y; }`. Write a function `void print_point(struct Point p)` and one `struct Point make_point(int x, int y)`. In `main`, create two points, print them, and compute the distance between them (sqrt of squared differences — `#include <math.h>` and link with `-lm`).

### Exercise 4: typedef for structs

File: `ex_typedef.c`

Take the `struct Point` from exercise 3 and add `typedef struct Point Point;`. Rewrite the function signatures to use `Point` instead of `struct Point`. Observe how `typedef` reduces verbosity.

### Exercise 5: Unions

File: `ex_union.c`

Define a union that can hold an `int`, a `float`, or a `double`. Write a small program that stores an `int`, prints it, then stores a `float`, prints it, and observes that the `int` value is overwritten.

Also print `sizeof(union)` and compare with `sizeof` of each member.

### Exercise 6: Enums

File: `ex_enum.c`

Define `enum Weekday { MON, TUE, WED, THU, FRI, SAT, SUN }`. Write a function that takes an `enum Weekday` and returns the number of hours in a workday (8 for Mon-Fri, 0 for weekends). Use a `switch`.

### Exercise 7: Array of structs

File: `ex_array_of_structs.c`

Define `struct Student { char name[64]; int grade; }`. Create an array of 3 `Student`s, initialize them, print each, and find the student with the highest grade.

## Hints

- `strcmp` returns 0 when strings are equal, a positive value when the first is greater, and a negative value otherwise. Do not compare the return value to 1 or -1 in portable code.
- `strcpy(dst, src)` copies until the null terminator; ensure `dst` is large enough. `strncpy` does not guarantee null termination if the source is longer than the destination — be careful, or use `snprintf`/`strlcpy` if available.
- `memmove` handles overlapping memory correctly; `memcpy` does not. Use `memmove` when source and destination may overlap.
- A union's size is the size of its largest member (plus possible padding). Writing one member and reading another is allowed by the standard as of C11 (type punning via union is implementation-defined but common), but is still worth understanding as a deliberate overlap mechanism.
- Enum values start at 0 by default and increment unless assigned explicitly. `enum { A, B, C }` gives A=0, B=1, C=2. You can assign `enum { A=10, B, C }` to get A=10, B=11, C=12.
