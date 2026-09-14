#include <stdio.h>
#include <stdlib.h>

int main(void) {
    /* Read an integer and categorize it.
     * Use fgets + sscanf to avoid leaving a newline in the buffer.
     */

    char buf[64];
    int n;

    printf("Enter an integer: ");
    if (fgets(buf, sizeof buf, stdin) == NULL) {
        fprintf(stderr, "input error\n");
        return 1;
    }

    if (sscanf(buf, "%d", &n) != 1) {
        fprintf(stderr, "not an integer\n");
        return 1;
    }

    /* TODO: categorize n as negative, zero, or positive */
    printf("TODO: categorize %d\n", n);

    return 0;
}
