# Project 09: CHIP-8 Emulator (Capstone Project)

**Difficulty:** advanced
**Prerequisites:** projects 01-08 (all previous projects)

## Goals

- Build a fully functional CHIP-8 interpreter/emulator.
- Apply all C knowledge: memory management, modularity, error handling, testing, file I/O, and build systems.
- Understand low-level concepts: registers, memory layout, instruction decoding, and CPU cycles.
- Implement complex logic: instruction fetch-decode-execute, stack management, and timers.
- Use proper software engineering: modular design, comprehensive testing, and documentation.

## Concepts

- **CHIP-8:** An interpreted programming language from the 1970s designed to run on 8-bit computers.
- **Architecture:**
  - 4 KB (4096 bytes) of RAM
  - 16 general-purpose registers (V0-VF)
  - Program counter (PC), stack pointer (SP), index register (I)
  - Delay timer and sound timer
  - Display: 64x32 pixels (monochrome)
- **Instructions:** 35 opcodes, each 2 bytes, starting at memory address 0x200.
- **Fetch-Decode-Execute:** Standard CPU cycle model.
- **Stack:** 16-level stack for subroutine calls.
- **Graphics:** Simple pixel buffer for 64x32 display.

## Completion checklist

- [ ] Understand CHIP-8 architecture and opcode specifications.
- [ ] Implement the 16 registers and memory (4 KB).
- [ ] Implement the stack (16 levels).
- [ ] Decode and execute all 35 CHIP-8 opcodes.
- [ ] Implement the fetch-decode-execute cycle.
- [ ] Implement display buffer (64x32 pixels).
- [ ] Handle timers (delay and sound).
- [ ] Implement keyboard input (16 keys: 0-9, A-F).
- [ ] Load CHIP-8 ROM files from disk.
- [ ] Create a simple text-based or SDL-based display.
- [ ] Write comprehensive unit tests for individual opcodes.
- [ ] Create a test ROM loader and runner.
- [ ] Document the emulator architecture and opcode reference.

## Exercises

### Exercise 1: CHIP-8 architecture and data structures

File: `include/chip8.h`, `src/chip8.c`

Define core structures:
```c
typedef struct {
    uint8_t memory[4096];           /* 4 KB of RAM */
    uint8_t registers[16];          /* V0-VF */
    uint16_t index;                 /* I register */
    uint16_t pc;                    /* Program counter */
    uint8_t sp;                     /* Stack pointer */
    uint16_t stack[16];             /* 16-level stack */
    uint8_t delay_timer;            /* Delay timer */
    uint8_t sound_timer;            /* Sound timer */
    uint32_t display[64 * 32 / 32]; /* 64x32 display (packed bits) */
    uint8_t keyboard[16];           /* Keyboard state (0-F) */
} Chip8;
```

Implement functions:
- `Chip8* chip8_create(void)`: allocate and initialize.
- `void chip8_destroy(Chip8 *chip8)`: free memory.
- `int chip8_load_rom(Chip8 *chip8, const char *filename)`: load a ROM file into memory starting at 0x200.
- `void chip8_reset(Chip8 *chip8)`: reset to initial state.

### Exercise 2: Fetch-Decode-Execute cycle

File: `src/cpu.c`, `include/cpu.h`

Implement:
- `uint16_t chip8_fetch(Chip8 *chip8)`: fetch next 2-byte opcode from memory at PC.
- `void chip8_execute(Chip8 *chip8, uint16_t opcode)`: decode and execute the opcode.
- `void chip8_cycle(Chip8 *chip8)`: one full CPU cycle (fetch, decode, execute).
- Timer update: decrement `delay_timer` and `sound_timer` each cycle (max 60 Hz or similar).

### Exercise 3: Opcode implementation (subset)

File: `src/opcodes.c`, `include/opcodes.h`

Implement core opcodes:
- `0x00E0`: Clear display
- `0x00EE`: Return from subroutine
- `0x1NNN`: Jump to address NNN
- `0x2NNN`: Call subroutine at NNN
- `0x3XKK`: Skip if VX == KK
- `0x4XKK`: Skip if VX != KK
- `0x5XY0`: Skip if VX == VY
- `0x6XKK`: Set VX = KK
- `0x7XKK`: Add KK to VX
- `0x8XY0`: Set VX = VY
- `0x8XY4`: Add VY to VX (with carry)
- `0xANNN`: Set I = NNN
- `0xDXYN`: Draw sprite at (VX, VY) with height N (collision detection)
- `0xEX9E`: Skip if key VX is pressed
- `0xFX07`: Set VX = delay_timer
- `0xFX15`: Set delay_timer = VX
- `0xFX18`: Set sound_timer = VX

### Exercise 4: Display rendering

File: `src/display.c`, `include/display.h`

Implement:
- `void chip8_clear_display(Chip8 *chip8)`: clear all pixels.
- `void chip8_draw_pixel(Chip8 *chip8, int x, int y, int value)`: set pixel, handle wrap-around.
- `void chip8_draw_sprite(Chip8 *chip8, int x, int y, const uint8_t *sprite, int height)`: draw an 8-wide sprite. Return collision flag.
- `void chip8_print_display(Chip8 *chip8)`: print display as text (# for on, . for off).

### Exercise 5: Keyboard input

File: `src/keyboard.c`, `include/keyboard.h`

Implement:
- `void chip8_key_press(Chip8 *chip8, uint8_t key)`: set key state to pressed.
- `void chip8_key_release(Chip8 *chip8, uint8_t key)`: set key state to released.
- `int chip8_key_is_pressed(Chip8 *chip8, uint8_t key)`: check if key is pressed.
- Keyboard mapping: 1-9, 0, A-F (or use num pad: 1,2,3,C / 4,5,6,D / 7,8,9,E / A,0,B,F).

### Exercise 6: ROM loader

File: `src/rom_loader.c`, `include/rom_loader.h`

Implement:
- `int chip8_load_rom(Chip8 *chip8, const char *filename)`: open file, read bytes, load into memory at 0x200. Return -1 on error.

### Exercise 7: Unit tests for opcodes

File: `tests/test_opcodes.c`

Write tests for:
- Memory read/write
- Register operations
- Stack push/pop
- Each opcode: verify register state, PC updates, memory changes

### Exercise 8: Integration test

File: `tests/test_pong.c` or similar

Create a simple test ROM or use an existing CHIP-8 ROM to verify the emulator runs correctly.

## Hints

- **CHIP-8 Spec:** Refer to https://en.wikipedia.org/wiki/CHIP-8 or similar references.
- **Display:** Pack 8 pixels per uint32_t for efficient storage. Use `(x + y * 64) / 32` to find the word index.
- **Sprites:** Built-in font (16 characters) is typically stored at memory 0x000-0x050. Implement a default font.
- **Collision:** The DXYN opcode sets VF to 1 if a sprite pixel would overwrite an existing pixel.
- **Timers:** Decrement at 60 Hz (or slower if you're not syncing with real time).
- **Opcodes:** Start with a subset (10-15 opcodes) to get the emulator running. Add more as you debug.
- **Debugging:** Print instruction traces and memory state during test runs.
- **Testing:** Write unit tests for each opcode and integration tests with ROM files.

## References

- CHIP-8 Wikipedia: https://en.wikipedia.org/wiki/CHIP-8
- Cowgod's CHIP-8 Reference: http://devernay.free.fr/hacks/chip8/C8TECH00.htm
- Sample ROMs: https://github.com/chip-8/chip-8-archive

## Project Structure

```
chip8-emulator/
├── Makefile
├── README.md
├── include/
│   ├── chip8.h
│   ├── cpu.h
│   ├── display.h
│   ├── keyboard.h
│   ├── opcodes.h
│   └── rom_loader.h
├── src/
│   ├── chip8.c
│   ├── cpu.c
│   ├── opcodes.c
│   ├── display.c
│   ├── keyboard.c
│   ├── rom_loader.c
│   └── main.c
├── tests/
│   ├── test_opcodes.c
│   └── test_integration.c
└── roms/
    └── (place .ch8 ROM files here)
```

## Starting Point

The emulator should be able to:
1. Load a ROM file.
2. Run for a fixed number of cycles or until halt.
3. Display the graphics buffer (text output is fine for now).
4. Handle basic keyboard input (optional for this capstone).

A minimal working emulator can execute maybe 10-20 opcodes and render simple graphics. Expand from there.
