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
