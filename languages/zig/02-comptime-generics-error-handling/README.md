# Project 02: Comptime, Generics, and Error Handling

**Difficulty:** intermediate
**Prerequisites:** Project 01 (Basics)

## Goals

- Understand Zig's `comptime` — compile-time code execution
- Write generic data structures using `comptime` parameters
- Master Zig's error handling: `error` sets, `try`, `catch`, `defer`, `errdefer`
- Learn how Zig's error model differs from exceptions in other languages

## Concepts

- **`comptime`** — variables, parameters, and blocks evaluated at compile time. Zig's version of C++ templates / Rust generics, but Turing-complete at compile time.
- **`comptime` parameters** — generic-like: `fn map(comptime T: type, items: []const T, f: fn(T) T) []const T`
- **`anytype`** — a parameter that accepts any type; resolved at compile time
- **`std.meta`**

- **`error` sets** — Zig errors are declared as sets of error tokens: `error{InputTooLong, ParseError}!void`
- **`try`** — propagates errors up the call stack (like `?` in Rust)
- **`catch`** — handles errors locally
- **`defer` / `errdefer`** — cleanup that runs when scope exits / when error propagates
- **`!T` (error union)** — a value that is either `T` or an error. Zig forces you to handle it.

## Exercises

### Exercise 1: Errors and try/catch

Create `src/errors.zig`:

```zig
const std = @import("std");

// A function that can fail with specific errors
fn parseAge(input: []const u8) error{InvalidInput, OutOfRange}!i32 {
    if (input.len == 0) return error.InvalidInput;
    for (input) |c| {
        if (c < '0' or c > '9') return error.InvalidInput;
    }
    const age = std.fmt.parseInt(i32, input, 10) catch return error.InvalidInput;
    if (age < 0 or age > 150) return error.OutOfRange;
    return age;
}

pub fn main() void {
    // try unwraps success or propagates error
    const valid = try parseAge("25");
    std.debug.print("Parsed age: {d}\n", .{ valid });

    // catch lets you handle the error
    const maybe_invalid = parseAge("") catch |err| {
        std.debug.print("Caught error: {}\n", .{ err });
        return; // or provide a default
    };
    std.debug.print("This won't print for empty input\n", .{});

    // error union with default
    const ageOrDefault = parseAge("abc") catch 0;
    std.debug.print("Default age: {d}\n", .{ ageOrDefault });

    // Express the error set explicitly — Zig infers it, but you can be explicit
    const r = parseAge("180") catch |err| {
        switch (err) {
            error.InvalidInput => std.debug.print("Bad input\n", .{}),
            error.OutOfRange => std.debug.print("Age out of range\n", .{}),
        }
    };
}
```

Run: `zig run src/errors.zig`

Expected output:
```
Parsed age: 25
Caught error: InvalidInput
Default age: 0
Age out of range
```

### Exercise 2: defer and errdefer

Create `src/defer.zig`:

```zig
const std = @import("std");

fn processFile() !void {
    std.debug.print("Opening file...\n", .{});

    // defer: runs when scope exits, regardless of error or success
    defer {
        std.debug.print("Closing file (always runs)\n", .{});
    }

    // errdefer: only runs if an error propagates out of this scope
    errdefer {
        std.debug.print("Error: rolling back changes\n", .{});
    }

    // Simulate a processing step that might fail
    const step1 = try doStep1();
    std.debug.print("Step 1 done: {d}\n", .{ step1 });

    // Another errdefer scoped to this block
    {
        errdefer std.debug.print("Step 2 failed, cleaning up step 2\n", .{});
        const step2 = try doStep2(step1) catch {
            std.debug.print("Step 2 failed badly\n", .{});
            return error.Step2Failed;
        };
        std.debug.print("Step 2 done: {d}\n", .{ step2 });
    }

    std.debug.print("All steps succeeded!\n", .{});
}

fn doStep1() !i32 {
    return 42;
}

fn doStep2(input: i32) !i32 {
    // Uncomment to test errdefer:
    // return error.Step2Failed;
    return input * 2;
}

pub fn main() void {
    // Successful case
    processFile() catch |err| {
        std.debug.print("processFile failed: {}\n", .{ err });
    };

    std.debug.print("\n---\n\n", .{});

    // Failing case — uncomment to see errdefer in action
    // const fail = try processFile();
}
```

Run: `zig run src/defer.zig`

Expected output (success):
```
Opening file...
Step 1 done: 42
Step 2 done: 84
All steps succeeded!
Closing file (always runs)
```

Try commenting out the `return input * 2;` in `doStep2` and returning `error.Step2Failed` instead to see `errdefer` fire.

### Exercise 3: comptime — Compile-Time Computation

Create `src/comptime_basics.zig`:

```zig
const std = @import("std");

// comptime variables are evaluated at compile time
const compiled_pi: f64 = comptime blk: {
    // You can write normal Zig code here — it runs during compilation
    var result: f64 = 0.0;
    var sign: f64 = 1.0;
    var denom: f64 = 1.0;
    var i: usize = 0;
    while (i < 1000) : (i += 1) {
        result += sign * 4.0 / denom;
        sign = -sign;
        denom += 2.0;
    }
    break :blk result;
};

pub fn main() void {
    std.debug.print("Pi (computed at compile time): {d:.10}\n", .{ compiled_pi });
    std.debug.print("This value is baked into the binary — no runtime cost.\n", .{});
}

// comptime functions are called at compile time when their arguments are compile-time known
fn factorial(comptime n: u32) comptime u32 {
    if (n == 0) return 1;
    return n * factorial(n - 1);
}

fn print_factorials() void {
    // These are evaluated at compile time — zero runtime cost
    const fact5 = comptime factorial(5);
    const fact10 = comptime factorial(10);
    std.debug.print("5! = {d}, 10! = {d}\n", .{ fact5, fact10 });
}
```

Run: `zig run src/comptime_basics.zig`

Expected output:
```
Pi (computed at compile time): 3.1415926536
This value is baked into the binary — no runtime cost.
```

Note: `print_factorials` is defined but not called — add a call in `main` to see it work.

### Exercise 4: Generic Data Structures with comptime

Create `src/generics.zig`:

```zig
const std = @import("std");

// A generic stack that works with any type T
// T is a comptime parameter — resolved at compile time
fn Stack(comptime T: type) type {
    return struct {
        items: []T,
        len: usize,

        fn init(allocator: std.mem.Allocator, capacity: usize) !Stack(T) {
            const items = try allocator.alloc(T, capacity);
            return Stack(T){
                .items = items,
                .len = 0,
            };
        }

        fn deinit(self: *Stack(T), allocator: std.mem.Allocator) void {
            allocator.free(self.items);
            self.* = undefined;
        }

        fn push(self: *Stack(T), item: T) !void {
            if (self.len >= self.items.len) return error.StackFull;
            self.items[self.len] = item;
            self.len += 1;
        }

        fn pop(self: *Stack(T)) error{StackEmpty}!T {
            if (self.len == 0) return error.StackEmpty;
            self.len -= 1;
            return self.items[self.len];
        }

        fn peek(self: Stack(T)) error{StackEmpty}!T {
            if (self.len == 0) return error.StackEmpty;
            return self.items[self.len - 1];
        }

        fn isEmpty(self: Stack(T)) bool {
            return self.len == 0;
        }
    };
}

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    // Create a stack of integers
    var int_stack = try Stack(i32).init(alloc, 5);
    defer int_stack.deinit(alloc);

    try int_stack.push(10);
    try int_stack.push(20);
    try int_stack.push(30);

    const top = int_stack.peek() catch @panic("empty");
    std.debug.print("Top of int stack: {d}\n", .{ top });

    while (!int_stack.isEmpty()) {
        const val = try int_stack.pop();
        std.debug.print("Popped: {d}\n", .{ val });
    }

    // Create a stack of strings (slices)
    var str_stack = try Stack([]const u8).init(alloc, 3);
    defer str_stack.deinit(alloc);

    try str_stack.push("hello");
    try str_stack.push("world");
    try str_stack.push("zig");

    while (!str_stack.isEmpty()) {
        const val = try str_stack.pop();
        std.debug.print("Popped string: {s}\n", .{ val });
    }
}
```

Run: `zig run src/generics.zig`

Expected output:
```
Top of int stack: 30
Popped: 30
Popped: 20
Popped: 10
Popped string: zig
Popped string: world
Popped string: hello
```

**Note:** Zig's `GeneralPurposeAllocator` provides leak detection in debug mode. Always call `.deinit()` and check the return with `defer _ = gpa.deinit();`.

### Exercise 5: A Generic Map Function

Create `src/map.zig`:

```zig
const std = @import("std");

// A generic map function — works with any slice type
fn map(
    comptime T: type,
    comptime U: type,
    items: []const T,
    transform: fn (item: T) U,
) ![]U {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    const result = try alloc.alloc(U, items.len);
    for (items, 0..) |item, i| {
        result[i] = transform(item);
    }
    return result;
}

pub fn main() void {
    const numbers = [_]i32{ 1, 2, 3, 4, 5 };

    // Double each number
    const doubled = try map(i32, i32, &numbers, struct {
        fn double(n: i32) i32 { return n * 2; }
    }.double);
    std.debug.print("Doubled: {any}\n", .{ doubled });

    // Convert numbers to strings
    const as_string = try map(i32, []const u8, &numbers, struct {
        fn to_str(n: i32) []const u8 {
            return std.fmt.comptimePrint("num_{d}", .{n});
        }
    }.to_str);
    std.debug.print("As strings: {any}\n", .{ as_string });
}
```

Run: `zig run src/map.zig`

Expected output:
```
Doubled: { 2, 4, 6, 8, 10 }
As strings: { "num_1", "num_2", "num_3", "num_4", "num_5" }
```

**Note:** `std.fmt.comptimePrint` formats a string at compile time — the result is a `[]const u8` known at compile time.

### Exercise 6: Comptime Sort

Create `src/comptime_sort.zig`:

```zig
const std = @import("std");

// comptime function that sorts an array at compile time
fn comptimeSort(comptime arr: []const i32) [arr.len]i32 {
    var result: [arr.len]i32 = undefined;
    @memcpy(&result, arr);

    // Simple insertion sort — runs at compile time
    var i: usize = 1;
    while (i < result.len) : (i += 1) {
        const key = result[i];
        var j: usize = i;
        while (j > 0 and result[j - 1] > key) {
            result[j] = result[j - 1];
            j -= 1;
        }
        result[j] = key;
    }

    return result;
}

pub fn main() void {
    // This array is sorted at compile time — the result is baked in
    const sorted = comptimeSort(&[5]i32{ 5, 2, 8, 1, 9 });
    std.debug.print("Compile-time sorted: {any}\n", .{ sorted });
    std.debug.print("This sorting happened during compilation — zero runtime cost.\n", .{});
}
```

Run: `zig run src/comptime_sort.zig`

Expected output:
```
Compile-time sorted: { 1, 2, 5, 8, 9 }
This sorting happened during compilation — zero runtime cost.
```

## Completion Checklist

- [ ] You understand Zig's `error` sets and how to declare them
- [ ] You can use `try` to propagate errors and `catch` to handle them
- [ ] You understand `defer` (always runs) vs `errdefer` (runs on error)
- [ ] You can write a `comptime` variable initialized with compile-time computation
- [ ] You can write a generic type using `fn Generic(comptime T: type) type`
- [ ] You understand `anytype` as a wildcard for comptime parameters
- [ ] You can write a generic function with `comptime` type parameters
- [ ] You understand that `comptime` code has zero runtime cost
- [ ] You can use `std.fmt.comptimePrint` for compile-time string formatting

## Hints

- `comptime` is Zig's superpower. Anything you can do at runtime, you can do at compile time.
- `fn name(comptime T: type)` is Zig's generic function declaration — `T` is resolved at compile time
- `anytype` lets you write functions that work with any type, but you lose type safety — prefer `comptime T: type`
- `error{SetFull, NotFound}!void` is an error union return type — the function either returns void or one of those errors
- `try` is shorthand for `catch |err| return err` — it propagates errors up
- `defer` runs when the scope exits. `errdefer` runs only if an error exits the scope.
- `std.heap.GeneralPurposeAllocator` gives you leak detection. In real code, pass an allocator as a parameter instead.
- Zig's standard library uses comptime generics extensively — `std.ArrayList(T)` is a real-world example

---

*Comptime is Zig's defining feature. Generics via comptime are more powerful than C++ templates and more straightforward than Rust generics. Error handling with error unions and try/catch gives you explicit control flow without hidden exception paths.*
