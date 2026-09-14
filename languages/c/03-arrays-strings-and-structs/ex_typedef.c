#include <stdio.h>
#include <math.h>

/* typedef lets us drop the 'struct' keyword when using the type. */
typedef struct Point {
    int x;
    int y;
} Point;

void print_point(Point p) {
    printf("Point(%d, %d)\n", p.x, p.y);
}

Point make_point(int x, int y) {
    Point p = {x, y};
    return p;
}

double point_distance(Point a, Point b) {
    double dx = (double)(a.x - b.x);
    double dy = (double)(a.y - b.y);
    return sqrt(dx * dx + dy * dy);
}

int main(void) {
    Point a = make_point(3, 4);
    Point b = make_point(7, 1);

    print_point(a);
    print_point(b);

    printf("Distance: %.4f\n", point_distance(a, b));

    return 0;
}
