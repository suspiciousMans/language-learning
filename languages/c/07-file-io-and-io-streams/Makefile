# Compiler and flags
CC ?= gcc
CFLAGS ?= -std=c11 -Wall -Wextra -pedantic

# Targets
TARGETS := ex_text_io ex_binary_io ex_csv_parser ex_stream_positioning ex_file_stats test_file_io

# Default target
all: $(TARGETS)

# Build rules
ex_text_io: ex_text_io.c
	$(CC) $(CFLAGS) -o $@ $<

ex_binary_io: ex_binary_io.c
	$(CC) $(CFLAGS) -o $@ $<

ex_csv_parser: ex_csv_parser.c
	$(CC) $(CFLAGS) -o $@ $<

ex_stream_positioning: ex_stream_positioning.c
	$(CC) $(CFLAGS) -o $@ $<

ex_file_stats: ex_file_stats.c
	$(CC) $(CFLAGS) -o $@ $<

test_file_io: test_file_io.c
	$(CC) $(CFLAGS) -o $@ $<

# Run all tests
test: $(TARGETS)
	@echo "=== Running File I/O Exercises ==="
	./ex_text_io
	./ex_binary_io
	./ex_csv_parser
	./ex_stream_positioning
	./ex_file_stats
	./test_file_io

# Clean
clean:
	rm -f $(TARGETS) *.o *.bin *.txt *.csv

.PHONY: all test clean
