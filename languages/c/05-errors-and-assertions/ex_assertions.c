#include <stdio.h>
#include <assert.h>

/*
 * Exercise 2: Assertions in action
 * 
 * Use assert() to validate preconditions, postconditions, and invariants.
 * Compile with -DNDEBUG to disable assertions.
 */

/* Check if array is sorted (helper for postcondition checks) */
int is_sorted(int *arr, int len) {
    assert(arr != NULL);
    for (int i = 0; i < len - 1; i++) {
        if (arr[i] > arr[i + 1]) {
            return 0;
        }
    }
    return 1;
}

/* Simple bubble sort with precondition and postcondition checks. */
void sort_array(int *arr, int len) {
    assert(arr != NULL);      /* Precondition: pointer must be valid */
    assert(len >= 0);         /* Precondition: length must be non-negative */
    
    for (int i = 0; i < len - 1; i++) {
        for (int j = 0; j < len - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
    
    assert(is_sorted(arr, len));  /* Postcondition: array must be sorted */
}

/* Find the maximum element in the array. */
int* find_max(int *arr, int len) {
    assert(arr != NULL);      /* Precondition: pointer must be valid */
    assert(len > 0);          /* Precondition: array must not be empty */
    
    int *max = arr;
    for (int i = 1; i < len; i++) {
        if (arr[i] > *max) {
            max = &arr[i];
        }
    }
    
    /* Postcondition: result must be >= all elements */
    for (int i = 0; i < len; i++) {
        assert(*max >= arr[i]);
    }
    
    return max;
}

int main(void) {
    printf("=== Assertion Tests ===\n");
    
    /* Test find_max */
    int arr1[] = {3, 1, 4, 1, 5, 9, 2, 6};
    int len1 = sizeof(arr1) / sizeof(arr1[0]);
    
    int *max_ptr = find_max(arr1, len1);
    printf("Max of array: %d\n", *max_ptr);
    
    /* Test sort_array */
    int arr2[] = {9, 3, 7, 1, 4};
    int len2 = sizeof(arr2) / sizeof(arr2[0]);
    
    printf("Before sort: ");
    for (int i = 0; i < len2; i++) printf("%d ", arr2[i]);
    printf("\n");
    
    sort_array(arr2, len2);
    
    printf("After sort: ");
    for (int i = 0; i < len2; i++) printf("%d ", arr2[i]);
    printf("\n");
    
    /* These will trigger assertions if uncommented (and assertions are enabled) */
    /* find_max(arr1, 0);  // Assertion: len > 0 */
    /* find_max(NULL, len1);  // Assertion: arr != NULL */
    
    printf("\nAll assertions passed! (or disabled with -DNDEBUG)\n");
    
    return 0;
}
