# Compiler and flags
CC ?= gcc
CFLAGS ?= -std=c11 -Wall -Wextra -pedantic -I include

# Targets
TARGETS := test_chip8

# Source files
CHIP8_SRCS := src/chip8.c src/display.c
TEST_SRCS := tests/test_chip8.c

# Default target
all: $(TARGETS)

# Test executable
test_chip8: $(TEST_SRCS) $(CHIP8_SRCS)
	$(CC) $(CFLAGS) -o $@ $^

# Run tests
test: test_chip8
	./test_chip8

# Clean
clean:
	rm -f $(TARGETS)

.PHONY: all test clean
