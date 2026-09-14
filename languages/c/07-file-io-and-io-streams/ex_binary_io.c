#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * Exercise 2: Binary file I/O
 */

typedef struct {
    int id;
    char name[50];
    float score;
} Record;

int write_records(const char *filename, Record *records, int count) {
    if (filename == NULL || records == NULL || count < 0) {
        return -1;
    }
    
    FILE *f = fopen(filename, "wb");
    if (f == NULL) {
        perror("fopen");
        return -1;
    }
    
    if (fwrite(records, sizeof(Record), count, f) != (size_t)count) {
        perror("fwrite");
        fclose(f);
        return -1;
    }
    
    if (fclose(f) == EOF) {
        perror("fclose");
        return -1;
    }
    
    return 0;
}

int read_records(const char *filename, Record **records, int *count) {
    if (filename == NULL || records == NULL || count == NULL) {
        return -1;
    }
    
    FILE *f = fopen(filename, "rb");
    if (f == NULL) {
        perror("fopen");
        return -1;
    }
    
    /* Seek to end to find file size */
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    rewind(f);
    
    if (size % sizeof(Record) != 0) {
        fprintf(stderr, "File size is not a multiple of Record size\n");
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
        perror("fread");
        free(*records);
        *records = NULL;
        fclose(f);
        return -1;
    }
    
    if (fclose(f) == EOF) {
        perror("fclose");
        return -1;
    }
    
    return 0;
}

int main(void) {
    printf("=== Binary File I/O ===\n\n");
    
    /* Create test records */
    Record test_records[] = {
        {1, "Alice", 95.5},
        {2, "Bob", 87.3},
        {3, "Charlie", 92.1},
    };
    int test_count = 3;
    
    printf("Writing %d records to binary file...\n", test_count);
    if (write_records("records.bin", test_records, test_count) != 0) {
        fprintf(stderr, "Failed to write records\n");
        return 1;
    }
    
    /* Read back */
    printf("Reading records from binary file...\n");
    Record *read_records_ptr;
    int read_count;
    
    if (read_records("records.bin", &read_records_ptr, &read_count) != 0) {
        fprintf(stderr, "Failed to read records\n");
        return 1;
    }
    
    printf("Read %d records:\n", read_count);
    for (int i = 0; i < read_count; i++) {
        printf("  ID: %d, Name: %s, Score: %.1f\n",
               read_records_ptr[i].id,
               read_records_ptr[i].name,
               read_records_ptr[i].score);
    }
    
    /* Verify */
    int mismatch = 0;
    if (read_count != test_count) {
        printf("ERROR: Record count mismatch\n");
        mismatch = 1;
    } else {
        for (int i = 0; i < read_count; i++) {
            if (read_records_ptr[i].id != test_records[i].id ||
                strcmp(read_records_ptr[i].name, test_records[i].name) != 0 ||
                read_records_ptr[i].score != test_records[i].score) {
                printf("ERROR: Record %d mismatch\n", i);
                mismatch = 1;
            }
        }
    }
    
    if (!mismatch) {
        printf("\nRecords verified successfully!\n");
    }
    
    free(read_records_ptr);
    remove("records.bin");
    
    return mismatch ? 1 : 0;
}
