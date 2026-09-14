#include <stdio.h>
#include "utils.h"

int main(void) {
    int a = 3, b = 7;

    printf("max_of(%d, %d) = %d\n", a, b, max_of(a, b));
    printf("min_of(%d, %d) = %d\n", a, b, min_of(a, b));

    printf("Before swap: a=%d b=%d\n", a, b);
    swap_ints(&a, &b);
    printf("After  swap: a=%d b=%d\n", a, b);

    return 0;
}
