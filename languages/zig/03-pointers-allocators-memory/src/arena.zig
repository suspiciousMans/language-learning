const std = @import("std");

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    // Create an arena — all allocations are freed at once on deinit
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const arena_alloc = arena.allocator();

    const names = [_][]const u8{ "Alice", "Bob", "Charlie", "Diana", "Eve" };

    // Allocate an array of pointers to strings
    const name_array = try arena_alloc.alloc([]const u8, names.len);
    for (names, 0..) |name, i| {
        name_array[i] = name;
    }

    std.debug.print("Names from arena:\n", .{});
    for (name_array) |name| {
        std.debug.print("  {s}\n", .{ name });
    }

    // Arena can also allocate slices
    const numbers = try arena_alloc.alloc(i32, 1000);
    for (numbers, 0..) |*n, i| {
        n.* = @intCast(i);
    }
    std.debug.print("First 5 numbers from arena: {any}\n", .{ numbers[0..5] });
    std.debug.print("Last number: {d}\n", .{ numbers[numbers.len - 1] });
}
