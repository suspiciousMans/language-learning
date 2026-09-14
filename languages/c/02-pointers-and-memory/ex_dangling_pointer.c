/*
 * Dangling pointer / use-after-free.
 *
 * get_message() allocates a buffer, copies a message into it, frees it, and
 * then returns the now-dangling pointer. main() prints through the dangling
 * pointer — undefined behavior, caught by Valgrind/ASan.
 *
 * Task: run under Valgrind and observe "Invalid read of size 1". Then fix by
 * not freeing inside get_message() (let the caller own the memory) and free
 * in main().
 *
 * Build: gcc -std=c11 -Wall -Wextra -o ex_dangling_pointer ex_dangling_pointer.c
 * Run:   valgrind --leak-check=full ./ex_dangling_pointer
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Returns a pointer to a heap-allocated message.
 * (The current buggy version frees the buffer before returning.)
 */
char *get_message(void) {
    char *buf = malloc(64);
    if (buf == NULL) {
        return NULL;
    }
    strcpy(buf, "this message is returned, but the memory is freed first (bug)");
    free(buf); /* BUG: frees the memory that we are about to return */
    return buf; /* returning a dangling pointer */
}

int main(void) {
    char *msg = get_message();
    if (msg == NULL) {
        return 1;
    }
    printf("%s\n", msg); /* BUG: read through a dangling pointer */
    free(msg);            /* BUG: double-free / invalid free */

    return 0;
}
