# Project 00: Tooling Check — Zig

**Difficulty:** beginner
**Prerequisites:** none

## Goals

- Verify you have the Zig toolchain installed correctly
- Understand the basic project structure Zig uses
- Learn how to compile and run a Zig program
- Get comfortable with `zig run`, `zig build`, and `zig test`

## Concepts

- **`zig` CLI** — the single tool for compiling, running, testing, and building Zig code
- **Zig toolchain** — `zig fmt`, `zig run`, `zig build`, `zig test`, `zig ast`
- **Build system** — Zig has a built-in build system via `build.zig`; no external build tool needed
- **Comptime** — code evaluated at compile time (previewed here, explored in depth in 02)

## Setup

Zig has no separate install step beyond downloading a single binary.

### Option A: Install via package manager

```bash
# macOS
brew install zig

# Linux (Arch)
pacman -S zig

# Linux (other) — download from https://ziglang.org/download/
curl -L https://ziglang.org/download/0.13.0/zig-0.13.0-x86_64-linux.tar.xz | tar -xJ
cd zig-0.13.0-x86_64-linux
export PATH="$PWD/bin:$PATH"
```

### Verify installation

```bash
zig version
```

You should see a version number like `0.13.0`.

## Exercises

### Exercise 1: Hello World

Create `src/main.zig`:

```zig
const std = @import("std");

pub fn main() void {
    std.debug.print("Hello, Zig!\n", .{});
}
```

Run it:

```bash
zig run src/main.zig
```

Expected output: `Hello, Zig!`

### Exercise 2: Check Zig version

In your terminal:

```bash
zig version
zig env --version  # shows environment info
```

Record the version number.

### Exercise 3: Use zig fmt

Zig comes with an opinionated formatter. Format your `src/main.zig`:

```bash
zig fmt src/main.zig
```

Open the file and observe the formatting. `zig fmt` uses 4-space indentation, `pub fn` on its own line, and consistent spacing.

### Exercise 4: Compile to a binary

```bash
zig build-exe src/main.zig -o hello
./hello
```

`zig build-exe` produces a standalone executable. The `-o` flag sets the output name.

### Exercise 5: Explore the std library

Create `src/std_explore.zig`:

```zig
const std = @import("std");

pub fn main() void {
    // std.debug.print is the simplest way to print
    std.debug.print("Printing with std.debug.print\n", .{});

    // std.io.getStdOut() gives you a writer for stdout
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Printing with std.io.getStdOut().writer()\n", .{});

    // std.sort for sorting slices
    var numbers = [_]i32{ 5, 2, 8, 1, 9, 3 };
    std.sort.insertion(i32, &numbers, {}, lt);
    std.debug.print("Sorted: {any}\n", .{numbers});
}

fn lt(context: void, a: i32, b: i32) bool {
    _ = context;
    return a < b;
}
```

Run: `zig run src/std_explore.zig`

## Completion Checklist

- [ ] `zig version` shows a version number
- [ ] `zig run src/main.zig` prints "Hello, Zig!"
- [ ] `zig fmt src/main.zig` formats the file without error
- [ ] `zig build-exe src/main.zig` produces a working binary
- [ ] You understand `std.debug.print` and its `.{ }` arguments tuple

## Hints

- `std.debug.print` takes a format string and a tuple of arguments: `.{}` for zero args, `.{value}` for one, `.{a, b}` for two
- `{any}` prints any Zig value (including arrays, structs) — great for debugging
- `{d}` prints integers, `{s}` prints strings, `{any}` is the most flexible
- Zig's `try` keyword propagates errors — you'll see it a lot; it's covered in 02
- The `.{} ` after format strings is an empty tuple — Zig requires it even when there are no arguments

---

*Use this project to make sure your environment is ready before starting the real work.*
