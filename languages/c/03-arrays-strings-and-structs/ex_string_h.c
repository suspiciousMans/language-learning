#include <stdio.h>
#include <string.h>

int main(void) {
    /* strlen */
    const char *s = "Hello, C!";
    printf("strlen(\"%s\") = %zu\n", s, strlen(s));

    /* strcpy — ensure the destination is large enough */
    char dst[64];
    strcpy(dst, "copied");
    printf("strcpy: dst = \"%s\"\n", dst);

    /* strcat — append */
    strcat(dst, " and appended");
    printf("strcat: dst = \"%s\"\n", dst);

    /* strcmp */
    printf("strcmp(\"abc\", \"abc\") = %d (0 means equal)\n", strcmp("abc", "abc"));
    printf("strcmp(\"abc\", \"abd\") = %d (positive means first > second)\n", strcmp("abc", "abd"));
    printf("strcmp(\"abd\", \"abc\") = %d (negative means first < second)\n", strcmp("abd", "abc"));

    /* memset — zero a buffer */
    char buf[16];
    memset(buf, 0, sizeof buf);
    printf("memset zeroes: buf[0] = %d, buf[15] = %d (all zero)\n", buf[0], buf[15]);

    /* memcpy — copy a block (non-overlapping source/destination) */
    int src[5] = {10, 20, 30, 40, 50};
    int dst2[5];
    memcpy(dst2, src, 5 * sizeof *dst2);
    printf("memcpy: dst2[0..4] = %d %d %d %d %d\n", dst2[0], dst2[1], dst2[2], dst2[3], dst2[4]);

    /* memmove — handles overlapping regions correctly */
    int overlap[5] = {1, 2, 3, 4, 5};
    memmove(&overlap[2], &overlap[0], 3 * sizeof *overlap);
    printf("memmove (overlap): overlap = %d %d %d %d %d\n",
           overlap[0], overlap[1], overlap[2], overlap[3], overlap[4]);

    return 0;
}
