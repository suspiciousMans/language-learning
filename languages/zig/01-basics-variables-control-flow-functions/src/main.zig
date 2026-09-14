const std = @import("std");

pub fn main() void {
    // Immutable variable — cannot be reassigned
    const name: []const u8 = "Zig";
    const first_release: i32 = 2016;

    // Mutable variable — can be reassigned
    var version: f32 = 0.11;
    version = 0.12; // Reassigning works

    // Type inference — Zig figures out the type from the value
    const message = "Learning " ++ name; // inferred as []const u8

    // ++ is the concatenation operator for slices
    std.debug.print("{s} was released in {d} (version {d})\n", .{ name, first_release, version });
    std.debug.print("{s}\n", .{message});
}
