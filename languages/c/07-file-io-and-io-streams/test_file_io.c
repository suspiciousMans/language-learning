#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

/*
 * Exercise 6: Unit tests for file I/O
 */

#define MAX_LINE_LEN 256
#define MAX_LINES 100

typedef struct {
    int id;
    char name[50];
    float score;
} Record;

/* Forward declarations */
int read_lines(const char *filename, char **lines, int max_lines);
int write_lines(const char *filename, const char **lines, int count);
int write_records(const char *filename, Record *records, int count);
int read_records(const char *filename, Record **records, int *count);

/* Implementations */
int read_lines(const char *filename, char **lines, int max_lines) {
    if (filename == NULL || lines == NULL || max_lines <= 0) {
        return -1;
    }
    
    FILE *f = fopen(filename, "r");
    if (f == NULL) {
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
    
    fclose(f);
    return count;
}

int write_lines(const char *filename, const char **lines, int count) {
    if (filename == NULL || lines == NULL || count < 0) {
        return -1;
    }
    
    FILE *f = fopen(filename, "w");
    if (f == NULL) {
        return -1;
    }
    
    for (int i = 0; i < count; i++) {
        if (fputs(lines[i], f) == EOF) {
            fclose(f);
            return -1;
        }
    }
    
    fclose(f);
    return 0;
}

int write_records(const char *filename, Record *records, int count) {
    if (filename == NULL || records == NULL || count < 0) {
        return -1;
    }
    
    FILE *f = fopen(filename, "wb");
    if (f == NULL) {
        return -1;
    }
    
    if (fwrite(records, sizeof(Record), count, f) != (size_t)count) {
        fclose(f);
        return -1;
    }
    
    fclose(f);
    return 0;
}

int read_records(const char *filename, Record **records, int *count) {
    if (filename == NULL || records == NULL || count == NULL) {
        return -1;
    }
    
    FILE *f = fopen(filename, "rb");
    if (f == NULL) {
        return -1;
    }
    
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    rewind(f);
    
    if (size % sizeof(Record) != 0) {
        fclose(f);
        return -1;
    }
    
    *count = size / sizeof(Record);
    *records = malloc(size);
    if (*records == NULL) {
        fclose(f);
        return -1;
    }
    
    if (fread(*records, sizeof(Record), *count, f) != (size_t)(*count)) {
        free(*records);
        *records = NULL;
        fclose(f);
        return -1;
    }
    
    fclose(f);
    return 0;
}

/* Test functions */
int test_read_lines() {
    printf("[TEST] read_lines: ");
    
    const char *test_lines[] = {"Line 1\n", "Line 2\n"};
    write_lines("test_read.txt", test_lines, 2);
    
    char *lines[10];
    int count = read_lines("test_read.txt", lines, 10);
    
    int pass = (count == 2 && strcmp(lines[0], "Line 1\n") == 0);
    
    for (int i = 0; i < count; i++) {
        free(lines[i]);
    }
    remove("test_read.txt");
    
    printf("%s\n", pass ? "PASSED" : "FAILED");
    return pass ? 0 : 1;
}

int test_write_lines() {
    printf("[TEST] write_lines: ");
    
    const char *lines[] = {"Test line\n"};
    int result = write_lines("test_write.txt", lines, 1);
    
    FILE *f = fopen("test_write.txt", "r");
    int pass = (result == 0 && f != NULL);
    
    if (f != NULL) {
        fclose(f);
    }
    remove("test_write.txt");
    
    printf("%s\n", pass ? "PASSED" : "FAILED");
    return pass ? 0 : 1;
}

int test_binary_io() {
    printf("[TEST] binary I/O: ");
    
    Record recs[] = {{1, "Alice", 95.5}, {2, "Bob", 87.0}};
    write_records("test_bin.bin", recs, 2);
    
    Record *read_recs;
    int count;
    read_records("test_bin.bin", &read_recs, &count);
    
    int pass = (count == 2 && read_recs[0].id == 1);
    
    free(read_recs);
    remove("test_bin.bin");
    
    printf("%s\n", pass ? "PASSED" : "FAILED");
    return pass ? 0 : 1;
}

int test_nonexistent_file() {
    printf("[TEST] nonexistent file error handling: ");
    
    char *lines[10];
    int count = read_lines("nonexistent.txt", lines, 10);
    
    int pass = (count == -1);
    
    printf("%s\n", pass ? "PASSED" : "FAILED");
    return pass ? 0 : 1;
}

int main(void) {
    printf("=== File I/O Tests ===\n\n");
    
    int failures = 0;
    
    failures += test_read_lines();
    failures += test_write_lines();
    failures += test_binary_io();
    failures += test_nonexistent_file();
    
    printf("\n=== Test Summary ===\n");
    printf("Tests: 4\n");
    printf("Passed: %d\n", 4 - failures);
    printf("Failed: %d\n", failures);
    
    return failures > 0 ? 1 : 0;
}
