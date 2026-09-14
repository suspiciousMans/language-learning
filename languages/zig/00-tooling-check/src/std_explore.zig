const std = @import("std");

pub fn main() void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Printing with std.io.getStdOut().writer()\n", .{});

    var numbers = [_]i32{ 5, 2, 8, 1, 9, 3 };
    std.sort.insertion(i32, &numbers, {}, lt);
    std.debug.print("Sorted: {any}\n", .{numbers});
}

fn lt(context: void, a: i32, b: i32) bool {
    _ = context;
    return a < b;
}
