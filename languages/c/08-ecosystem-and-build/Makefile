# Compiler and flags
CC ?= gcc
CFLAGS ?= -std=c11 -Wall -Wextra -pedantic -I include
LDFLAGS ?=

# Build profiles
DEBUG_FLAGS = -g -O0 -DDEBUG
RELEASE_FLAGS = -O2 -DRELEASE

# Source files
LIB_SRCS := src/add.c src/subtract.c src/multiply.c src/divide.c src/version.c src/counter.c
LIB_OBJS := $(LIB_SRCS:.c=.o)

TEST_SRCS := tests/test_math_lib.c
TEST_OBJS := $(TEST_SRCS:.c=.o)

# Targets
LIB_STATIC := libmath.a
LIB_SHARED := libmath.so
TEST_EXEC := test_math_lib

# Default target
all: $(LIB_STATIC) $(TEST_EXEC)

# Static library
$(LIB_STATIC): $(LIB_OBJS)
	ar rcs $@ $^
	@echo "Created static library: $@"

# Shared library
$(LIB_SHARED): CFLAGS += -fPIC
$(LIB_SHARED): $(LIB_OBJS)
	$(CC) -shared -o $@ $^
	@echo "Created shared library: $@"

# Object files
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Test executable (linked against static library)
$(TEST_EXEC): $(TEST_OBJS) $(LIB_STATIC)
	$(CC) $(CFLAGS) -o $@ $(TEST_OBJS) $(LIB_STATIC) $(LDFLAGS)

# Build profiles
debug: CFLAGS += $(DEBUG_FLAGS)
debug: clean all
	@echo "Debug build complete"

release: CFLAGS += $(RELEASE_FLAGS)
release: clean all
	@echo "Release build complete"

# Shared library target
shared: $(LIB_SHARED)

# Run tests
test: all
	./$(TEST_EXEC)

# Clean
clean:
	rm -f $(LIB_OBJS) $(TEST_OBJS) $(LIB_STATIC) $(LIB_SHARED) $(TEST_EXEC)

.PHONY: all debug release shared test clean
