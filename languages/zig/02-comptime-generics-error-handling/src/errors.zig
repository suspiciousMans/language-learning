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
        return;
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
