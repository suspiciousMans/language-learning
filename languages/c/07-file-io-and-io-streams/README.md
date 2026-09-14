# Project 07: File I/O and I/O Streams

**Difficulty:** intermediate
**Prerequisites:** project 01 (basics), project 02 (pointers and memory), project 05 (errors and assertions)

## Goals

- Understand C file I/O: `fopen()`, `fclose()`, `fread()`, `fwrite()`, `fgets()`, `fputs()`.
- Work with binary and text files.
- Understand stream positioning: `fseek()`, `ftell()`, `rewind()`.
- Handle errors in file I/O: check return values and use `ferror()`, `feof()`.
- Parse structured data from files (CSV, simple record formats).
- Implement buffered I/O efficiently.

## Concepts

- Text mode vs binary mode: `fopen("file", "r")` vs `fopen("file", "rb")`.
- Reading and writing: `fgets()`, `fputs()`, `fscanf()`, `fprintf()`, `fread()`, `fwrite()`.
- Stream positioning: `fseek()`, `ftell()`, `rewind()`, `seek` constants (`SEEK_SET`, `SEEK_CUR`, `SEEK_END`).
- Error handling: `ferror()`, `feof()`, `clearerr()`, `perror()`.
- File operations: checking existence, renaming (`rename()`), deleting (`remove()`).
- Buffering: `fflush()`, line-buffering vs full-buffering.

## Completion checklist

- [ ] Write a function that reads a text file line-by-line using `fgets()`.
- [ ] Write a function that writes lines to a text file using `fputs()`.
- [ ] Write a function that reads structured data (CSV or fixed-record format) from a file.
- [ ] Use `fseek()` to seek to a specific position in a file and read/write from there.
- [ ] Implement a binary file writer that writes structures to a file.
- [ ] Implement a binary file reader that reads structures from a file.
- [ ] Check for file I/O errors: test `ferror()` and `feof()` properly.
- [ ] Parse CSV data: handle quoted fields and commas within quotes.
- [ ] Write a function that counts lines in a file without loading it all into memory.
- [ ] Write comprehensive unit tests for file I/O operations.

## Exercises

### Exercise 1: Text file read and write

File: `ex_text_io.c`

Write functions:
- `int read_lines(const char *filename, char **lines, int max_lines)`: read up to `max_lines` from a file, store in `lines` array. Return number of lines read or -1 on error.
- `int write_lines(const char *filename, const char **lines, int count)`: write `count` lines to a file. Return 0 on success, -1 on error.

In `main()`, create a test file, read it, modify the lines, and write to a new file.

### Exercise 2: Binary file I/O

File: `ex_binary_io.c`

Define a simple structure:
```c
typedef struct {
    int id;
    char name[50];
    float score;
} Record;
```

Write functions:
- `int write_records(const char *filename, Record *records, int count)`: write records to a binary file.
- `int read_records(const char *filename, Record **records, int *count)`: read records from a binary file, allocate memory for `*records`.

Test by writing several records, reading them back, and verifying.

### Exercise 3: CSV parser

File: `ex_csv_parser.c`

Write a CSV parser:
- `int parse_csv_line(const char *line, char **fields, int max_fields)`: parse a CSV line into fields. Handle quoted fields. Return number of fields parsed.
- `int read_csv(const char *filename, char ***records, int *num_records, int *num_fields)`: read entire CSV file, allocate memory. Return 0 on success.

Test with a sample CSV file containing quoted and non-quoted fields.

### Exercise 4: Stream positioning and random access

File: `ex_stream_positioning.c`

Write functions demonstrating `fseek()` and `ftell()`:
- `int file_size(const char *filename)`: return file size using `fseek()` to `SEEK_END`.
- `void print_file_lines_reversed(const char *filename)`: read file, seek to different positions, print lines in reverse order.
- `char* read_line_at_offset(const char *filename, long offset)`: seek to `offset`, read and return one line (allocate memory).

Test with a multi-line file.

### Exercise 5: Line counter and statistics

File: `ex_file_stats.c`

Write functions:
- `int count_lines(const char *filename)`: count lines without loading entire file.
- `int count_words(const char *filename)`: count words (space-separated tokens).
- `int count_chars(const char *filename, char c)`: count occurrences of a character.
- `void file_stats(const char *filename)`: print line, word, character count (like `wc`).

Test with files of various sizes.

### Exercise 6: Unit tests for file I/O

File: `test_file_io.c`

Write comprehensive tests:
- Test reading existing files.
- Test writing and reading back.
- Test error handling (non-existent files, read-only files, permission errors).
- Test binary I/O with structures.
- Test CSV parsing with edge cases (empty fields, quoted commas, empty lines).
- Test stream positioning and seeking.
- Verify file integrity after operations.

## Hints

- Always check the return value of `fopen()`: it may return `NULL` if the file cannot be opened.
- Use `ferror()` and `feof()` to distinguish between errors and normal end-of-file.
- In text mode, line endings (`\n`, `\r\n`) may be translated; in binary mode, they are not.
- `fseek()` and `ftell()` work reliably only on seekable files (not pipes or sockets).
- Allocate memory for dynamically-sized data (lines, fields) and remember to free it.
- CSV parsing is tricky: handle edge cases like empty fields, quoted fields containing commas or quotes, and trailing whitespace.
- Test file I/O with temporary files; use a test fixture to clean them up.
- Always close files (even in error paths) to avoid resource leaks.
