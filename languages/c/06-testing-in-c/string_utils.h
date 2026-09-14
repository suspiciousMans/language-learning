#ifndef STRING_UTILS_H
#define STRING_UTILS_H

/* String utility functions */

int str_equals(const char *a, const char *b);
char* str_concat(const char *a, const char *b, char *out, int out_len);
int str_count_char(const char *s, char c);

#endif /* STRING_UTILS_H */
