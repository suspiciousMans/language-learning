/*
 * Deliberate memory leak.
 *
 * fix_leak() allocates a buffer and returns it. main() calls fix_leak(),
 * uses the buffer, but never frees it.
 *
 * Task: run under Valgrind and observe "definitely lost". Then free() the
 * buffer in main() and confirm Valgrind reports no leaks.
 *
 * Build: gcc -std=c11 -Wall -Wextra -o ex_deliberate_leak ex_deliberate_leak.c
 * Run:   valgrind --leak-check=full ./ex_deliberate_leak
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *fix_leak(void) {
    char *buf = malloc(64);
    if (buf == NULL) {
        return NULL;
    }
    strcpy(buf, "this buffer is never freed (intentionally)");
    return buf;
}

int main(void) {
    char *msg = fix_leak();
    if (msg == NULL) {
        return 1;
    }
    printf("%s\n", msg);

    /* TODO: free(msg); */

    return 0;
}
