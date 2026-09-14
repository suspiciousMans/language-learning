#ifndef CALCULATOR_H
#define CALCULATOR_H

/* Function pointer for logging */
typedef void (*log_func)(const char *msg);

int add(int a, int b, log_func callback);
int divide(int a, int b, log_func callback);

#endif /* CALCULATOR_H */
