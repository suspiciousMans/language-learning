#include "calculator.h"
#include <stdio.h>
#include <stdlib.h>

int add(int a, int b, log_func callback) {
    int result = a + b;
    
    if (callback != NULL) {
        char msg[100];
        snprintf(msg, sizeof(msg), "add(%d, %d) = %d", a, b, result);
        callback(msg);
    }
    
    return result;
}

int divide(int a, int b, log_func callback) {
    if (b == 0) {
        if (callback != NULL) {
            callback("divide: division by zero");
        }
        return -1;
    }
    
    int result = a / b;
    
    if (callback != NULL) {
        char msg[100];
        snprintf(msg, sizeof(msg), "divide(%d, %d) = %d", a, b, result);
        callback(msg);
    }
    
    return result;
}
