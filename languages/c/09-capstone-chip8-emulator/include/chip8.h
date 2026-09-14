#ifndef CHIP8_H
#define CHIP8_H

#include <stdint.h>
#include <stddef.h>

/* CHIP-8 CPU structure */
typedef struct {
    uint8_t memory[4096];              /* 4 KB of RAM */
    uint8_t registers[16];             /* V0-VF */
    uint16_t index;                    /* I register */
    uint16_t pc;                       /* Program counter */
    uint8_t sp;                        /* Stack pointer */
    uint16_t stack[16];                /* 16-level call stack */
    uint8_t delay_timer;               /* Delay timer */
    uint8_t sound_timer;               /* Sound timer */
    uint32_t display[2048];            /* 64x32 display (1 bit per pixel) */
    uint8_t keyboard[16];              /* Keyboard state (0-F) */
} Chip8;

/* Lifecycle management */
Chip8* chip8_create(void);
void chip8_destroy(Chip8 *chip8);
int chip8_reset(Chip8 *chip8);

/* ROM loading */
int chip8_load_rom(Chip8 *chip8, const char *filename);

/* CPU execution */
void chip8_cycle(Chip8 *chip8);
uint16_t chip8_fetch(Chip8 *chip8);
void chip8_execute(Chip8 *chip8, uint16_t opcode);

#endif /* CHIP8_H */
