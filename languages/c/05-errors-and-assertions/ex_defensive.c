#include <stdio.h>
#include <string.h>
#include <ctype.h>

/*
 * Exercise 3: Defensive validation
 * 
 * Write functions that validate user input and return success/failure.
 * Return 1 for valid, 0 for invalid.
 */

/* Validate email: must contain '@' */
int validate_email(const char *email) {
    if (email == NULL || strlen(email) == 0) {
        return 0;
    }
    
    char *at = strchr(email, '@');
    if (at == NULL) {
        return 0;
    }
    
    /* Basic check: at least one char before and after @ */
    if (at == email || *(at + 1) == '\0') {
        return 0;
    }
    
    return 1;
}

/* Validate age: must be in range [0, 150] */
int validate_age(int age) {
    return (age >= 0 && age <= 150) ? 1 : 0;
}

/* Validate password: must be at least 8 characters */
int validate_password(const char *pwd) {
    if (pwd == NULL) {
        return 0;
    }
    return (strlen(pwd) >= 8) ? 1 : 0;
}

int main(void) {
    printf("=== Email Validation ===\n");
    
    const char *emails[] = {
        "user@example.com",
        "no-at-sign.com",
        "@nodomain.com",
        "nouser@",
        "",
        NULL
    };
    
    for (int i = 0; emails[i] != NULL; i++) {
        int valid = validate_email(emails[i]);
        printf("  '%s': %s\n", emails[i], valid ? "VALID" : "INVALID");
    }
    
    printf("\n=== Age Validation ===\n");
    
    int ages[] = {0, 25, 100, 150, 151, -1};
    
    for (int i = 0; i < 6; i++) {
        int valid = validate_age(ages[i]);
        printf("  Age %d: %s\n", ages[i], valid ? "VALID" : "INVALID");
    }
    
    printf("\n=== Password Validation ===\n");
    
    const char *passwords[] = {
        "short",
        "longenough",
        "12345678",
        "",
        NULL
    };
    
    for (int i = 0; passwords[i] != NULL; i++) {
        int valid = validate_password(passwords[i]);
        printf("  '%s' (%lu chars): %s\n", passwords[i], strlen(passwords[i]), 
               valid ? "VALID" : "INVALID");
    }
    
    return 0;
}
