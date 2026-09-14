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
