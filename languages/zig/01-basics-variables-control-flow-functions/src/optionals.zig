const std = @import("std");

pub fn main() void {
    // Optional type: ?[]const u8 means "either a string or null"
    const nullable_name: ?[]const u8 = null;

    // If-let style: check and unwrap in one step
    if (nullable_name) |name| {
        std.debug.print("Name: {s}\n", .{ name });
    } else {
        std.debug.print("Name is null\n", .{});
    }

    // Provide a default with orelse (Zig's Elvis)
    const name_or_default = nullable_name orelse "Unknown";
    std.debug.print("Name or default: {s}\n", .{ name_or_default });

    // Unwrap with explicit check
    const safe_name: ?[]const u8 = "Zig";
    if (safe_name) |sn| {
        std.debug.print("Length (safe): {d}\n", .{ std.mem.len(sn) });
    }

    // Optional pointer — a pointer that can be null
    const Node = struct {
        value: i32,
        next: ?*Node,
    };

    const node3 = Node{ .value = 3, .next = null };
    const node2 = Node{ .value = 2, .next = &node3 };
    const node1 = Node{ .value = 1, .next = &node2 };

    // Walk the linked list safely
    var current: ?*Node = &node1;
    while (current) |node| : (current = node.next) {
        std.debug.print("{d} -> ", .{ node.value });
    }
    std.debug.print("null\n", .{});
}
