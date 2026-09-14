#include <stdio.h>
#include <stdlib.h>

/*
 * Stack vs heap comparison.
 *
 * - The stack array `stack_arr` is allocated automatically when main runs and
 *   is reclaimed automatically when main returns. It cannot outlive main.
 * - The heap array `heap_arr` is allocated by malloc and persists until freed.
 *   If returned from a function, it can outlive that function. It must be
 *   freed manually, or it leaks.
 */

void fill_array(int *a, int n) {
    for (int i = 0; i < n; i++) {
        a[i] = i * 10;
    }
}

int main(void) {
    int n = 5;

    /* Stack allocation: automatic lifetime. */
    int stack_arr[5];
    fill_array(stack_arr, n);
    printf("Stack array:\n");
    for (int i = 0; i < n; i++) {
        printf("  stack_arr[%d] = %d\n", i, stack_arr[i]);
    }

    /* Heap allocation: manual lifetime. */
    int *heap_arr = malloc((size_t)n * sizeof *heap_arr);
    if (heap_arr == NULL) {
        fprintf(stderr, "malloc failed\n");
        return 1;
    }
    fill_array(heap_arr, n);
    printf("Heap array:\n");
    for (int i = 0; i < n; i++) {
        printf("  heap_arr[%d] = %d\n", i, heap_arr[i]);
    }

    free(heap_arr);
    heap_arr = NULL;

    return 0;
}
