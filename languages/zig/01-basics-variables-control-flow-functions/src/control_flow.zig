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
        6, 7 => "Weekend",
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
