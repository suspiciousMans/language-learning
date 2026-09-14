#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/*
 * Exercise 3: CSV parser
 */

#define MAX_FIELD_LEN 256

int parse_csv_line(const char *line, char **fields, int max_fields) {
    if (line == NULL || fields == NULL || max_fields <= 0) {
        return -1;
    }
    
    int field_count = 0;
    const char *p = line;
    char buffer[MAX_FIELD_LEN];
    int buf_idx = 0;
    int in_quotes = 0;
    
    while (*p != '\0' && *p != '\n' && field_count < max_fields) {
        if (*p == '"') {
            in_quotes = !in_quotes;
            p++;
        } else if (*p == ',' && !in_quotes) {
            buffer[buf_idx] = '\0';
            
            /* Trim whitespace */
            int start = 0, end = buf_idx - 1;
            while (start <= end && isspace(buffer[start])) start++;
            while (end >= start && isspace(buffer[end])) end--;
            
            int len = end - start + 1;
            fields[field_count] = malloc(len + 1);
            if (fields[field_count] == NULL) {
                return -1;
            }
            if (len > 0) {
                strncpy(fields[field_count], buffer + start, len);
            }
            fields[field_count][len] = '\0';
            
            field_count++;
            buf_idx = 0;
            p++;
        } else {
            if (buf_idx < MAX_FIELD_LEN - 1) {
                buffer[buf_idx++] = *p;
            }
            p++;
        }
    }
    
    /* Add last field */
    if (field_count < max_fields) {
        buffer[buf_idx] = '\0';
        
        /* Trim whitespace */
        int start = 0, end = buf_idx - 1;
        while (start <= end && isspace(buffer[start])) start++;
        while (end >= start && isspace(buffer[end])) end--;
        
        int len = end - start + 1;
        fields[field_count] = malloc(len + 1);
        if (fields[field_count] == NULL) {
            return -1;
        }
        if (len > 0) {
            strncpy(fields[field_count], buffer + start, len);
        }
        fields[field_count][len] = '\0';
        
        field_count++;
    }
    
    return field_count;
}

int main(void) {
    printf("=== CSV Parser ===\n\n");
    
    /* Create a test CSV file */
    FILE *f = fopen("test.csv", "w");
    if (f == NULL) {
        perror("fopen");
        return 1;
    }
    
    fprintf(f, "Name, Age, City\n");
    fprintf(f, "Alice, 25, New York\n");
    fprintf(f, "Bob, 30, \"Los Angeles, CA\"\n");
    fprintf(f, "Charlie, 28, Chicago\n");
    
    fclose(f);
    
    /* Parse the CSV file */
    f = fopen("test.csv", "r");
    if (f == NULL) {
        perror("fopen");
        return 1;
    }
    
    char line[512];
    int line_num = 0;
    
    while (fgets(line, sizeof(line), f) != NULL) {
        line_num++;
        printf("Line %d: ", line_num);
        
        char *fields[10];
        int field_count = parse_csv_line(line, fields, 10);
        
        if (field_count < 0) {
            printf("ERROR parsing line\n");
        } else {
            printf("%d fields: ", field_count);
            for (int i = 0; i < field_count; i++) {
                printf("[%s]%s", fields[i], (i < field_count - 1) ? " | " : "");
                free(fields[i]);
            }
            printf("\n");
        }
    }
    
    fclose(f);
    remove("test.csv");
    
    return 0;
}
