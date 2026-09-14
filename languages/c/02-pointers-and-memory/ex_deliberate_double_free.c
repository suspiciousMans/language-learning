/*
 * Deliberate double-free.
 *
 * main() frees buf, then frees it again. A double-free is undefined behavior
 * and is caught by Valgrind (and by AddressSanitizer).
 *
 * Task: run under Valgrind and observe the "Invalid free()" error. Then
 * remove the second free() and confirm the error is gone.
 *
 * Build: gcc -std=c11 -Wall -Wextra -o ex_deliberate_double_free ex_deliberate_double_free.c
 * Run:   valgrind --leak-check=full ./ex_deliberate_double_free
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    char *buf = malloc(64);
    if (buf == NULL) {
        return 1;
    }
    strcpy(buf, "double-free demo");
    printf("%s\n", buf);

    free(buf);
    /* Deliberately freeing again — undefined behavior. */
    free(buf);

    return 0;
}
