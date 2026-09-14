#include "test_framework.h"
#include "array_utils.h"

int main(void) {
    printf("=== Array Utils Tests ===\n\n");
    
    /* Test array_sum */
    TEST_START("array_sum: normal array");
    int arr1[] = {1, 2, 3, 4, 5};
    ASSERT_EQ(15, array_sum(arr1, 5));
    TEST_END();
    
    TEST_START("array_sum: single element");
    int arr2[] = {42};
    ASSERT_EQ(42, array_sum(arr2, 1));
    TEST_END();
    
    TEST_START("array_sum: negative numbers");
    int arr3[] = {-5, 10, -3};
    ASSERT_EQ(2, array_sum(arr3, 3));
    TEST_END();
    
    /* Test array_max */
    TEST_START("array_max: normal array");
    int arr4[] = {3, 1, 4, 1, 5, 9};
    ASSERT_EQ(9, array_max(arr4, 6));
    TEST_END();
    
    TEST_START("array_max: single element");
    int arr5[] = {42};
    ASSERT_EQ(42, array_max(arr5, 1));
    TEST_END();
    
    TEST_START("array_max: negative numbers");
    int arr6[] = {-5, -1, -10};
    ASSERT_EQ(-1, array_max(arr6, 3));
    TEST_END();
    
    /* Test array_reverse */
    TEST_START("array_reverse: normal array");
    int arr7[] = {1, 2, 3, 4, 5};
    array_reverse(arr7, 5);
    ASSERT_EQ(5, arr7[0]);
    ASSERT_EQ(1, arr7[4]);
    TEST_END();
    
    TEST_START("array_reverse: single element");
    int arr8[] = {42};
    array_reverse(arr8, 1);
    ASSERT_EQ(42, arr8[0]);
    TEST_END();
    
    TEST_START("array_reverse: two elements");
    int arr9[] = {1, 2};
    array_reverse(arr9, 2);
    ASSERT_EQ(2, arr9[0]);
    ASSERT_EQ(1, arr9[1]);
    TEST_END();
    
    /* Test array_search (parameterized) */
    int arr10[] = {10, 20, 30, 40, 50};
    int len = 5;
    
    TEST_START("array_search: find first element");
    ASSERT_EQ(0, array_search(arr10, len, 10));
    TEST_END();
    
    TEST_START("array_search: find middle element");
    ASSERT_EQ(2, array_search(arr10, len, 30));
    TEST_END();
    
    TEST_START("array_search: find last element");
    ASSERT_EQ(4, array_search(arr10, len, 50));
    TEST_END();
    
    TEST_START("array_search: element not found");
    ASSERT_EQ(-1, array_search(arr10, len, 100));
    TEST_END();
    
    TEST_START("array_search: empty array");
    ASSERT_EQ(-1, array_search(arr10, 0, 10));
    TEST_END();
    
    TEST_REPORT();
}
