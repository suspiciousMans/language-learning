const std = @import("std");

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    // Build a string dynamically
    var buf = std.ArrayList(u8).init(alloc);
    defer buf.deinit();

    try buf.appendSlice("Hello");
    try buf.append(' ');
    try buf.appendSlice("World");
    try buf.append('!');
    try buf.append('\n');

    const result = try buf.toOwnedSlice();
    defer alloc.free(result);

    std.debug.print("{s}", .{ result });

    // Build a formatted string
    var formatted = std.ArrayList(u8).init(alloc);
    defer formatted.deinit();

    const name = "Zig";
    const version = 0.13;
    const year = 2016;

    try std.fmt.format(formatted.writer(), "{s} version {d} released in {d}\n", .{ name, version, year });
    const formatted_result = try formatted.toOwnedSlice();
    defer alloc.free(formatted_result);

    std.debug.print("{s}", .{ formatted_result });
}
