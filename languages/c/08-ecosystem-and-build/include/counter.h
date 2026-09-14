#ifndef COUNTER_H
#define COUNTER_H

/* Opaque pointer to Counter structure */
typedef struct Counter Counter;

Counter* counter_create(int initial);
void counter_destroy(Counter *c);
void counter_increment(Counter *c);
void counter_decrement(Counter *c);
int counter_value(Counter *c);

#endif /* COUNTER_H */
