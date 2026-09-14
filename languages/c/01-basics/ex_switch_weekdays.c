#include <stdio.h>

int main(void) {
    /* Map an integer 1..7 to a weekday name.
     * 1 = Monday, 7 = Sunday.
     */

    int day = 3; /* TODO: read from user or change for testing */

    const char *name = "unknown";

    switch (day) {
    case 1: name = "Monday";     break;
    case 2: name = "Tuesday";    break;
    case 3: name = "Wednesday";  break;
    case 4: name = "Thursday";   break;
    case 5: name = "Friday";     break;
    case 6: name = "Saturday";   break;
    case 7: name = "Sunday";     break;
    default: name = "out of range"; break;
    }

    printf("Day %d = %s\n", day, name);
    return 0;
}
