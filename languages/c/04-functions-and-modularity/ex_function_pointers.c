#include <stdio.h>

/* Two functions with the same signature. */
int add(int a, int b) {
    return a + b;
}

int mul(int a, int b) {
    return a * b;
}

/* A type alias for a binary operation on two ints. */
typedef int (*binop_t)(int, int);

int main(void) {
    binop_t op;

    op = add;
    printf("op = add:  3 + 4 = %d\n", op(3, 4));

    op = mul;
    printf("op = mul:  3 * 4 = %d\n", op(3, 4));

    /* An array of function pointers. */
    binop_t ops[] = {add, mul};
    const char *names[] = {"add", "mul"};
    int x = 5, y = 6;

    printf("\nArray of function pointers:\n");
    for (int i = 0; i < 2; i++) {
        printf("  %s: %d %c %d = %d\n", names[i], x, (i == 0 ? '+' : '*'), y, ops[i](x, y));
    }

    return 0;
}
