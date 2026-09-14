#include <stdio.h>

int main(void) {
    int i = 42;
    float f = 3.14f;
    char c = 'A';
    double d = 2.71828;

    printf("int:     %d\n", i);
    printf("sizeof(int):     %zu\n", sizeof i);
    printf("float:   %f\n", f);
    printf("sizeof(float):   %zu\n", sizeof f);
    printf("char:    %c\n", c);
    printf("sizeof(char):    %zu\n", sizeof c);
    printf("double:  %f\n", d);
    printf("sizeof(double):  %zu\n", sizeof d);

    return 0;
}
