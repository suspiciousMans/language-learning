# Project 02: Pointers and Memory

**Difficulty:** beginner→intermediate
**Prerequisites:** project 01 (basics)

## Goals

- Understand what a pointer is and how to declare, initialize, and dereference one.
- Learn pointer arithmetic and how it relates to arrays.
- Understand the difference between pass-by-value and pass-by-pointer.
- Learn dynamic memory: `malloc`, `calloc`, `realloc`, and `free`.
- Understand stack vs heap allocation.
- Understand memory leaks conceptually and how to detect them with Valgrind.
- Identify and fix deliberate leaks and double-frees.

## Concepts

- Pointers: `int *p`, address-of `&`, dereference `*`
- Pointer arithmetic: `p + 1`, arrays as pointers
- Pass-by-value vs pass-by-pointer (swapping two values)
- Dynamic allocation: `malloc`, `calloc`, `realloc`, `free`
- Stack allocation (local variables) vs heap allocation (malloc'd memory)
- Memory leaks: allocated memory that is never freed
- Double-free: freeing the same pointer twice — undefined behavior
- Dangling pointers: pointers to memory that has been freed
- Valgrind basics: `valgrind --leak-check=full`, reading leak summaries

## Completion checklist

- [ ] Write a program that declares an `int`, takes its address, and prints the address and the value through the pointer.
- [ ] Write a program that demonstrates pointer arithmetic on an array.
- [ ] Write a `swap` function that swaps two `int`s via pointers (pass-by-pointer) and demonstrate that pass-by-value does not swap.
- [ ] Write a function that allocates an array of N ints via `malloc`, fills it, prints it, and frees it.
- [ ] Write a program that deliberately leaks memory (malloc without free) and document what Valgrind reports.
- [ ] Write a program that deliberately double-frees and document what Valgrind reports.
- [ ] Fix the leak and the double-free.

## Deliberate bug exercises

These exercises contain bugs on purpose. Your job is to run them under Valgrind (or observe their behavior), read the report, and fix the bug.

### Exercise A: Deliberate leak

File: `ex_deliberate_leak.c`

A function allocates memory and returns it, but the caller never frees it. Run under Valgrind and fix.

### Exercise B: Deliberate double-free

File: `ex_deliberate_double_free.c`

A program frees the same pointer twice. Run under Valgrind and fix.

### Exercise C: Dangling pointer use-after-free

File: `ex_dangling_pointer.c`

A pointer is used after the memory it points to has been freed. Run under Valgrind and fix.

## Exercises

### Exercise 1: Pointers 101

File: `ex_pointers_101.c`

Declare an `int x = 42`, a pointer `int *p = &x`, and print:
- the value of x
- the address of x (`&x`)
- the value of p (the address stored in p)
- the value pointed to by p (`*p`)
- the address of p itself (`&p`)

### Exercise 2: Pointer arithmetic and arrays

File: `ex_pointer_arithmetic.c`

Declare an array `int arr[5] = {10, 20, 30, 40, 50}` and a pointer `int *p = arr`. Use pointer arithmetic to print each element via `*(p + i)` and also via `p[i]`. Observe that they are equivalent.

### Exercise 3: Pass-by-value vs pass-by-pointer (swap)

File: `ex_swap.c`

Write two functions:
- `void swap_by_value(int a, int b)` — does NOT actually swap (demonstrates pass-by-value)
- `void swap_by_ptr(int *a, int *b)` — actually swaps via pointers

Demonstrate in `main` that only the pointer version works.

### Exercise 4: malloc an array

File: `ex_malloc_array.c`

Write a function `int *make_array(int n)` that allocates an array of n ints via `malloc`, initializes them to 0..n-1, and returns the pointer. In `main`, call it for n=10, print the elements, and `free` the result. Handle `malloc` returning NULL.

### Exercise 5: calloc and realloc

File: `ex_calloc_realloc.c`

- Use `calloc` to allocate an array of 5 doubles (observe zero-initialization).
- Use `realloc` to grow the array to 10 doubles.
- Print, then free.

### Exercise 6: Stack vs heap comparison

File: `ex_stack_vs_heap.c`

Declare a local array on the stack and a malloc'd array on the heap. Print both. Explain in comments:
- which one persists after the function returns
- which one is automatically cleaned up
- which one requires manual `free`

## Valgrind basics

If Valgrind is installed, run a program with:

```
valgrind --leak-check=full ./ex_deliberate_leak
```

Key sections of the output:
- "definitely lost" — memory you allocated and lost the pointer to (a leak)
- "indirectly lost" — usually a symptom of a leak in a structure
- "still reachable" — memory still pointed to at exit (often not a bug, but worth checking)

To get a full error trace for invalid reads/writes and double-frees, the same command will report them with stack traces.

If Valgrind is not available, use AddressSanitizer as a fallback:

```
gcc -fsanitize=address -g -o ex ex.c
./ex
```

## Hints

- A pointer is just a variable that holds an address. Its size is the size of an address on your platform (typically 8 bytes on 64-bit).
- `malloc(n * sizeof *p)` is preferred over `malloc(n * sizeof(int))` because it stays correct if the type of `p` changes.
- Always check that `malloc`/`calloc`/`realloc` did not return NULL.
- `free` does not set the pointer to NULL. After freeing, the pointer is dangling. Setting it to NULL after free (`ptr = NULL`) helps catch use-after-free bugs — but the real fix is to not use the pointer at all after freeing.
- A double-free is undefined behavior. Never free the same pointer twice. Never free a pointer that was not returned by malloc/calloc/realloc.
