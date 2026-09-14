#ifndef TEST_FRAMEWORK_H
#define TEST_FRAMEWORK_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Simple test framework */

static int __test_count = 0;
static int __test_passed = 0;
static int __test_failed = 0;

#define TEST_START(name) \
    { \
        __test_count++; \
        printf("[TEST] %s ... ", name); \
        fflush(stdout);

#define TEST_END() \
        printf("PASSED\n"); \
        __test_passed++; \
    }

#define ASSERT_EQ(expected, actual) \
    do { \
        int exp = (int)(expected); \
        int act = (int)(actual); \
        if (exp != act) { \
            printf("FAILED\n"); \
            printf("  %s:%d: Expected %d, got %d\n", __FILE__, __LINE__, exp, act); \
            __test_failed++; \
        } \
    } while(0)

#define ASSERT_NE(a, b) \
    do { \
        int val_a = (int)(a); \
        int val_b = (int)(b); \
        if (val_a == val_b) { \
            printf("FAILED\n"); \
            printf("  %s:%d: Expected values to differ, both were %d\n", \
                   __FILE__, __LINE__, val_a); \
            __test_failed++; \
        } \
    } while(0)

#define ASSERT_STR_EQ(expected, actual) \
    do { \
        const char *exp_str = (expected); \
        const char *act_str = (actual); \
        if (strcmp(exp_str, act_str) != 0) { \
            printf("FAILED\n"); \
            printf("  %s:%d: Expected \"%s\", got \"%s\"\n", __FILE__, __LINE__, \
                   exp_str, act_str); \
            __test_failed++; \
        } \
    } while(0)

#define ASSERT_TRUE(cond) \
    do { \
        if (!(cond)) { \
            printf("FAILED\n"); \
            printf("  %s:%d: Condition failed: %s\n", __FILE__, __LINE__, #cond); \
            __test_failed++; \
        } \
    } while(0)

#define ASSERT_FALSE(cond) \
    do { \
        if ((cond)) { \
            printf("FAILED\n"); \
            printf("  %s:%d: Condition should be false: %s\n", __FILE__, __LINE__, #cond); \
            __test_failed++; \
        } \
    } while(0)

#define TEST_REPORT() \
    printf("\n=== Test Summary ===\n"); \
    printf("Total:  %d\n", __test_count); \
    printf("Passed: %d\n", __test_passed); \
    printf("Failed: %d\n", __test_failed); \
    if (__test_failed == 0) { \
        printf("All tests passed!\n"); \
        return 0; \
    } else { \
        printf("Some tests failed.\n"); \
        return 1; \
    }

#endif /* TEST_FRAMEWORK_H */
