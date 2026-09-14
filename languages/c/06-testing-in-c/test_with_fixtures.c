#include "test_framework.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * Exercise 4: Fixture-based tests
 * 
 * Demonstrate setup/teardown with a file fixture.
 */

typedef struct {
    FILE *file;
    char *filename;
} FileFixture;

/* Setup: create a temporary test file */
FileFixture* fixture_setup(const char *filename, const char *content) {
    FileFixture *f = malloc(sizeof(FileFixture));
    f->filename = malloc(strlen(filename) + 1);
    strcpy(f->filename, filename);
    
    f->file = fopen(filename, "w");
    if (f->file != NULL && content != NULL) {
        fprintf(f->file, "%s", content);
        fclose(f->file);
        f->file = NULL;  /* Mark as closed */
    }
    
    return f;
}

/* Teardown: close and delete the file */
void fixture_teardown(FileFixture *f) {
    if (f != NULL) {
        if (f->file != NULL) {
            fclose(f->file);
        }
        remove(f->filename);
        free(f->filename);
        free(f);
    }
}

int main(void) {
    printf("=== Fixture-Based Tests ===\n\n");
    
    /* Test 1: Create and read from a file */
    TEST_START("fixture: create and read file");
    {
        FileFixture *f = fixture_setup("test_file_1.txt", "Hello, World!");
        
        FILE *in = fopen(f->filename, "r");
        ASSERT_TRUE(in != NULL);
        
        char buffer[100];
        if (fgets(buffer, sizeof(buffer), in) != NULL) {
            ASSERT_STR_EQ("Hello, World!", buffer);
        }
        
        fclose(in);
        fixture_teardown(f);
    }
    TEST_END();
    
    /* Test 2: Empty file */
    TEST_START("fixture: empty file");
    {
        FileFixture *f = fixture_setup("test_file_2.txt", "");
        
        FILE *in = fopen(f->filename, "r");
        ASSERT_TRUE(in != NULL);
        
        char buffer[100];
        char *result = fgets(buffer, sizeof(buffer), in);
        ASSERT_EQ(0, (result != NULL ? 1 : 0));  /* Should be EOF */
        
        fclose(in);
        fixture_teardown(f);
    }
    TEST_END();
    
    /* Test 3: Multiple lines */
    TEST_START("fixture: multi-line file");
    {
        FileFixture *f = fixture_setup("test_file_3.txt", "Line1\nLine2\nLine3");
        
        FILE *in = fopen(f->filename, "r");
        ASSERT_TRUE(in != NULL);
        
        char buffer[100];
        int line_count = 0;
        while (fgets(buffer, sizeof(buffer), in) != NULL) {
            line_count++;
        }
        ASSERT_EQ(3, line_count);
        
        fclose(in);
        fixture_teardown(f);
    }
    TEST_END();
    
    /* Test 4: Fixture with NULL content */
    TEST_START("fixture: null content");
    {
        FileFixture *f = fixture_setup("test_file_4.txt", NULL);
        ASSERT_TRUE(f != NULL);
        fixture_teardown(f);
    }
    TEST_END();
    
    TEST_REPORT();
}
