#include "test_framework.h"
#include "string_utils.h"

int main(void) {
    printf("=== String Utils Tests ===\n\n");
    
    /* Test str_equals */
    TEST_START("str_equals: equal strings");
    ASSERT_EQ(1, str_equals("hello", "hello"));
    TEST_END();
    
    TEST_START("str_equals: different strings");
    ASSERT_EQ(0, str_equals("hello", "world"));
    TEST_END();
    
    TEST_START("str_equals: empty strings");
    ASSERT_EQ(1, str_equals("", ""));
    TEST_END();
    
    TEST_START("str_equals: single character");
    ASSERT_EQ(1, str_equals("a", "a"));
    TEST_END();
    
    /* Test str_concat */
    char buffer[50];
    
    TEST_START("str_concat: simple concatenation");
    {
        char *result = str_concat("Hello", " World", buffer, sizeof(buffer));
        ASSERT_TRUE(result != NULL);
        ASSERT_STR_EQ("Hello World", buffer);
    }
    TEST_END();
    
    TEST_START("str_concat: empty strings");
    str_concat("", "", buffer, sizeof(buffer));
    ASSERT_STR_EQ("", buffer);
    TEST_END();
    
    TEST_START("str_concat: one empty string");
    str_concat("test", "", buffer, sizeof(buffer));
    ASSERT_STR_EQ("test", buffer);
    TEST_END();
    
    TEST_START("str_concat: buffer overflow");
    {
        char small_buffer[5];
        char *result = str_concat("hello", "world", small_buffer, sizeof(small_buffer));
        ASSERT_EQ(0, (result != NULL ? 1 : 0));  /* Should fail */
    }
    TEST_END();
    
    /* Test str_count_char */
    TEST_START("str_count_char: found characters");
    ASSERT_EQ(2, str_count_char("hello", 'l'));
    TEST_END();
    
    TEST_START("str_count_char: no occurrences");
    ASSERT_EQ(0, str_count_char("hello", 'x'));
    TEST_END();
    
    TEST_START("str_count_char: single character");
    ASSERT_EQ(1, str_count_char("hello", 'h'));
    TEST_END();
    
    TEST_START("str_count_char: empty string");
    ASSERT_EQ(0, str_count_char("", 'a'));
    TEST_END();
    
    TEST_START("str_count_char: all same character");
    ASSERT_EQ(5, str_count_char("aaaaa", 'a'));
    TEST_END();
    
    TEST_REPORT();
}
