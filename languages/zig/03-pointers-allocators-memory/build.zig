const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "pointers-allocators",
        .root_source_file = b.path("src/pointers.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.step("run", "Run the program"));
    if (b.args) {
        run_cmd.addArgs(b.args);
    }

    // Run each exercise with: zig run src/<file>.zig
}
