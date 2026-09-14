#include "../include/counter.h"
#include <stdlib.h>

/* Opaque structure - hidden from the client */
struct Counter {
    int value;
};

Counter* counter_create(int initial) {
    Counter *c = malloc(sizeof(Counter));
    if (c != NULL) {
        c->value = initial;
    }
    return c;
}

void counter_destroy(Counter *c) {
    if (c != NULL) {
        free(c);
    }
}

void counter_increment(Counter *c) {
    if (c != NULL) {
        c->value++;
    }
}

void counter_decrement(Counter *c) {
    if (c != NULL) {
        c->value--;
    }
}

int counter_value(Counter *c) {
    if (c != NULL) {
        return c->value;
    }
    return 0;
}
