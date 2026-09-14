#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/*
 * Exercise 5: File statistics
 */

int count_lines(const char *filename) {
    if (filename == NULL) {
        return -1;
    }
    
    FILE *f = fopen(filename, "r");
    if (f == NULL) {
        return -1;
    }
    
    int count = 0;
    int c;
    
    while ((c = fgetc(f)) != EOF) {
        if (c == '\n') {
            count++;
        }
    }
    
    /* Handle file without trailing newline */
    if (ftell(f) > 0) {
        fseek(f, -1, SEEK_END);
        c = fgetc(f);
        if (c != '\n') {
            count++;
        }
    }
    
    if (ferror(f)) {
        perror("fgetc");
        fclose(f);
        return -1;
    }
    
    fclose(f);
    return count;
}

int count_words(const char *filename) {
    if (filename == NULL) {
        return -1;
    }
    
    FILE *f = fopen(filename, "r");
    if (f == NULL) {
        return -1;
    }
    
    int count = 0;
    int in_word = 0;
    int c;
    
    while ((c = fgetc(f)) != EOF) {
        if (isspace(c)) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            count++;
        }
    }
    
    if (ferror(f)) {
        perror("fgetc");
        fclose(f);
        return -1;
    }
    
    fclose(f);
    return count;
}

int count_chars(const char *filename, char c) {
    if (filename == NULL) {
        return -1;
    }
    
    FILE *f = fopen(filename, "r");
    if (f == NULL) {
        return -1;
    }
    
    int count = 0;
    int ch;
    
    while ((ch = fgetc(f)) != EOF) {
        if (ch == c) {
            count++;
        }
    }
    
    if (ferror(f)) {
        perror("fgetc");
        fclose(f);
        return -1;
    }
    
    fclose(f);
    return count;
}

void file_stats(const char *filename) {
    printf("=== File Statistics ===\n");
    printf("File: %s\n", filename);
    
    int lines = count_lines(filename);
    int words = count_words(filename);
    
    if (lines < 0 || words < 0) {
        printf("Error: could not read file\n");
        return;
    }
    
    printf("  Lines: %d\n", lines);
    printf("  Words: %d\n", words);
    printf("  Spaces: %d\n", count_chars(filename, ' '));
    printf("  Newlines: %d\n", count_chars(filename, '\n'));
}

int main(void) {
    printf("=== File Statistics ===\n\n");
    
    /* Create a test file */
    FILE *f = fopen("stats_test.txt", "w");
    if (f == NULL) {
        perror("fopen");
        return 1;
    }
    
    fprintf(f, "The quick brown fox\n");
    fprintf(f, "jumps over the lazy dog\n");
    fprintf(f, "Pack my box with five dozen liquor jugs\n");
    
    fclose(f);
    
    /* Display statistics */
    file_stats("stats_test.txt");
    
    remove("stats_test.txt");
    
    return 0;
}
