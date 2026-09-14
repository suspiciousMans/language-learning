#include <stdio.h>
#include <string.h>

int main(void) {
    /* Demonstrate printf format specifiers and reading a line with fgets. */

    int age = 25;
    double pi = 3.14159;
    char initial = 'S';
    const char *name = "Ada";

    printf("Name: %s\n", name);
    printf("Initial: %c\n", initial);
    printf("Age: %d\n", age);
    printf("Pi: %.4f\n", pi);

    char line[256];
    printf("Enter a line: ");
    if (fgets(line, sizeof line, stdin) != NULL) {
        /* fgets includes the trailing newline; strip it for cleaner output. */
        size_t len = strlen(line);
        if (len > 0 && line[len - 1] == '\n') {
            line[len - 1] = '\0';
        }
        printf("You entered: %s\n", line);
    }

    return 0;
}
