#include <stdio.h>

union IntFloatDouble {
    int i;
    float f;
    double d;
};

int main(void) {
    union IntFloatDouble u;

    u.i = 42;
    printf("After u.i = 42:\n");
    printf("  u.i = %d\n", u.i);
    printf("  u.f = %g  (garbage — same storage, reinterpreted)\n", u.f);
    printf("  u.d = %g  (garbage)\n", u.d);

    u.f = 3.14f;
    printf("After u.f = 3.14:\n");
    printf("  u.i = %d  (garbage — same storage, reinterpreted)\n", u.i);
    printf("  u.f = %g\n", u.f);
    printf("  u.d = %g  (garbage)\n", u.d);

    u.d = 2.71828;
    printf("After u.d = 2.71828:\n");
    printf("  u.i = %d  (garbage)\n", u.i);
    printf("  u.f = %g  (garbage)\n", u.f);
    printf("  u.d = %g\n", u.d);

    printf("\nsizeof(union IntFloatDouble) = %zu\n", sizeof u);
    printf("sizeof(int)   = %zu\n", sizeof(int));
    printf("sizeof(float) = %zu\n", sizeof(float));
    printf("sizeof(double)= %zu\n", sizeof(double));

    return 0;
}
