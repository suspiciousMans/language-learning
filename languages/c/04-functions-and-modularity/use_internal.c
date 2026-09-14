#include <stdio.h>
#include "internal.h"

int main(void) {
    /* counter is declared in internal.h as extern; it is defined in
     * internal.c. */
    printf("counter = %d\n", counter);

    int result = double_and_increment();
    printf("double_and_increment() returned %d\n", result);
    printf("counter = %d\n", counter);

    result = double_and_increment();
    printf("double_and_increment() returned %d\n", result);
    printf("counter = %d\n", counter);

    /* The static function 'helper' from internal.c is NOT accessible
     * from this translation unit. The following line, if uncommented,
     * would cause a compile error:
     *
     *   int x = helper(5);  // ERROR: helper has internal linkage
     */

    return 0;
}
