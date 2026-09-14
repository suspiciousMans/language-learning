const std = @import("std");

// A generic stack that works with any type T
// T is a comptime parameter - resolved at compile time
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
