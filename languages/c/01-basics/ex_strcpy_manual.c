#include <stdio.h>
#include <stddef.h>

/* Copy src into dst, including the null terminator.
 * dst must be large enough to hold src.
 */
void my_strcpy(char *dst, const char *src) {
    /* TODO: implement a manual strcpy */
}

int main(void) {
    const char *source = "Copy this string";
    char destination[64];

    my_strcpy(destination, source);

    printf("Source:      \"%s\"\n", source);
    printf("Destination: \"%s\"\n", destination);

    return 0;
}
