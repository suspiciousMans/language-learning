const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "basics",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.step("run", "Run the program"));
    if (b.args) {
        run_cmd.addArgs(b.args);
    }

    // Build and run each exercise file individually using zig run
    // They are standalone demos, not part of the main build.
}
