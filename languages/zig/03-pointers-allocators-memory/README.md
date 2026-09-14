# Project 03: Pointers, Allocators, and Memory

**Difficulty:** intermediate
**Prerequisites:** Project 02 (Comptime, Generics, Error Handling)

## Goals

- Understand Zig's pointer types: single-item, multi-item, slices, and optional pointers
- Learn how Zig's allocator system works — no global allocator, explicit memory management
- Master `defer`/`errdefer` for RAII-like resource cleanup
- Understand stack vs heap allocation and when to use each

## Concepts

- **Single-item pointer `*T`** — points to one value; no pointer arithmetic
- **Multi-item pointer `*[N]T`** — points to a fixed-size array; allows indexing
- **Slice `[]T`** — a pointer + length; the primary way to pass variable-length data
- **Allocators** — Zig has no global allocator. You pass `std.mem.Allocator` explicitly to functions that allocate.
- **GeneralPurposeAllocator** — the default allocator with leak detection in debug mode
- **Arena allocator** — allocates from a bump pointer; free all at once with `deinit`
- **Stack allocation** — `var buf: [N]u8 = undefined` — no free needed, lives on the stack
- **`undefined`** — a special value meaning "I will initialize this later" — reading it is UB

## Pointer Types Explained

Zig has several pointer types, each with clear semantics:

```zig
const x: i32 = 42;

// Single-item pointer — points to one i32
const single: *const i32 = &x; // const pointer (can't write through it)
var mutable = 10;
const mutable_ptr: *i32 = &mutable; // mutable pointer (can write)

// Multi-item pointer — points to an array
const arr = [_]i32{ 1, 2, 3 };
const multi: *[3]i32 = &arr; // points to all 3 elements
std.debug.print("multi[0] = {d}\n", .{ multi[0] });

// Slice — pointer + length (the most common pattern)
const slice: []const i32 = &arr;
std.debug.print("slice.len = {d}\n", .{ slice.len });

// Optional pointer — can be null
const nullable: ?*const i32 = null;
```

## Exercises

### Exercise 1: Pointer Basics

Create `src/pointers.zig`:

```zig
const std = @import("std");

pub fn main() void {
    // Single-item pointer
    var value: i32 = 42;
    const ptr: *i32 = &value;

    std.debug.print("value = {d}\n", .{ value });
    std.debug.print("*ptr = {d}\n", .{ ptr.* }); // dereference with .*

    // Modify through pointer
    ptr.* = 100;
    std.debug.print("After *ptr = 100: value = {d}\n", .{ value });

    // Const pointer — can read but not write
    const const_ptr: *const i32 = &value;
    std.debug.print("const_ptr.* = {d}\n", .{ const_ptr.* });
    // const_ptr.* = 200;  // ERROR: cannot assign through *const pointer

    // Multi-item pointer — points to a fixed array
    const arr = [_]i32{ 10, 20, 30 };
    const arr_ptr: *[3]i32 = &arr;

    std.debug.print("arr_ptr[0] = {d}, arr_ptr[1] = {d}\n", .{ arr_ptr[0], arr_ptr[1] });
    std.debug.print("&arr_ptr[0] == arr_ptr? {any}\n", .{ @as(*const i32, &arr_ptr[0]) == @as(*const i32, @ptrCast(arr_ptr)) });

    // Slice from array
    const slice: []const i32 = arr_ptr;
    std.debug.print("Slice of array: {any} (len={d})\n", .{ slice, slice.len });

    // Slice a portion
    const partial = slice[1..3];
    std.debug.print("Partial slice: {any}\n", .{ partial });
}
```

Run: `zig run src/pointers.zig`

Expected output:
```
value = 42
*ptr = 42
After *ptr = 100: value = 100
const_ptr.* = 100
arr_ptr[0] = 10, arr_ptr[1] = 20
&arr_ptr[0] == arr_ptr? true
Slice of array: { 10, 20, 30 } (len=3)
Partial slice: { 20, 30 }
```

### Exercise 2: Stack vs Heap Allocation

Create `src/allocators.zig`:

```zig
const std = @import("std");

pub fn main() void {
    // Stack allocation — lives until the function returns, no free needed
    const stack_buf: [1024]u8 = undefined;
    std.debug.print("Stack buffer: {d} bytes at {p}\n", .{ stack_buf.len, @as(*const u8, @ptrCast(&stack_buf)) });

    // Stack-allocated array with initialization
    const numbers = [_]i32{ 1, 2, 3, 4, 5 };
    std.debug.print("Stack array: {any}\n", .{ numbers });

    // Heap allocation — must be freed
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    // Allocate a slice on the heap
    const heap_items = try alloc.alloc(i32, 5);
    defer alloc.free(heap_items); // Always free what you alloc!

    for (heap_items, 0..) |*item, i| {
        item.* = i * 10;
    }
    std.debug.print("Heap slice: {any}\n", .{ heap_items });

    // Allocate and initialize a struct on the heap
    const Person = struct {
        name: []const u8,
        age: i32,
    };

    const person = try alloc.create(Person);
    defer alloc.destroy(person); // Free the struct

    person.* = .{ .name = "Alice", .age = 30 };
    std.debug.print("Person on heap: {s}, {d}\n", .{ person.name, person.age });
}
```

Run: `zig run src/allocators.zig`

Expected output:
```
Stack buffer: 1024 bytes at 0x...
Stack array: { 1, 2, 3, 4, 5 }
Heap slice: { 0, 10, 20, 30, 40 }
Person on heap: Alice, 30
```

### Exercise 3: Arena Allocator — Bulk Allocation

Create `src/arena.zig`:

```zig
const std = @import("std");

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    // Create an arena — all allocations are freed at once on deinit
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const arena_alloc = arena.allocator();

    // Allocate many small objects without tracking each one
    const names = [_][]const u8{ "Alice", "Bob", "Charlie", "Diana", "Eve" };

    // Allocate an array of pointers to strings (copies the strings)
    const name_array = try arena_alloc.alloc([]const u8, names.len);
    for (names, 0..) |name, i| {
        // Note: string literals are compile-time constants, no alloc needed for them.
        // But if we were copying runtime strings, we'd use arena_alloc;
        // Here we just store the slice pointing to the literal.
        name_array[i] = name;
    }
    // No need to free each string individually — arena handles it

    std.debug.print("Names from arena:\n", .{});
    for (name_array) |name| {
        std.debug.print("  {s}\n", .{ name });
    }

    // Arena can also allocate slices
    const numbers = try arena_alloc.alloc(i32, 1000);
    for (numbers, 0..) |*n, i| {
        n.* = @intCast(i);
    }
    std.debug.print("First 5 numbers from arena: {any}\n", .{ numbers[0..5] });
    std.debug.print("Last number: {d}\n", .{ numbers[numbers.len - 1] });
    // numbers and name_array are freed when arena.deinit() runs (via defer)
}
```

Run: `zig run src/arena.zig`

Expected output:
```
Names from arena:
  Alice
  Bob
  Charlie
  Diana
  Eve
First 5 numbers from arena: { 0, 1, 2, 3, 4 }
Last number: 999
```

### Exercise 4: Linked List with Manual Memory Management

Create `src/linked_list.zig`:

```zig
const std = @import("std");

const Node = struct {
    value: i32,
    next: ?*Node = null,
};

fn LinkedList(alloc: std.mem.Allocator) type {
    return struct {
        head: ?*Node = null,
        tail: ?*Node = null,
        len: usize = 0,

        fn append(self: *@This(), value: i32) !void {
            const node = try alloc.create(Node);
            node.* = .{ .value = value, .next = null };

            if (self.head == null) {
                self.head = node;
                self.tail = node;
            } else {
                if (self.tail) |tail| {
                    tail.next = node;
                }
                self.tail = node;
            }
            self.len += 1;
        }

        fn print(self: *@This()) void {
            var current = self.head;
            std.debug.print("List ({d} items): ", .{ self.len });
            while (current) |node| : (current = node.next) {
                std.debug.print("{d} -> ", .{ node.value });
            }
            std.debug.print("null\n", .{});
        }

        fn free(self: *@This()) void {
            var current = self.head;
            while (current) |node| : (current = node.next) {
                const next = node.next;
                alloc.destroy(node);
            }
            self.head = null;
            self.tail = null;
            self.len = 0;
        }
    };
}

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    var list = try LinkedList(alloc).init();
    defer list.free();

    try list.append(1);
    try list.append(2);
    try list.append(3);
    try list.append(4);
    try list.append(5);

    list.print();

    // Pop the head
    if (list.head) |head| {
        const val = head.value;
        list.head = head.next;
        if (list.head == null) list.tail = null;
        list.len -= 1;
        alloc.destroy(head);
        std.debug.print("Popped: {d}\n", .{ val });
    }
    list.print();
}
```

Run: `zig run src/linked_list.zig`

Expected output:
```
List (5 items): 1 -> 2 -> 3 -> 4 -> 5 -> null
Popped: 1
List (4 items): 2 -> 3 -> 4 -> 5 -> null
```

### Exercise 5: String Building with an Allocator

Create `src/string_builder.zig`:

```zig
const std = @import("std");

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    // Build a string dynamically
    var buf = std.ArrayList(u8).init(alloc);
    defer buf.deinit();

    try buf.appendSlice("Hello");
    try buf.append(' ');
    try buf.appendSlice("World");
    try buf.append('!');
    try buf.append('\n');

    const result = try buf.toOwnedSlice();
    defer alloc.free(result);

    std.debug.print("{s}", .{ result });

    // Build a formatted string
    var formatted = std.ArrayList(u8).init(alloc);
    defer formatted.deinit();

    const name = "Zig";
    const version = 0.13;
    const year = 2016;

    try std.fmt.format(formatted.writer(), "{s} version {d} released in {d}\n", .{ name, version, year });
    const formatted_result = try formatted.toOwnedSlice();
    defer alloc.free(formatted_result);

    std.debug.print("{s}", .{ formatted_result });
}
```

Run: `zig run src/string_builder.zig`

Expected output:
```
Hello World!
Zig version 0.13 released in 2016
```

## Completion Checklist

- [ ] You understand the difference between `*T` (single-item pointer), `*[N]T` (multi-item pointer), and `[]T` (slice)
- [ ] You know how to dereference a pointer with `ptr.*`
- [ ] You understand that Zig has no global allocator — you pass `std.mem.Allocator` explicitly
- [ ] You can use `GeneralPurposeAllocator` for leak detection
- [ ] You can use `ArenaAllocator` for bulk allocation
- [ ] You know when to use stack allocation (`var buf: [N]T`) vs heap allocation
- [ ] You understand `defer alloc.free()` and `defer alloc.destroy()` patterns
- [ ] You can build a dynamic array with `std.ArrayList`
- [ ] You can build dynamic strings with `std.ArrayList(u8)` + `std.fmt.format`

## Hints

- `*const T` is a const pointer (can't write through it). `*T` is a mutable pointer.
- `ptr.*` dereferences a single-item pointer. `array_ptr[index]` works for multi-item pointers.
- Slices (`[]T`) are the most common way to pass variable-length data — they carry their length.
- `alloc.alloc(T, count)` allocates a slice of `count` elements of type `T`. Always free with `alloc.free(slice)`.
- `alloc.create(T)` allocates a single instance of `T`. Always destroy with `alloc.destroy(ptr)`.
- `undefined` means "not initialized yet" — reading it is undefined behavior. Initialize before reading.
- `std.ArrayList(T)` is Zig's dynamic array — like `std::Vec` in Rust or `ArrayList` in Java.
- `std.fmt.format(writer, format, args)` writes formatted output to any writer (including `ArrayList(u8)`).
- Arena allocators are great for request-scoped or phase-scoped allocations where you free everything at once.

---

*Memory management in Zig is explicit but safe. Every allocation has a clear owner, and `defer` makes cleanup easy to get right. The allocator pattern means you always know where memory comes from and who frees it.*
