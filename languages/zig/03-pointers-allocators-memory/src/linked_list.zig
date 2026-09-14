const std = @import("std");

const Node = struct {
    value: i32,
    next: ?*Node = null,
};

fn LinkedList(alloc: std.mem.Allocator) type {
    return struct {
        head: ?*Node = null,
        tail: ?*Node = null,
        len: usize = 0,

        fn append(self: *@This(), value: i32) !void {
            const node = try alloc.create(Node);
            node.* = .{ .value = value, .next = null };

            if (self.head == null) {
                self.head = node;
                self.tail = node;
            } else {
                if (self.tail) |tail| {
                    tail.next = node;
                }
                self.tail = node;
            }
            self.len += 1;
        }

        fn print(self: *@This()) void {
            var current = self.head;
            std.debug.print("List ({d} items): ", .{ self.len });
            while (current) |node| : (current = node.next) {
                std.debug.print("{d} -> ", .{ node.value });
            }
            std.debug.print("null\n", .{});
        }

        fn free(self: *@This()) void {
            var current = self.head;
            while (current) |node| : (current = node.next) {
                const next = node.next;
                alloc.destroy(node);
            }
            self.head = null;
            self.tail = null;
            self.len = 0;
        }
    };
}

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    var list = try LinkedList(alloc).init();
    defer list.free();

    try list.append(1);
    try list.append(2);
    try list.append(3);
    try list.append(4);
    try list.append(5);

    list.print();

    // Pop the head
    if (list.head) |head| {
        const val = head.value;
        list.head = head.next;
        if (list.head == null) list.tail = null;
        list.len -= 1;
        alloc.destroy(head);
        std.debug.print("Popped: {d}\n", .{ val });
    }
    list.print();
}
