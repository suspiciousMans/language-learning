# Compiler and flags
CC ?= gcc
CFLAGS ?= -std=c11 -Wall -Wextra -pedantic

# Test targets
TEST_TARGETS := test_string_utils test_array_utils test_with_fixtures test_calculator

# Default target
all: $(TEST_TARGETS)

# Exercise frameworks
test_string_utils: test_string_utils.c string_utils.c
	$(CC) $(CFLAGS) -o $@ $^

test_array_utils: test_array_utils.c array_utils.c
	$(CC) $(CFLAGS) -o $@ $^

test_with_fixtures: test_with_fixtures.c
	$(CC) $(CFLAGS) -o $@ $^

test_calculator: test_calculator.c calculator.c
	$(CC) $(CFLAGS) -o $@ $^

# Run all tests
test: all
	@echo "=== Running String Utils Tests ==="
	./test_string_utils
	@echo "\n=== Running Array Utils Tests ==="
	./test_array_utils
	@echo "\n=== Running Fixture Tests ==="
	./test_with_fixtures
	@echo "\n=== Running Calculator Tests ==="
	./test_calculator

# Clean build artifacts
clean:
	rm -f $(TEST_TARGETS) *.o test_file_*.txt

.PHONY: all test clean
