# Compiler and flags
CC ?= gcc
CFLAGS ?= -std=c11 -Wall -Wextra -pedantic

# Target binary
TARGET := main_utils

# Source files and corresponding object files
SRCS := main_utils.c utils.c
OBJS := $(SRCS:.c=.o)

# Default target
all: $(TARGET)

# Link the object files into the final binary
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Compile each .c into a .o
%.o: %.c utils.h
	$(CC) $(CFLAGS) -c -o $@ $<

# Clean build artifacts
clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all clean
