#include <stdio.h>

/* Pass-by-value: the parameters are copies. Swapping them does nothing to the caller. */
void swap_by_value(int a, int b) {
    int tmp = a;
    a = b;
    b = tmp;
}

/* Pass-by-pointer: the parameters are addresses. Swapping the pointed-to values works. */
void swap_by_ptr(int *a, int *b) {
    int tmp = *a;
    *a = *b;
    *b = tmp;
}

int main(void) {
    int x = 3, y = 7;

    printf("Before swap_by_value: x=%d y=%d\n", x, y);
    swap_by_value(x, y);
    printf("After  swap_by_value: x=%d y=%d  (unchanged — pass-by-value)\n", x, y);

    printf("Before swap_by_ptr:   x=%d y=%d\n", x, y);
    swap_by_ptr(&x, &y);
    printf("After  swap_by_ptr:   x=%d y=%d  (swapped — pass-by-pointer)\n", x, y);

    return 0;
}
