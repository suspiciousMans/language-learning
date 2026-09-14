#include <stdio.h>
#include <stdlib.h>

/* Allocate an array of n ints, initialize to 0..n-1, return the pointer.
 * Returns NULL on allocation failure.
 */
int *make_array(int n) {
    int *a = malloc((size_t)n * sizeof *a);
    if (a == NULL) {
        return NULL;
    }
    for (int i = 0; i < n; i++) {
        a[i] = i;
    }
    return a;
}

int main(void) {
    int n = 10;
    int *arr = make_array(n);
    if (arr == NULL) {
        fprintf(stderr, "allocation failed\n");
        return 1;
    }

    printf("Array of %d ints:\n", n);
    for (int i = 0; i < n; i++) {
        printf("  arr[%d] = %d\n", i, arr[i]);
    }

    free(arr);
    arr = NULL; /* avoid a dangling pointer */

    return 0;
}
