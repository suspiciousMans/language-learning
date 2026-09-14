#include <stdio.h>
#include <stdlib.h>

int main(void) {
    /* Read integers until the user enters 0.
     * Report the count (excluding the sentinel) and the sum.
     */

    char buf[64];
    int n;
    int count = 0;
    long sum = 0;

    for (;;) {
        printf("Enter an integer (0 to stop): ");
        if (fgets(buf, sizeof buf, stdin) == NULL) {
            break;
        }
        if (sscanf(buf, "%d", &n) != 1) {
            continue; /* ignore non-integer lines */
        }
        if (n == 0) {
            break;
        }

        /* TODO: increment count and add n to sum */
    }

    printf("Count: %d\nSum: %ld\n", count, sum);
    return 0;
}
