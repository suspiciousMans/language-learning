#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

/*
 * Exercise 4: Error propagation
 * 
 * Write functions that return error codes and propagate errors upward.
 */

/* Parse two integers from a space-separated string. */
int read_numbers(const char *input, int *a, int *b) {
    if (input == NULL || a == NULL || b == NULL) {
        return -1;
    }
    
    char *copy = malloc(strlen(input) + 1);
    if (copy == NULL) {
        return -1;
    }
    strcpy(copy, input);
    
    char *a_str = strtok(copy, " ");
    char *b_str = strtok(NULL, " ");
    
    if (a_str == NULL || b_str == NULL) {
        free(copy);
        return -1;
    }
    
    char *endptr;
    long val_a = strtol(a_str, &endptr, 10);
    if (*endptr != '\0') {
        free(copy);
        return -1;
    }
    
    long val_b = strtol(b_str, &endptr, 10);
    if (*endptr != '\0') {
        free(copy);
        return -1;
    }
    
    *a = (int)val_a;
    *b = (int)val_b;
    
    free(copy);
    return 0;
}

/* Compute result from two numbers. Return 0 on success, -1 on error. */
int compute(int a, int b, int *result) {
    if (result == NULL) {
        return -1;
    }
    
    /* Example: compute sqrt of (a - b) */
    int diff = a - b;
    
    if (diff < 0) {
        fprintf(stderr, "Error: a - b is negative (%d), cannot compute sqrt\n", diff);
        return -1;
    }
    
    *result = (int)sqrt(diff);
    return 0;
}

int main(void) {
    printf("=== Error Propagation Test ===\n");
    
    const char *inputs[] = {
        "9 4",      /* Valid: 9-4=5, sqrt(5)=2 */
        "10 15",    /* Invalid: 10-15=-5, sqrt of negative */
        "abc def",  /* Invalid: non-integer */
        "5",        /* Invalid: missing second number */
    };
    
    for (int i = 0; i < 4; i++) {
        printf("\nInput: \"%s\"\n", inputs[i]);
        
        int a, b, result;
        
        /* Try to read numbers */
        if (read_numbers(inputs[i], &a, &b) != 0) {
            printf("  ERROR: Failed to parse input\n");
            continue;  /* Error propagated: skip compute step */
        }
        
        printf("  Parsed: a=%d, b=%d\n", a, b);
        
        /* Try to compute */
        if (compute(a, b, &result) != 0) {
            printf("  ERROR: Computation failed\n");
            continue;  /* Error propagated: skip result */
        }
        
        printf("  Result: sqrt(%d - %d) = %d\n", a, b, result);
    }
    
    return 0;
}
