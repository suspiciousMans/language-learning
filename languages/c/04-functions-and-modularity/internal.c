/* internal.c: demonstrates static and extern. */

#include "internal.h"

/* This variable is defined here and intended to be used by other
 * translation units via the extern declaration in internal.h. */
int counter = 0;

/* This function is static: it has internal linkage and is NOT visible
 * outside this translation unit. */
static int helper(int x) {
    return x * 2;
}

/* A public function that uses the static helper internally. */
int double_and_increment(void) {
    counter += 1;
    return helper(counter);
}
