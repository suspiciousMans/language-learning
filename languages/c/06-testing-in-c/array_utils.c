#include "array_utils.h"
#include <stddef.h>

int array_sum(int *arr, int len) {
    if (arr == NULL || len < 0) {
        return 0;
    }
    
    int sum = 0;
    for (int i = 0; i < len; i++) {
        sum += arr[i];
    }
    
    return sum;
}

int array_max(int *arr, int len) {
    if (arr == NULL || len <= 0) {
        return 0;  /* Error case */
    }
    
    int max = arr[0];
    for (int i = 1; i < len; i++) {
        if (arr[i] > max) {
            max = arr[i];
        }
    }
    
    return max;
}

void array_reverse(int *arr, int len) {
    if (arr == NULL || len <= 0) {
        return;
    }
    
    for (int i = 0; i < len / 2; i++) {
        int temp = arr[i];
        arr[i] = arr[len - 1 - i];
        arr[len - 1 - i] = temp;
    }
}

int array_search(int *arr, int len, int value) {
    if (arr == NULL || len < 0) {
        return -1;
    }
    
    for (int i = 0; i < len; i++) {
        if (arr[i] == value) {
            return i;
        }
    }
    
    return -1;
}
