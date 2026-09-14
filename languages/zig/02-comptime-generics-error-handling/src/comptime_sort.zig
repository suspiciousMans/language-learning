const std = @import("std");

// comptime function that sorts an array at compile time
fn comptimeSort(comptime arr: []const i32) [arr.len]i32 {
    var result: [arr.len]i32 = undefined;
    @memcpy(&result, arr);

    // Simple insertion sort - runs at compile time
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
    // This array is sorted at compile time - the result is baked in
    const sorted = comptimeSort(&[5]i32{ 5, 2, 8, 1, 9 });
    std.debug.print("Compile-time sorted: {any}\n", .{ sorted });
    std.debug.print("This sorting happened during compilation - zero runtime cost.\n", .{});
}
