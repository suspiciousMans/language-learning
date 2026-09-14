#include <stdio.h>

int main(void) {
    int arr[5] = {10, 20, 30, 40, 50};
    int *p = arr; /* array name decays to a pointer to the first element */

    printf("Via array indexing:\n");
    for (int i = 0; i < 5; i++) {
        printf("  arr[%d] = %d\n", i, arr[i]);
    }

    printf("Via pointer arithmetic (*(p + i)):\n");
    for (int i = 0; i < 5; i++) {
        printf("  *(p + %d) = %d\n", i, *(p + i));
    }

    printf("Via p[i] (equivalent to arr[i]):\n");
    for (int i = 0; i < 5; i++) {
        printf("  p[%d] = %d\n", i, p[i]);
    }

    return 0;
}
