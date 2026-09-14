#include "chip8.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* Built-in font (16 characters, 5 bytes each) */
static const uint8_t chip8_font[] = {
    0xF0, 0x90, 0x90, 0x90, 0xF0,  /* 0 */
    0x20, 0x60, 0x20, 0x20, 0x70,  /* 1 */
    0xF0, 0x10, 0xF0, 0x80, 0xF0,  /* 2 */
    0xF0, 0x10, 0xF0, 0x10, 0xF0,  /* 3 */
    0x90, 0x90, 0xF0, 0x10, 0x10,  /* 4 */
    0xF0, 0x80, 0xF0, 0x10, 0xF0,  /* 5 */
    0xF0, 0x80, 0xF0, 0x90, 0xF0,  /* 6 */
    0xF0, 0x10, 0x20, 0x40, 0x40,  /* 7 */
    0xF0, 0x90, 0xF0, 0x90, 0xF0,  /* 8 */
    0xF0, 0x90, 0xF0, 0x10, 0xF0,  /* 9 */
    0xF0, 0x90, 0xF0, 0x90, 0x90,  /* A */
    0xE0, 0x90, 0xE0, 0x90, 0xE0,  /* B */
    0xF0, 0x80, 0x80, 0x80, 0xF0,  /* C */
    0xE0, 0x90, 0x90, 0x90, 0xE0,  /* D */
    0xF0, 0x80, 0xF0, 0x80, 0xF0,  /* E */
    0xF0, 0x80, 0xF0, 0x80, 0x80   /* F */
};

Chip8* chip8_create(void) {
    Chip8 *chip8 = malloc(sizeof(Chip8));
    if (chip8 == NULL) {
        return NULL;
    }
    
    memset(chip8->memory, 0, sizeof(chip8->memory));
    memset(chip8->registers, 0, sizeof(chip8->registers));
    memset(chip8->stack, 0, sizeof(chip8->stack));
    memset(chip8->display, 0, sizeof(chip8->display));
    memset(chip8->keyboard, 0, sizeof(chip8->keyboard));
    
    chip8->index = 0;
    chip8->pc = 0x200;  /* Programs start at 0x200 */
    chip8->sp = 0;
    chip8->delay_timer = 0;
    chip8->sound_timer = 0;
    
    /* Load built-in font at 0x000 */
    memcpy(chip8->memory, chip8_font, sizeof(chip8_font));
    
    return chip8;
}

void chip8_destroy(Chip8 *chip8) {
    if (chip8 != NULL) {
        free(chip8);
    }
}

int chip8_reset(Chip8 *chip8) {
    if (chip8 == NULL) {
        return -1;
    }
    
    memset(chip8->registers, 0, sizeof(chip8->registers));
    memset(chip8->stack, 0, sizeof(chip8->stack));
    memset(chip8->display, 0, sizeof(chip8->display));
    memset(chip8->keyboard, 0, sizeof(chip8->keyboard));
    
    chip8->index = 0;
    chip8->pc = 0x200;
    chip8->sp = 0;
    chip8->delay_timer = 0;
    chip8->sound_timer = 0;
    
    return 0;
}

int chip8_load_rom(Chip8 *chip8, const char *filename) {
    if (chip8 == NULL || filename == NULL) {
        return -1;
    }
    
    FILE *f = fopen(filename, "rb");
    if (f == NULL) {
        perror("fopen");
        return -1;
    }
    
    /* Seek to end to find file size */
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    rewind(f);
    
    /* Max ROM size: 4096 - 0x200 = 3840 bytes */
    if (size < 0 || size > 3840) {
        fprintf(stderr, "ROM size error: %ld bytes (max 3840)\n", size);
        fclose(f);
        return -1;
    }
    
    /* Read ROM into memory */
    if (fread(&chip8->memory[0x200], 1, size, f) != (size_t)size) {
        perror("fread");
        fclose(f);
        return -1;
    }
    
    fclose(f);
    chip8->pc = 0x200;  /* Reset PC to start of program */
    
    return 0;
}

uint16_t chip8_fetch(Chip8 *chip8) {
    if (chip8 == NULL) {
        return 0;
    }
    
    uint8_t high = chip8->memory[chip8->pc];
    uint8_t low = chip8->memory[chip8->pc + 1];
    
    return (high << 8) | low;
}

void chip8_execute(Chip8 *chip8, uint16_t opcode) {
    if (chip8 == NULL) {
        return;
    }
    
    uint8_t x = (opcode >> 8) & 0xF;
    uint8_t y = (opcode >> 4) & 0xF;
    uint8_t n = opcode & 0xF;
    uint8_t kk = opcode & 0xFF;
    uint16_t nnn = opcode & 0xFFF;
    
    switch (opcode >> 12) {
        case 0x0:
            if (opcode == 0x00E0) {
                /* 00E0: Clear display */
                memset(chip8->display, 0, sizeof(chip8->display));
            } else if (opcode == 0x00EE) {
                /* 00EE: Return from subroutine */
                if (chip8->sp > 0) {
                    chip8->sp--;
                    chip8->pc = chip8->stack[chip8->sp];
                }
            }
            break;
            
        case 0x1:
            /* 1NNN: Jump to NNN */
            chip8->pc = nnn;
            return;  /* Don't increment PC */
            
        case 0x2:
            /* 2NNN: Call subroutine at NNN */
            if (chip8->sp < 16) {
                chip8->stack[chip8->sp] = chip8->pc;
                chip8->sp++;
            }
            chip8->pc = nnn;
            return;
            
        case 0x3:
            /* 3XKK: Skip if VX == KK */
            if (chip8->registers[x] == kk) {
                chip8->pc += 2;
            }
            break;
            
        case 0x4:
            /* 4XKK: Skip if VX != KK */
            if (chip8->registers[x] != kk) {
                chip8->pc += 2;
            }
            break;
            
        case 0x5:
            /* 5XY0: Skip if VX == VY */
            if (chip8->registers[x] == chip8->registers[y]) {
                chip8->pc += 2;
            }
            break;
            
        case 0x6:
            /* 6XKK: Set VX = KK */
            chip8->registers[x] = kk;
            break;
            
        case 0x7:
            /* 7XKK: Add KK to VX */
            chip8->registers[x] += kk;
            break;
            
        case 0x8:
            switch (n) {
                case 0x0:
                    /* 8XY0: Set VX = VY */
                    chip8->registers[x] = chip8->registers[y];
                    break;
                case 0x4:
                    /* 8XY4: Add VY to VX */
                    {
                        uint16_t sum = chip8->registers[x] + chip8->registers[y];
                        chip8->registers[0xF] = (sum > 255) ? 1 : 0;
                        chip8->registers[x] = sum & 0xFF;
                    }
                    break;
            }
            break;
            
        case 0xA:
            /* ANNN: Set I = NNN */
            chip8->index = nnn;
            break;
            
        case 0xF:
            switch (kk) {
                case 0x07:
                    /* FX07: Set VX = delay_timer */
                    chip8->registers[x] = chip8->delay_timer;
                    break;
                case 0x15:
                    /* FX15: Set delay_timer = VX */
                    chip8->delay_timer = chip8->registers[x];
                    break;
                case 0x18:
                    /* FX18: Set sound_timer = VX */
                    chip8->sound_timer = chip8->registers[x];
                    break;
            }
            break;
    }
    
    /* Increment PC */
    chip8->pc += 2;
}

void chip8_cycle(Chip8 *chip8) {
    if (chip8 == NULL) {
        return;
    }
    
    /* Fetch, decode, and execute */
    uint16_t opcode = chip8_fetch(chip8);
    chip8_execute(chip8, opcode);
    
    /* Update timers */
    if (chip8->delay_timer > 0) {
        chip8->delay_timer--;
    }
    if (chip8->sound_timer > 0) {
        chip8->sound_timer--;
    }
}
