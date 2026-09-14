# Compiler
CC ?= gcc

# Flags: -std=c11 for C11, -Wall -Wextra for warnings, -pedantic for strict conformance
CFLAGS ?= -std=c11 -Wall -Wextra -pedantic

# Default target
all: toolchain_check

# Build the toolchain check binary
toolchain_check: toolchain_check.c
	$(CC) $(CFLAGS) -o $@ $<

# Clean build artifacts
clean:
	rm -f toolchain_check

.PHONY: all clean
