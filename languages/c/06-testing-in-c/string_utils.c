#include "string_utils.h"
#include <string.h>
#include <stdio.h>

int str_equals(const char *a, const char *b) {
    if (a == NULL || b == NULL) {
        return 0;
    }
    return strcmp(a, b) == 0 ? 1 : 0;
}

char* str_concat(const char *a, const char *b, char *out, int out_len) {
    if (a == NULL || b == NULL || out == NULL || out_len <= 0) {
        return NULL;
    }
    
    int a_len = strlen(a);
    int b_len = strlen(b);
    
    if (a_len + b_len + 1 > out_len) {
        return NULL;  /* Buffer too small */
    }
    
    strcpy(out, a);
    strcat(out, b);
    
    return out;
}

int str_count_char(const char *s, char c) {
    if (s == NULL) {
        return -1;
    }
    
    int count = 0;
    for (int i = 0; s[i] != '\0'; i++) {
        if (s[i] == c) {
            count++;
        }
    }
    
    return count;
}
