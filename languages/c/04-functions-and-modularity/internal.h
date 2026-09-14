#ifndef INTERNAL_H
#define INTERNAL_H

/* Declare the variable defined in internal.c. 
 * NOTE: the static function 'helper' is NOT declared here — it is not
 * visible outside the translation unit that defines it. */

extern int counter;

int double_and_increment(void);

#endif /* INTERNAL_H */
