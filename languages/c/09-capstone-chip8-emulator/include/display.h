#ifndef DISPLAY_H
#define DISPLAY_H

#include "chip8.h"

/* Display operations */
void chip8_clear_display(Chip8 *chip8);
void chip8_set_pixel(Chip8 *chip8, int x, int y, int value);
int chip8_get_pixel(Chip8 *chip8, int x, int y);
void chip8_draw_sprite(Chip8 *chip8, int x, int y, const uint8_t *sprite, int height, int *collision);
void chip8_print_display(Chip8 *chip8);

#endif /* DISPLAY_H */
