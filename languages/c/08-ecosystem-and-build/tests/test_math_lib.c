#include "../include/math_lib.h"
#include "../include/version.h"
#include "../include/counter.h"
#include <stdio.h>
#include <assert.h>

int main(void) {
    printf("=== Math Library Test ===\n\n");
    
    /* Test basic operations */
    printf("Testing basic math operations:\n");
    assert(add(3, 4) == 7);
    printf("  add(3, 4) = %d\n", add(3, 4));
    
    assert(subtract(10, 3) == 7);
    printf("  subtract(10, 3) = %d\n", subtract(10, 3));
    
    assert(multiply(4, 5) == 20);
    printf("  multiply(4, 5) = %d\n", multiply(4, 5));
    
    assert(divide(20, 4) == 5);
    printf("  divide(20, 4) = %d\n", divide(20, 4));
    
    /* Test version */
    printf("\nLibrary version: %s\n", math_lib_version());
    
    /* Test opaque counter */
    printf("\nTesting opaque Counter:\n");
    Counter *c = counter_create(0);
    assert(counter_value(c) == 0);
    printf("  Initial value: %d\n", counter_value(c));
    
    counter_increment(c);
    assert(counter_value(c) == 1);
    printf("  After increment: %d\n", counter_value(c));
    
    counter_increment(c);
    counter_increment(c);
    assert(counter_value(c) == 3);
    printf("  After 2 more increments: %d\n", counter_value(c));
    
    counter_decrement(c);
    assert(counter_value(c) == 2);
    printf("  After decrement: %d\n", counter_value(c));
    
    counter_destroy(c);
    
    printf("\n=== All tests passed! ===\n");
    return 0;
}
