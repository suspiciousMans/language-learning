#include "../include/math_lib.h"

int divide(int a, int b) {
    if (b == 0) {
        return 0;  /* Error case */
    }
    return a / b;
}
