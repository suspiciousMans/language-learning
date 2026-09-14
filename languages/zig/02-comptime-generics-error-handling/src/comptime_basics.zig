const std = @import("std");

// comptime variables are evaluated at compile time
const compiled_pi: f64 = comptime blk: {
    // You can write normal Zig code here - it runs during compilation
    var result: f64 = 0.0;
    var sign: f64 = 1.0;
    var denom: f64 = 1.0;
    var i: usize = 0;
    while (i < 1000) : (i += 1) {
        result += sign * 4.0 / denom;
        sign = -sign;
        denom += 2.0;
    }
    break :blk result;
};

pub fn main() void {
    std.debug.print("Pi (computed at compile time): {d:.10}\n", .{ compiled_pi });
    std.debug.print("This value is baked into the binary - no runtime cost.\n", .{});
}

// comptime functions are called at compile time when their arguments are compile-time known
fn factorial(comptime n: u32) comptime u32 {
    if (n == 0) return 1;
    return n * factorial(n - 1);
}
