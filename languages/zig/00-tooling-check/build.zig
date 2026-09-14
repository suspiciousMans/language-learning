//! Build configuration for Project 00: Tooling Check
//! Zig's build system is built-in — no external tool needed.

const std = @import("std");

pub fn build(b: *std.Build) void {
    // Create an executable from src/main.zig
    const exe = b.addExecutable(.{
        .name = "tooling-check",
        .root_source_file = b.path("src/main.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });

    // Install the executable as the build output
    b.installArtifact(exe);

    // "zig build run" — run the program after building
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.step("run", "Run the program"));
    if (b.args) {
        run_cmd.addArgs(b.args);
    }

    // "zig build" — default step builds and installs
    // "zig build run" — builds and runs
    // "zig build test" — runs any tests (none yet in this project)
}
