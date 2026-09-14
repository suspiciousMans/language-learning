#include <stdio.h>

int main(void) {
    /* Strings in C are null-terminated char arrays. */

    char greeting[] = "Hello, C!";

    printf("As a string: %s\n", greeting);
    printf("Character by character:\n");

    /* TODO: loop over greeting until the null terminator and print each char */

    printf("\nLength (by hand): ");
    /* TODO: count characters until '\0' and print the count */
    printf("%zu\n", 0); /* placeholder */

    return 0;
}
