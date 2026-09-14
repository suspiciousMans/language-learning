#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * Exercise 4: Stream positioning and random access
 */

#define MAX_LINE_LEN 512

int file_size(const char *filename) {
    FILE *f = fopen(filename, "rb");
    if (f == NULL) {
        return -1;
    }
    
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fclose(f);
    
    return (int)size;
}

char* read_line_at_offset(const char *filename, long offset) {
    FILE *f = fopen(filename, "r");
    if (f == NULL) {
        return NULL;
    }
    
    if (fseek(f, offset, SEEK_SET) != 0) {
        fclose(f);
        return NULL;
    }
    
    char buffer[MAX_LINE_LEN];
    if (fgets(buffer, sizeof(buffer), f) == NULL) {
        fclose(f);
        return NULL;
    }
    
    fclose(f);
    
    char *result = malloc(strlen(buffer) + 1);
    if (result != NULL) {
        strcpy(result, buffer);
    }
    
    return result;
}

int main(void) {
    printf("=== Stream Positioning ===\n\n");
    
    /* Create a test file */
    FILE *f = fopen("positions.txt", "w");
    if (f == NULL) {
        perror("fopen");
        return 1;
    }
    
    fprintf(f, "Line 1\n");
    fprintf(f, "Line 2\n");
    fprintf(f, "Line 3\n");
    fprintf(f, "Line 4\n");
    fprintf(f, "Line 5\n");
    
    fclose(f);
    
    /* Test file_size */
    printf("File size: %d bytes\n\n", file_size("positions.txt"));
    
    /* Test reading at specific offsets */
    printf("Reading from different offsets:\n");
    long offsets[] = {0, 7, 14, 21, 28};
    
    for (int i = 0; i < 5; i++) {
        char *line = read_line_at_offset("positions.txt", offsets[i]);
        if (line != NULL) {
            printf("  Offset %ld: %s", offsets[i], line);
            free(line);
        } else {
            printf("  Offset %ld: (failed to read)\n", offsets[i]);
        }
    }
    
    /* Test seek and tell */
    printf("\nUsing fseek and ftell:\n");
    f = fopen("positions.txt", "r");
    if (f != NULL) {
        char line[MAX_LINE_LEN];
        
        printf("  Initial position: %ld\n", ftell(f));
        
        fgets(line, sizeof(line), f);
        printf("  After reading line 1, position: %ld\n", ftell(f));
        printf("  Line 1: %s", line);
        
        fseek(f, 0, SEEK_END);
        printf("  Seeked to end, position: %ld\n", ftell(f));
        
        rewind(f);
        printf("  After rewind, position: %ld\n", ftell(f));
        
        fclose(f);
    }
    
    remove("positions.txt");
    
    return 0;
}
