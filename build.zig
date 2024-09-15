const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zig-tetris",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zstbi = b.dependency("zstbi", .{});
    exe.root_module.addImport("zstbi", zstbi.module("root"));
    exe.linkLibrary(zstbi.artifact("zstbi"));

    const zglfw = b.dependency("zglfw", .{});
    exe.root_module.addImport("zglfw", zglfw.module("root"));
    exe.linkLibrary(zglfw.artifact("glfw"));

    const zmath = b.dependency("zmath", .{});
    exe.root_module.addImport("zmath", zmath.module("root"));

    const zopengl = b.dependency("zopengl", .{});
    exe.root_module.addImport("zopengl", zopengl.module("root"));

    exe.linkLibC();
    exe.linkSystemLibrary("epoxy");
    b.installArtifact(exe);

    const play = b.step("play", "Play the game");
    const run = b.addRunArtifact(exe);
    run.step.dependOn(b.getInstallStep());
    play.dependOn(&run.step);
}
