# Compiler and flags
CC ?= gcc
CFLAGS ?= -std=c11 -Wall -Wextra -pedantic -lm

# Targets
TARGETS := ex_error_codes ex_assertions ex_defensive ex_error_propagation test_errors

# Default target
all: $(TARGETS)

# Build each exercise
ex_error_codes: ex_error_codes.c
	$(CC) $(CFLAGS) -o $@ $^

ex_assertions: ex_assertions.c
	$(CC) $(CFLAGS) -o $@ $^

ex_defensive: ex_defensive.c
	$(CC) $(CFLAGS) -o $@ $^

ex_error_propagation: ex_error_propagation.c
	$(CC) $(CFLAGS) -o $@ $^

test_errors: test_errors.c
	$(CC) $(CFLAGS) -o $@ $^

# Run tests
test: all
	@echo "=== Running ex_error_codes ==="
	./ex_error_codes
	@echo "\n=== Running ex_assertions ==="
	./ex_assertions
	@echo "\n=== Running ex_defensive ==="
	./ex_defensive
	@echo "\n=== Running ex_error_propagation ==="
	./ex_error_propagation
	@echo "\n=== Running test_errors ==="
	./test_errors

# Build with assertions disabled
test_ndebug: CFLAGS += -DNDEBUG
test_ndebug: clean all
	@echo "Built with -DNDEBUG (assertions disabled)"
	./ex_assertions

# Clean build artifacts
clean:
	rm -f $(TARGETS) *.o

.PHONY: all test test_ndebug clean
