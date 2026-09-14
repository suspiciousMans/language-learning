# Project 01: Basics — Variables, Control Flow, Functions

**Difficulty:** beginner
**Prerequisites:** Project 00 (Tooling Check)

## Goals

- Understand Zig's basic syntax: variables, types, control flow, functions
- Write and run simple Zig programs
- Learn Zig's approach to mutability (`const` vs `var`)
- Get comfortable with `if/else`, `switch`, `while`, `for`

## Concepts

- **`const` vs `var`** — immutable by default; `var` for mutable bindings
- **Type inference** — Zig infers types from initialization; `x := 5` infers `i32`
- **Integers** — `i32`, `u32`, `i64`, `u64`; no implicit widening
- **Floats** — `f32`, `f64`; explicit casting required between int and float
- **Strings** — strings are `[]const u8` (byte slices), not a native string type
- **If/else** — expression-oriented; `if` returns a value
- **Switch** — exhaustive, works on integers, enums, and more
- **While/For** — `while` with `break`/`continue`; `for` over slices and arrays
- **Functions** — `fn name(params) return_type { ... }`; no default arguments

## Exercises

### Exercise 1: Variables and Types

Create `src/main.zig`:

```zig
const std = @import("std");

pub fn main() void {
    // Immutable variable — cannot be reassigned
    const name: []const u8 = "Zig";
    const first_release: i32 = 2016;

    // Mutable variable — can be reassigned
    var version: f32 = 0.11;
    version = 0.12; // Reassigning works

    // Type inference — Zig figures out the type from the value
    const message = "Learning " ++ name; // inferred as []const u8

    // ++ is the concatenation operator for slices
    std.debug.print("{s} was released in {d} (version {d})\n", .{ name, first_release, version });
    std.debug.print("{s}\n", .{message});
}
```

Run: `zig run src/main.zig`

Expected output:
```
Zig was released in 2016 (version 0.12)
Learning Zig
```

**Note:** Zig does not allow `//` comments after `const` on the same line in some positions. Use a separate comment line. Also, `++` for slice concatenation is Zig 0.12+; older versions used `std.fmt.bufPrint` or similar.

### Exercise 2: Control Flow

Create `src/control_flow.zig`:

```zig
const std = @import("std");

pub fn main() void {
    const score: i32 = 87;

    // if/else as an expression (returns a value)
    const grade = if (score >= 90) "A" else if (score >= 80) "B" else "C";
    std.debug.print("Score: {d} → Grade: {s}\n", .{ score, grade });

    // switch on an integer
    const day: i32 = 3;
    const day_name = switch (day) {
        1 => "Monday",
        2 => "Tuesday",
        3 => "Wednesday",
        4 => "Thursday",
        5 => "Friday",
        6, 7 => "Weekend", // multiple values per branch
        else => "Unknown",
    };
    std.debug.print("Day {d} is {s}\n", .{ day, day_name });

    // while loop with a counter
    var countdown: i32 = 5;
    while (countdown > 0) {
        std.debug.print("{d}... ", .{ countdown });
        countdown -= 1;
    }
    std.debug.print("Go!\n", .{});

    // for loop over an array
    const numbers = [_]i32{ 1, 2, 3, 4, 5 };
    std.debug.print("Counting 1 to 5: ", .{});
    for (numbers) |n| {
        std.debug.print("{d} ", .{ n });
    }
    std.debug.print("\n", .{});
}
```

Run: `zig run src/control_flow.zig`

Expected output:
```
Score: 87 → Grade: B
Day 3 is Wednesday
5... 4... 3... 2... 1... Go!
Counting 1 to 5: 1 2 3 4 5 
```

### Exercise 3: Functions

Create `src/functions.zig`:

```zig
const std = @import("std");

// Simple function with a return type
fn add(a: i32, b: i32) i32 {
    return a + b;
}

// Function with no return value (void)
fn greet(name: []const u8) void {
    std.debug.print("Hello, {s}!\n", .{ name });
}

// Function returning multiple values via a struct
const MinMax = struct {
    min: i32,
    max: i32,
};

fn find_min_max(numbers: []const i32) MinMax {
    if (numbers.len == 0) {
        return MinMax{ .min = 0, .max = 0 };
    }
    var min = numbers[0];
    var max = numbers[0];
    for (numbers) |n| {
        if (n < min) min = n;
        if (n > max) max = n;
    }
    return MinMax{ .min = min, .max = max };
}

pub fn main() void {
    const sum = add(3, 5);
    std.debug.print("3 + 5 = {d}\n", .{ sum });

    greet("Alice");
    greet("Bob");

    const numbers = [_]i32{ 3, 7, 2, 9, 1 };
    const result = find_min_max(&numbers);
    std.debug.print("Min: {d}, Max: {d}\n", .{ result.min, result.max });
}
```

Run: `zig run src/functions.zig`

Expected output:
```
3 + 5 = 8
Hello, Alice!
Hello, Bob!
Min: 1, Max: 9
```

**Note:** Zig doesn't have tuple return types. Return multiple values via a struct or use output parameters with `var` references.

### Exercise 4: Optional Types (Zig's null safety)

Create `src/optionals.zig`:

```zig
const std = @import("std");

pub fn main() void {
    // Optional type: ?[]const u8 means "either a string or null"
    const nullable_name: ?[]const u8 = null;

    // If-let style: check and unwrap in one step
    if (nullable_name) |name| {
        std.debug.print("Name: {s}\n", .{ name });
    } else {
        std.debug.print("Name is null\n", .{});
    }

    // Provide a default with orelse (Zig's Elvis)
    const name_or_default = nullable_name orelse "Unknown";
    std.debug.print("Name or default: {s}\n", .{ name_or_default });

    // Unwrap with explicit check
    const safe_name: ?[]const u8 = "Zig";
    if (safe_name) |sn| {
        std.debug.print("Length (safe): {d}\n", .{ std.mem.len(sn) });
    }

    // Optional pointer — a pointer that can be null
    const Node = struct {
        value: i32,
        next: ?*Node,
    };

    const node3 = Node{ .value = 3, .next = null };
    const node2 = Node{ .value = 2, .next = &node3 };
    const node1 = Node{ .value = 1, .next = &node2 };

    // Walk the linked list safely
    var current: ?*Node = &node1;
    while (current) |node| : (current = node.next) {
        std.debug.print("{d} -> ", .{ node.value });
    }
    std.debug.print("null\n", .{});
}
```

Run: `zig run src/optionals.zig`

Expected output:
```
Name is null
Name or default: Unknown
Length (safe): 3
1 -> 2 -> 3 -> null
```

### Exercise 5: Slices and Arrays

Create `src/slices.zig`:

```zig
const std = @import("std");

pub fn main() void {
    // Fixed-size array — size is part of the type
    const fixed: [5]i32 = .{ 10, 20, 30, 40, 50 };
    std.debug.print("Fixed array: {any}\n", .{ fixed });

    // Slice — a pointer + length, can point to part of an array
    const slice: []const i32 = &fixed;
    std.debug.print("Slice length: {d}\n", .{ slice.len });
    std.debug.print("Slice: {any}\n", .{ slice });

    // Slice a portion: slice[start..end]
    const partial = slice[1..4];
    std.debug.print("Partial (index 1..4): {any}\n", .{ partial });

    // Modifying through a mutable slice
    var mutable = [_]i32{ 5, 2, 8, 1, 9 };
    const mut_slice: []i32 = &mutable;
    mut_slice[0] = 99;
    std.debug.print("After mutation: {any}\n", .{ mutable });

    // std.mem.sort for sorting
    std.mem.sort(i32, &mutable, {}, lessThan);
    std.debug.print("Sorted: {any}\n", .{ mutable });
}

fn lessThan(context: void, a: i32, b: i32) bool {
    _ = context;
    return a < b;
}
```

Expected output:
```
Fixed array: { 10, 20, 30, 40, 50 }
Slice length: 5
Slice: { 10, 20, 30, 40, 50 }
Partial (index 1..4): { 20, 30, 40 }
After mutation: { 99, 2, 8, 1, 9 }
Sorted: { 1, 2, 8, 9, 99 }
```

## Completion Checklist

- [ ] You understand `const` vs `var` (immutable by default in Zig)
- [ ] You can use type inference with `:=` (or `const x = value`)
- [ ] You can concatenate strings with `++`
- [ ] You can write `if/else` as an expression that returns a value
- [ ] You can use `switch` with multiple values per branch and `else`
- [ ] You understand `while` loops with decrement and `for` loops over arrays
- [ ] You can write functions with `fn name(params) rettype`
- [ ] You understand optional types (`?T`) and how to unwrap with `if (x) |val|`
- [ ] You know `orelse` for providing defaults to optionals
- [ ] You understand the difference between arrays (`[N]T`) and slices (`[]T`)
- [ ] You can sort slices with `std.mem.sort`

## Hints

- Zig strings are `[]const u8` — a slice of bytes. There's no dedicated "string" type.
- `std.debug.print` format specifiers: `{s}` for strings/slices, `{d}` for integers, `{f}` for floats, `{any}` for any value
- `orelse` is Zig's equivalent of Kotlin's `?:` Elvis operator
- `if (optional) |value| { ... }` is Zig's null-safe unwrap — the body only runs if non-null
- Arrays have their length in the type: `[5]i32`. Slices are `[]i32` (pointer + length)
- `std.mem.sort` requires a comparison function: `fn lessThan(ctx: void, a: T, b: T) bool`
- Zig's `++` for slice concatenation was introduced in 0.12; older code uses `std.fmt.bufPrint` or manual copying

---

*This project covers the foundational syntax you'll use in every Zig program.*
