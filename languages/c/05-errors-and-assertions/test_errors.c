#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <math.h>

/*
 * Exercise 5: Unit tests for error handling
 * 
 * Test both success and failure paths of error-handling functions.
 */

/* Error code functions (from previous exercises) */

int divide(int a, int b, int *result) {
    if (b == 0) {
        return -1;
    }
    *result = a / b;
    return 0;
}

int parse_int(const char *str, int *out) {
    char *endptr;
    long val = strtol(str, &endptr, 10);
    if (str == endptr || *endptr != '\0') {
        return -1;
    }
    *out = (int)val;
    return 0;
}

int validate_password(const char *pwd) {
    if (pwd == NULL) {
        return 0;
    }
    return (strlen(pwd) >= 8) ? 1 : 0;
}

/* Test counters */
static int tests_run = 0;
static int tests_passed = 0;

void assert_equals_int(int expected, int actual, const char *test_name) {
    tests_run++;
    if (expected == actual) {
        tests_passed++;
        printf("  ✓ %s\n", test_name);
    } else {
        printf("  ✗ %s (expected %d, got %d)\n", test_name, expected, actual);
    }
}

void assert_equals_str(const char *expected, const char *actual, const char *test_name) {
    tests_run++;
    if (strcmp(expected, actual) == 0) {
        tests_passed++;
        printf("  ✓ %s\n", test_name);
    } else {
        printf("  ✗ %s (expected '%s', got '%s')\n", test_name, expected, actual);
    }
}

int main(void) {
    printf("=== Unit Tests for Error Handling ===\n\n");
    
    /* Test divide() */
    printf("divide() tests:\n");
    {
        int result;
        
        int ret = divide(10, 2, &result);
        assert_equals_int(0, ret, "divide(10, 2) returns 0");
        assert_equals_int(5, result, "divide(10, 2) result is 5");
        
        ret = divide(10, 0, &result);
        assert_equals_int(-1, ret, "divide(10, 0) returns -1");
        
        ret = divide(15, 3, &result);
        assert_equals_int(0, ret, "divide(15, 3) returns 0");
        assert_equals_int(5, result, "divide(15, 3) result is 5");
    }
    
    /* Test parse_int() */
    printf("\nparse_int() tests:\n");
    {
        int x;
        
        int ret = parse_int("42", &x);
        assert_equals_int(0, ret, "parse_int(\"42\") returns 0");
        assert_equals_int(42, x, "parse_int(\"42\") result is 42");
        
        ret = parse_int("-17", &x);
        assert_equals_int(0, ret, "parse_int(\"-17\") returns 0");
        assert_equals_int(-17, x, "parse_int(\"-17\") result is -17");
        
        ret = parse_int("abc", &x);
        assert_equals_int(-1, ret, "parse_int(\"abc\") returns -1");
        
        ret = parse_int("123abc", &x);
        assert_equals_int(-1, ret, "parse_int(\"123abc\") returns -1");
    }
    
    /* Test validate_password() */
    printf("\nvalidate_password() tests:\n");
    {
        int valid = validate_password("12345678");
        assert_equals_int(1, valid, "validate_password(\"12345678\") returns 1");
        
        valid = validate_password("short");
        assert_equals_int(0, valid, "validate_password(\"short\") returns 0");
        
        valid = validate_password("ValidPassword123");
        assert_equals_int(1, valid, "validate_password(\"ValidPassword123\") returns 1");
        
        valid = validate_password("");
        assert_equals_int(0, valid, "validate_password(\"\") returns 0");
    }
    
    /* Summary */
    printf("\n=== Test Summary ===\n");
    printf("Passed: %d / %d\n", tests_passed, tests_run);
    
    if (tests_passed == tests_run) {
        printf("All tests passed!\n");
        return 0;
    } else {
        printf("Some tests failed.\n");
        return 1;
    }
}
