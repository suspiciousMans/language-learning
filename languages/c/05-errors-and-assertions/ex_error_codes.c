#include <stdio.h>
#include <stdlib.h>

/*
 * Exercise 1: Simple error codes
 * 
 * Implement divide() and parse_int() to return error codes.
 * 0 = success, -1 = failure.
 */

/* Divide a by b, store result in *result. Return 0 on success, -1 on division by zero. */
int divide(int a, int b, int *result) {
    if (b == 0) {
        return -1;  /* Error: division by zero */
    }
    *result = a / b;
    return 0;  /* Success */
}

/* Parse a string as an integer. Store in *out. Return 0 on success, -1 on error. */
int parse_int(const char *str, int *out) {
    char *endptr;
    long val = strtol(str, &endptr, 10);
    
    /* Check for conversion error or overflow */
    if (str == endptr || *endptr != '\0') {
        return -1;  /* Error: not a valid integer */
    }
    
    *out = (int)val;
    return 0;  /* Success */
}

int main(void) {
    int result;
    int x;
    
    printf("=== Division Tests ===\n");
    
    /* Test successful division */
    if (divide(10, 2, &result) == 0) {
        printf("10 / 2 = %d\n", result);
    } else {
        printf("Error: division by zero\n");
    }
    
    /* Test division by zero */
    if (divide(10, 0, &result) == 0) {
        printf("10 / 0 = %d\n", result);
    } else {
        printf("Error: division by zero\n");
    }
    
    printf("\n=== Parsing Tests ===\n");
    
    /* Test successful parse */
    if (parse_int("42", &x) == 0) {
        printf("Parsed: %d\n", x);
    } else {
        printf("Error: failed to parse '42'\n");
    }
    
    /* Test failed parse */
    if (parse_int("abc", &x) == 0) {
        printf("Parsed: %d\n", x);
    } else {
        printf("Error: failed to parse 'abc'\n");
    }
    
    return 0;
}
