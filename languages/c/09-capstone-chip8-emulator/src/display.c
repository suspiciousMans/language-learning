#include "../include/display.h"
#include <string.h>
#include <stdio.h>

void chip8_clear_display(Chip8 *chip8) {
    if (chip8 == NULL) {
        return;
    }
    memset(chip8->display, 0, sizeof(chip8->display));
}

void chip8_set_pixel(Chip8 *chip8, int x, int y, int value) {
    if (chip8 == NULL) {
        return;
    }
    
    /* Handle wrapping */
    x = x % 64;
    y = y % 32;
    
    int pixel_index = y * 64 + x;
    int word_index = pixel_index / 32;
    int bit_index = pixel_index % 32;
    
    if (value) {
        chip8->display[word_index] |= (1U << bit_index);
    } else {
        chip8->display[word_index] &= ~(1U << bit_index);
    }
}

int chip8_get_pixel(Chip8 *chip8, int x, int y) {
    if (chip8 == NULL) {
        return 0;
    }
    
    /* Handle wrapping */
    x = x % 64;
    y = y % 32;
    
    int pixel_index = y * 64 + x;
    int word_index = pixel_index / 32;
    int bit_index = pixel_index % 32;
    
    return (chip8->display[word_index] >> bit_index) & 1;
}

void chip8_draw_sprite(Chip8 *chip8, int x, int y, const uint8_t *sprite, int height, int *collision) {
    if (chip8 == NULL || sprite == NULL || collision == NULL) {
        return;
    }
    
    *collision = 0;
    
    for (int row = 0; row < height; row++) {
        uint8_t byte = sprite[row];
        
        for (int col = 0; col < 8; col++) {
            int pixel = (byte >> (7 - col)) & 1;
            int px = x + col;
            int py = y + row;
            
            if (pixel) {
                int old_pixel = chip8_get_pixel(chip8, px, py);
                if (old_pixel) {
                    *collision = 1;
                }
                
                /* XOR the pixel */
                chip8_set_pixel(chip8, px, py, old_pixel ^ 1);
            }
        }
    }
}

void chip8_print_display(Chip8 *chip8) {
    if (chip8 == NULL) {
        return;
    }
    
    for (int y = 0; y < 32; y++) {
        for (int x = 0; x < 64; x++) {
            if (chip8_get_pixel(chip8, x, y)) {
                printf("#");
            } else {
                printf(".");
            }
        }
        printf("\n");
    }
}
