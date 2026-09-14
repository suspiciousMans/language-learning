#include <stdio.h>
#include <string.h>

struct Student {
    char name[64];
    int grade;
};

int main(void) {
    struct Student students[3] = {
        {.name = "Alice",   .grade = 87},
        {.name = "Bob",     .grade = 92},
        {.name = "Charlie", .grade = 78}
    };

    printf("Students:\n");
    for (int i = 0; i < 3; i++) {
        printf("  %s: grade %d\n", students[i].name, students[i].grade);
    }

    /* Find the student with the highest grade. */
    int best = 0;
    for (int i = 1; i < 3; i++) {
        if (students[i].grade > students[best].grade) {
            best = i;
        }
    }
    printf("\nHighest grade: %s with %d\n",
           students[best].name, students[best].grade);

    return 0;
}
