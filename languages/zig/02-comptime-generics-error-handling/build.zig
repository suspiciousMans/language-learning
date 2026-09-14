const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "comptime-generics-errors",
        .root_source_file = b.path("src/errors.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.step("run", "Run the program"));
    if (b.args) {
        run_cmd.addArgs(b.args);
    }

    // Each exercise file is standalone — run them with `zig run src/<file>.zig`
}
