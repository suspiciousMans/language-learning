# Project 08: Ecosystem and Build Systems

**Difficulty:** intermediate-advanced
**Prerequisites:** project 04 (modularity), project 06 (testing)

## Goals

- Understand C build systems: Makefiles, build flags, and compiler options.
- Work with libraries: static (`.a`) and dynamic (`.so`/`.dll`) libraries.
- Use pkg-config to manage dependencies.
- Understand header guards, forward declarations, and opaque pointers.
- Use version control and tagging in git.
- Understand C ecosystem tools: compilers (gcc, clang), debuggers (gdb), profilers (gprof).
- Organize large projects with multiple files and directories.

## Concepts

- **Makefiles:** targets, rules, variables, automatic variables (`$@`, `$<`, `$^`), phony targets.
- **Compiler flags:** optimization (`-O2`, `-O3`), debugging (`-g`), warnings (`-Wall`, `-Wextra`), linking (`-l`, `-L`).
- **Libraries:** creating static libraries with `ar`, dynamic libraries with `gcc -shared`, linking with `-l` and `-L`.
- **Pkg-config:** querying library flags with `pkg-config --cflags --libs`.
- **Version management:** semantic versioning, version macros in C.
- **Git workflows:** branching, tagging, semantic versioning tags.
- **Build profiles:** debug vs release builds with different compiler flags.
- **C standard library:** common functions (`stdio.h`, `stdlib.h`, `string.h`, `math.h`).

## Completion checklist

- [ ] Create a multi-file C project with a proper directory structure (src/, include/, tests/).
- [ ] Write a Makefile with multiple targets and proper dependencies.
- [ ] Create a static library (`.a`) and link it into an executable.
- [ ] Create a shared library (`.so`) and link it into an executable.
- [ ] Use header guards and forward declarations to avoid circular dependencies.
- [ ] Create an "opaque pointer" pattern for data hiding.
- [ ] Implement a simple version system with version macros.
- [ ] Use git tagging for releases.
- [ ] Create separate debug and release build profiles.
- [ ] Write comprehensive documentation (README, API documentation).

## Exercises

### Exercise 1: Multi-file project structure

Create a project with the following structure:
```
math_lib/
├── Makefile
├── include/
│   └── math_lib.h
├── src/
│   ├── add.c
│   ├── subtract.c
│   ├── multiply.c
│   └── divide.c
└── tests/
    └── test_math_lib.c
```

File: `Makefile`, `include/math_lib.h`, `src/add.c`, `src/subtract.c`, `src/multiply.c`, `src/divide.c`, `tests/test_math_lib.c`

Write simple math functions and compile them with a Makefile.

### Exercise 2: Static library

Create a static library from the math_lib functions.

File: `Makefile` (modified)

- Compile object files from src/
- Create a static library `libmath.a` using `ar rcs`
- Link against `libmath.a` in the test program

### Exercise 3: Shared library

Create a shared library from the math_lib functions.

File: `Makefile` (modified)

- Compile position-independent code (PIC) with `-fPIC`
- Create a shared library `libmath.so` using `gcc -shared`
- Link against `libmath.so` in the test program (may require `LD_LIBRARY_PATH`)

### Exercise 4: Opaque pointer pattern

Implement a data structure with an opaque pointer to hide implementation details.

File: `include/counter.h`, `src/counter.c`

```c
typedef struct Counter Counter;  /* Opaque type */

Counter* counter_create(int initial);
void counter_destroy(Counter *c);
void counter_increment(Counter *c);
int counter_value(Counter *c);
```

The implementation details are hidden in `src/counter.c`.

### Exercise 5: Version management

Add version information to your library.

File: `include/version.h`, `src/version.c`

Define:
```c
#define MATH_LIB_MAJOR 1
#define MATH_LIB_MINOR 0
#define MATH_LIB_PATCH 0

const char* math_lib_version();
```

### Exercise 6: Build profiles (debug/release)

Modify the Makefile to support debug and release builds.

File: `Makefile` (modified)

```make
DEBUG_FLAGS = -g -O0 -DDEBUG
RELEASE_FLAGS = -O2 -DRELEASE

debug: CFLAGS += $(DEBUG_FLAGS)
debug: all

release: CFLAGS += $(RELEASE_FLAGS)
release: all
```

### Exercise 7: Git workflow and tagging

Initialize a git repository, commit your code, and create semantic version tags.

File: `git` commands

```bash
git init
git add .
git commit -m "Initial commit"
git tag -a v1.0.0 -m "Release version 1.0.0"
git tag -l  # list tags
git show v1.0.0  # show tag details
```

### Exercise 8: Documentation and API

Write a README and API documentation.

File: `README.md`, `API.md`

Include:
- Project description
- How to build (debug/release)
- How to use the library
- API reference for all public functions
- Example usage

## Hints

- Use `-fPIC` when compiling code for shared libraries.
- Use `ar rcs libname.a *.o` to create a static library.
- Use `gcc -shared -o libname.so *.o` to create a shared library.
- Opaque pointers hide implementation details and allow library API changes without breaking client code.
- Use `pkg-config` to query installed libraries: `pkg-config --cflags --libs libname`.
- Semantic versioning (MAJOR.MINOR.PATCH) helps users understand compatibility.
- Git tags preserve release points for easy reference.
- Separate debug and release profiles for testing and production.
- Always provide documentation and examples for library users.

## References

- GNU Make manual: https://www.gnu.org/software/make/manual/
- Pkg-config: https://www.freedesktop.org/wiki/Software/pkg-config/
- Static vs dynamic linking: https://en.wikipedia.org/wiki/Static_library vs https://en.wikipedia.org/wiki/Dynamic_library
