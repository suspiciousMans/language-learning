#include "../include/chip8.h"
#include "../include/display.h"
#include <stdio.h>
#include <assert.h>

int main(void) {
    printf("=== CHIP-8 Emulator Test ===\n\n");
    
    /* Test 1: Create and destroy */
    printf("Test 1: Create and destroy...\n");
    Chip8 *chip8 = chip8_create();
    assert(chip8 != NULL);
    assert(chip8->pc == 0x200);
    assert(chip8->sp == 0);
    printf("  PASSED\n\n");
    
    /* Test 2: Load font */
    printf("Test 2: Built-in font...\n");
    assert(chip8->memory[0] == 0xF0);  /* First byte of '0' font */
    printf("  PASSED\n\n");
    
    /* Test 3: Reset */
    printf("Test 3: Reset...\n");
    chip8->pc = 0x500;
    chip8->registers[0] = 42;
    int res = chip8_reset(chip8);
    assert(res == 0);
    assert(chip8->pc == 0x200);
    assert(chip8->registers[0] == 0);
    printf("  PASSED\n\n");
    
    /* Test 4: Display operations */
    printf("Test 4: Display operations...\n");
    chip8_clear_display(chip8);
    chip8_set_pixel(chip8, 0, 0, 1);
    assert(chip8_get_pixel(chip8, 0, 0) == 1);
    chip8_set_pixel(chip8, 0, 0, 0);
    assert(chip8_get_pixel(chip8, 0, 0) == 0);
    printf("  PASSED\n\n");
    
    /* Test 5: Basic opcodes */
    printf("Test 5: Basic opcodes...\n");
    
    /* 6XKK: Set VX = KK */
    chip8->pc = 0x200;
    chip8_execute(chip8, 0x6555);  /* V5 = 0x55 */
    assert(chip8->registers[5] == 0x55);
    printf("  6XKK (Set register): PASSED\n");
    
    /* 7XKK: Add KK to VX */
    chip8->pc = 0x200;
    chip8->registers[3] = 10;
    chip8_execute(chip8, 0x7320);  /* V3 += 0x20 */
    assert(chip8->registers[3] == 10 + 0x20);
    printf("  7XKK (Add to register): PASSED\n");
    
    /* 8XY0: Set VX = VY */
    chip8->pc = 0x200;
    chip8->registers[1] = 42;
    chip8->registers[2] = 0;
    chip8_execute(chip8, 0x8120);  /* V1 = V2 */
    assert(chip8->registers[1] == chip8->registers[2]);
    printf("  8XY0 (Copy register): PASSED\n");
    
    /* ANNN: Set I = NNN */
    chip8->pc = 0x200;
    chip8_execute(chip8, 0xA234);  /* I = 0x234 */
    assert(chip8->index == 0x234);
    printf("  ANNN (Set index): PASSED\n");
    
    printf("\nTest 6: Jump opcodes...\n");
    
    /* 1NNN: Jump to NNN */
    chip8->pc = 0x200;
    chip8_execute(chip8, 0x1300);  /* Jump to 0x300 */
    assert(chip8->pc == 0x300);
    printf("  1NNN (Jump): PASSED\n");
    
    /* 2NNN / 00EE: Call and return */
    chip8->pc = 0x200;
    chip8->sp = 0;
    chip8_execute(chip8, 0x2400);  /* Call 0x400 */
    assert(chip8->pc == 0x400);
    assert(chip8->sp == 1);
    assert(chip8->stack[0] == 0x200);
    printf("  2NNN (Call): PASSED\n");
    
    chip8->pc = 0x400;
    chip8_execute(chip8, 0x00EE);  /* Return */
    assert(chip8->pc == 0x202);  /* Returns to 0x200 + 2 */
    assert(chip8->sp == 0);
    printf("  00EE (Return): PASSED\n");
    
    printf("\nTest 7: Skip opcodes...\n");
    
    /* 3XKK: Skip if VX == KK */
    chip8->pc = 0x200;
    chip8->registers[4] = 0x42;
    chip8_execute(chip8, 0x3442);  /* Skip if V4 == 0x42 */
    assert(chip8->pc == 0x204);  /* Skipped */
    printf("  3XKK (Skip if equal): PASSED\n");
    
    /* 4XKK: Skip if VX != KK */
    chip8->pc = 0x200;
    chip8->registers[5] = 0x42;
    chip8_execute(chip8, 0x4543);  /* Skip if V5 != 0x43 */
    assert(chip8->pc == 0x204);  /* Skipped */
    printf("  4XKK (Skip if not equal): PASSED\n");
    
    printf("\nTest 8: Timer operations...\n");
    
    /* FX15: Set delay_timer = VX */
    chip8->pc = 0x200;
    chip8->registers[7] = 30;
    chip8_execute(chip8, 0xF715);
    assert(chip8->delay_timer == 30);
    printf("  FX15 (Set delay timer): PASSED\n");
    
    /* FX07: Get delay_timer */
    chip8->pc = 0x200;
    chip8->registers[8] = 0;
    chip8_execute(chip8, 0xF807);
    assert(chip8->registers[8] == 30);
    printf("  FX07 (Get delay timer): PASSED\n");
    
    chip8_destroy(chip8);
    
    printf("\n=== All tests passed! ===\n");
    return 0;
}
