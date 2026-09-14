const std = @import("std");

pub fn main() void {
    // Single-item pointer
    var value: i32 = 42;
    const ptr: *i32 = &value;

    std.debug.print("value = {d}\n", .{ value });
    std.debug.print("*ptr = {d}\n", .{ ptr.* });

    // Modify through pointer
    ptr.* = 100;
    std.debug.print("After *ptr = 100: value = {d}\n", .{ value });

    // Const pointer — can read but not write
    const const_ptr: *const i32 = &value;
    std.debug.print("const_ptr.* = {d}\n", .{ const_ptr.* });

    // Multi-item pointer — points to a fixed array
    const arr = [_]i32{ 10, 20, 30 };
    const arr_ptr: *[3]i32 = &arr;

    std.debug.print("arr_ptr[0] = {d}, arr_ptr[1] = {d}\n", .{ arr_ptr[0], arr_ptr[1] });

    // Slice from array
    const slice: []const i32 = arr_ptr;
    std.debug.print("Slice of array: {any} (len={d})\n", .{ slice, slice.len });

    // Slice a portion
    const partial = slice[1..3];
    std.debug.print("Partial slice: {any}\n", .{ partial });
}
