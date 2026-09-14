#include <stdio.h>
#include <math.h>

struct Point {
    int x;
    int y;
};

void print_point(struct Point p) {
    printf("Point(%d, %d)\n", p.x, p.y);
}

struct Point make_point(int x, int y) {
    struct Point p = {x, y};
    return p;
}

double point_distance(struct Point a, struct Point b) {
    double dx = (double)(a.x - b.x);
    double dy = (double)(a.y - b.y);
    return sqrt(dx * dx + dy * dy);
}

int main(void) {
    struct Point a = make_point(3, 4);
    struct Point b = make_point(7, 1);

    print_point(a);
    print_point(b);

    double d = point_distance(a, b);
    printf("Distance from a to b: %.4f\n", d);

    return 0;
}
