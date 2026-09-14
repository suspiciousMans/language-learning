const std = @import("std");

fn processFile() !void {
    std.debug.print("Opening file...\n", .{});

    // defer: runs when scope exits, regardless of error or success
    defer {
        std.debug.print("Closing file (always runs)\n", .{});
    }

    // errdefer: only runs if an error propagates out of this scope
    errdefer {
        std.debug.print("Error: rolling back changes\n", .{});
    }

    // Simulate a processing step that might fail
    const step1 = try doStep1();
    std.debug.print("Step 1 done: {d}\n", .{ step1 });

    // Another errdefer scoped to this block
    {
        errdefer std.debug.print("Step 2 failed, cleaning up step 2\n", .{});
        const step2 = try doStep2(step1) catch {
            std.debug.print("Step 2 failed badly\n", .{});
            return error.Step2Failed;
        };
        std.debug.print("Step 2 done: {d}\n", .{ step2 });
    }

    std.debug.print("All steps succeeded!\n", .{});
}

fn doStep1() !i32 {
    return 42;
}

fn doStep2(input: i32) !i32 {
    return input * 2;
    // To test errdefer: uncomment next line
    // return error.Step2Failed;
}

pub fn main() void {
    // Successful case
    processFile() catch |err| {
        std.debug.print("processFile failed: {}\n", .{ err });
    };

    std.debug.print("\n---\n\n", .{});
}
