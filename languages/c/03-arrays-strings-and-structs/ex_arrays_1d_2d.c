#include <stdio.h>

int main(void) {
    /* 1D array */
    int arr[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    printf("1D array:\n");
    for (int i = 0; i < 10; i++) {
        printf("  arr[%d] = %d\n", i, arr[i]);
    }

    /* 2D array */
    int matrix[3][3] = {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9}
    };
    printf("2D array (matrix):\n");
    for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 3; c++) {
            printf("  matrix[%d][%d] = %d\n", r, c, matrix[r][c]);
        }
    }

    /* Sum of all elements in the 2D array */
    int sum = 0;
    for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 3; c++) {
            sum += matrix[r][c];
        }
    }
    printf("Sum of matrix elements: %d\n", sum);

    return 0;
}
