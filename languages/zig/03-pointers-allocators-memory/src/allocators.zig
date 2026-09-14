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
    defer alloc.free(heap_items);

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
    defer alloc.destroy(person);

    person.* = .{ .name = "Alice", .age = 30 };
    std.debug.print("Person on heap: {s}, {d}\n", .{ person.name, person.age });
}
