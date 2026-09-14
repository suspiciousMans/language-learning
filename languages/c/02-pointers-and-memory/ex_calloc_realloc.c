#include <stdio.h>
#include <stdlib.h>

int main(void) {
    /* calloc: allocates and zero-initializes. */
    int n = 5;
    double *arr = calloc((size_t)n, sizeof *arr);
    if (arr == NULL) {
        fprintf(stderr, "calloc failed\n");
        return 1;
    }

    printf("calloc'd array (should be zeros):\n");
    for (int i = 0; i < n; i++) {
        printf("  arr[%d] = %g\n", i, arr[i]);
    }

    /* realloc: grow the array to 10 doubles. */
    int new_n = 10;
    double *tmp = realloc(arr, (size_t)new_n * sizeof *tmp);
    if (tmp == NULL) {
        fprintf(stderr, "realloc failed\n");
        free(arr);
        return 1;
    }
    arr = tmp;

    /* Initialize the new slots. */
    for (int i = n; i < new_n; i++) {
        arr[i] = (double)i;
    }

    printf("realloc'd array (first 5 zeros, rest = index):\n");
    for (int i = 0; i < new_n; i++) {
        printf("  arr[%d] = %g\n", i, arr[i]);
    }

    free(arr);
    return 0;
}
