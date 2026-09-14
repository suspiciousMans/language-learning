#include "test_framework.h"
#include "calculator.h"
#include <stdlib.h>
#include <string.h>

/*
 * Exercise 5: Mocking and dependency injection
 * 
 * Mock log function to verify behavior.
 */

typedef struct {
    char *messages[20];
    int count;
} MockLog;

MockLog mock_log;

void mock_log_callback(const char *msg) {
    if (mock_log.count < 20) {
        mock_log.messages[mock_log.count] = malloc(strlen(msg) + 1);
        strcpy(mock_log.messages[mock_log.count], msg);
        mock_log.count++;
    }
}

void reset_mock_log(void) {
    for (int i = 0; i < mock_log.count; i++) {
        free(mock_log.messages[i]);
    }
    mock_log.count = 0;
}

int main(void) {
    printf("=== Calculator Tests with Mocking ===\n\n");
    
    /* Test add with mock callback */
    TEST_START("calculator: add with logging");
    {
        reset_mock_log();
        int result = add(5, 3, mock_log_callback);
        
        ASSERT_EQ(8, result);
        ASSERT_EQ(1, mock_log.count);
        ASSERT_STR_EQ("add(5, 3) = 8", mock_log.messages[0]);
    }
    TEST_END();
    
    TEST_START("calculator: add without callback");
    {
        int result = add(10, 20, NULL);
        ASSERT_EQ(30, result);
    }
    TEST_END();
    
    TEST_START("calculator: add with negative numbers");
    {
        reset_mock_log();
        int result = add(-5, 8, mock_log_callback);
        
        ASSERT_EQ(3, result);
        ASSERT_EQ(1, mock_log.count);
        ASSERT_STR_EQ("add(-5, 8) = 3", mock_log.messages[0]);
    }
    TEST_END();
    
    /* Test divide with mock callback */
    TEST_START("calculator: divide with logging");
    {
        reset_mock_log();
        int result = divide(20, 5, mock_log_callback);
        
        ASSERT_EQ(4, result);
        ASSERT_EQ(1, mock_log.count);
        ASSERT_STR_EQ("divide(20, 5) = 4", mock_log.messages[0]);
    }
    TEST_END();
    
    TEST_START("calculator: divide by zero");
    {
        reset_mock_log();
        int result = divide(10, 0, mock_log_callback);
        
        ASSERT_EQ(-1, result);
        ASSERT_EQ(1, mock_log.count);
        ASSERT_STR_EQ("divide: division by zero", mock_log.messages[0]);
    }
    TEST_END();
    
    TEST_START("calculator: divide by zero without callback");
    {
        int result = divide(10, 0, NULL);
        ASSERT_EQ(-1, result);
    }
    TEST_END();
    
    /* Clean up */
    reset_mock_log();
    
    TEST_REPORT();
}
