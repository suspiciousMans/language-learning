#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * Exercise 1: Text file read and write
 */

#define MAX_LINE_LEN 256
#define MAX_LINES 100

int read_lines(const char *filename, char **lines, int max_lines) {
    if (filename == NULL || lines == NULL || max_lines <= 0) {
        return -1;
    }
    
    FILE *f = fopen(filename, "r");
    if (f == NULL) {
        perror("fopen");
        return -1;
    }
    
    int count = 0;
    char buffer[MAX_LINE_LEN];
    
    while (count < max_lines && fgets(buffer, sizeof(buffer), f) != NULL) {
        int len = strlen(buffer);
        lines[count] = malloc(len + 1);
        if (lines[count] == NULL) {
            fclose(f);
            return -1;
        }
        strcpy(lines[count], buffer);
        count++;
    }
    
    if (ferror(f)) {
        perror("fgets");
        fclose(f);
        return -1;
    }
    
    fclose(f);
    return count;
}

int write_lines(const char *filename, const char **lines, int count) {
    if (filename == NULL || lines == NULL || count < 0) {
        return -1;
    }
    
    FILE *f = fopen(filename, "w");
    if (f == NULL) {
        perror("fopen");
        return -1;
    }
    
    for (int i = 0; i < count; i++) {
        if (fputs(lines[i], f) == EOF) {
            perror("fputs");
            fclose(f);
            return -1;
        }
    }
    
    if (fclose(f) == EOF) {
        perror("fclose");
        return -1;
    }
    
    return 0;
}

int main(void) {
    printf("=== Text File I/O ===\n\n");
    
    /* Create a test file */
    const char *test_lines[] = {
        "Line 1: Hello\n",
        "Line 2: World\n",
        "Line 3: Testing file I/O\n",
    };
    
    printf("Writing test file...\n");
    if (write_lines("test_input.txt", test_lines, 3) != 0) {
        fprintf(stderr, "Failed to write test file\n");
        return 1;
    }
    
    /* Read the file back */
    printf("Reading test file...\n");
    char *lines[MAX_LINES];
    int num_lines = read_lines("test_input.txt", lines, MAX_LINES);
    
    if (num_lines < 0) {
        fprintf(stderr, "Failed to read test file\n");
        return 1;
    }
    
    printf("Read %d lines:\n", num_lines);
    for (int i = 0; i < num_lines; i++) {
        printf("  %d: %s", i + 1, lines[i]);
    }
    
    /* Modify and write to a new file */
    printf("\nWriting modified lines to output file...\n");
    char *modified_lines[MAX_LINES];
    for (int i = 0; i < num_lines; i++) {
        int len = strlen(lines[i]) + 20;
        modified_lines[i] = malloc(len);
        snprintf(modified_lines[i], len, "[%d] %s", i + 1, lines[i]);
    }
    
    if (write_lines("test_output.txt", (const char **)modified_lines, num_lines) != 0) {
        fprintf(stderr, "Failed to write output file\n");
        return 1;
    }
    
    printf("Output written to test_output.txt\n");
    
    /* Clean up */
    for (int i = 0; i < num_lines; i++) {
        free(lines[i]);
        free(modified_lines[i]);
    }
    
    /* Clean up test files */
    remove("test_input.txt");
    remove("test_output.txt");
    
    return 0;
}
