#include "utils.h"

int max_of(int a, int b) {
    return a > b ? a : b;
}

int min_of(int a, int b) {
    return a < b ? a : b;
}

void swap_ints(int *a, int *b) {
    int tmp = *a;
    *a = *b;
    *b = tmp;
}
