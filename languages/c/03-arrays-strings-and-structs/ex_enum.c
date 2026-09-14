#include <stdio.h>

enum Weekday {
    MON, TUE, WED, THU, FRI, SAT, SUN
};

int workday_hours(enum Weekday d) {
    switch (d) {
    case MON:
    case TUE:
    case WED:
    case THU:
    case FRI:
        return 8;
    case SAT:
    case SUN:
        return 0;
    default:
        return -1; /* unknown */
    }
}

int main(void) {
    printf("MON hours: %d\n", workday_hours(MON));
    printf("FRI hours: %d\n", workday_hours(FRI));
    printf("SAT hours: %d\n", workday_hours(SAT));
    printf("SUN hours: %d\n", workday_hours(SUN));

    printf("\nEnum values (underlying ints):\n");
    printf("  MON=%d TUE=%d WED=%d THU=%d FRI=%d SAT=%d SUN=%d\n",
           MON, TUE, WED, THU, FRI, SAT, SUN);

    return 0;
}
