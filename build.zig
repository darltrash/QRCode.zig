const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_mod = b.addModule("qrcode", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    lib_mod.addCSourceFile(.{
        .file = b.path("src/raw/qrcode.c"),
    });

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "qrcode",
        .root_module = lib_mod,
    });

    b.installArtifact(lib);

    /////////////////////////////////////////////////////////////

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe_mod.addImport("qrcode", lib_mod);

    const exe = b.addExecutable(.{
        .name = "qrcode",
        .root_module = exe_mod,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
