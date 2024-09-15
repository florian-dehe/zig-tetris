const std = @import("std");
const glfw = @import("zglfw");
const zopengl = @import("zopengl");
const gl = zopengl.bindings;

const Resolution = struct {
    width: i32,
    height: i32,
};

pub const Window = struct {
    window: *glfw.Window = undefined,

    pub fn create() !Window {
        _ = glfw.setErrorCallback(win_error_callback);
        glfw.init() catch return error.LibraryInit;

        const glMinor = 3;
        const glMajor = 3;
        glfw.windowHintTyped(.context_version_major, glMajor);
        glfw.windowHintTyped(.context_version_minor, glMinor);
        glfw.windowHintTyped(.opengl_profile, .opengl_core_profile);
        glfw.windowHintTyped(.depth_bits, 0); // Only doing 2d
        const win = glfw.Window.create(640, 480, "Zig Tetris", null) catch
            return error.WindowCreation;

        _ = win.setKeyCallback(key_callback);
        _ = win.setFramebufferSizeCallback(framebuffer_callback);
        glfw.makeContextCurrent(win);
        glfw.swapInterval(1);

        zopengl.loadCoreProfile(glfw.getProcAddress, glMajor, glMinor) catch
            return error.GLContextInit;

        return .{
            .window = win,
        };
    }

    pub fn shouldClose(w: *Window) bool {
        return w.window.shouldClose();
    }

    pub fn getFramebufferSize(w: *Window) Resolution {
        const res = w.window.getFramebufferSize();
        return .{ .width = res[0], .height = res[1] };
    }

    pub fn frame(w: *Window) void {
        w.window.swapBuffers();
        glfw.pollEvents();
    }

    pub fn destroy(w: *Window) void {
        w.window.destroy();
        glfw.terminate();
    }
};

// Callbacks
fn win_error_callback(err: i32, desc: *?[:0]const u8) callconv(.C) void {
    std.log.err("[GLFW] Error {d}: {s}", .{ err, desc });
}

fn framebuffer_callback(
    win: *glfw.Window,
    width: i32,
    height: i32,
) callconv(.C) void {
    _ = win;

    gl.viewport(0, 0, width, height);
}

fn key_callback(
    win: *glfw.Window,
    key: glfw.Key,
    scancode: i32,
    action: glfw.Action,
    mods: glfw.Mods,
) callconv(.C) void {
    _ = scancode;
    _ = mods;

    if (action == .press) {
        switch (key) {
            .escape => win.setShouldClose(true),
            else => {},
        }
    }
}
