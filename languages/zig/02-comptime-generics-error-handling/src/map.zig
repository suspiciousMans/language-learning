const std = @import("std");

// A generic map function - works with any slice type
fn map(
    comptime T: type,
    comptime U: type,
    items: []const T,
    transform: fn (item: T) U,
) ![]U {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    const result = try alloc.alloc(U, items.len);
    for (items, 0..) |item, i| {
        result[i] = transform(item);
    }
    return result;
}

pub fn main() void {
    const numbers = [_]i32{ 1, 2, 3, 4, 5 };

    // Double each number
    const doubled = try map(i32, i32, &numbers, struct {
        fn double(n: i32) i32 { return n * 2; }
    }.double);
    std.debug.print("Doubled: {any}\n", .{ doubled });

    // Convert numbers to strings
    const as_string = try map(i32, []const u8, &numbers, struct {
        fn to_str(n: i32) []const u8 {
            return std.fmt.comptimePrint("num_{d}", .{n});
        }
    }.to_str);
    std.debug.print("As strings: {any}\n", .{ as_string });
}
