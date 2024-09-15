const std = @import("std");
const c = @import("c.zig");
const zopengl = @import("zopengl");
const gl = zopengl.bindings;

pub const Program = struct {
    programId: u32,
    vShader: u32,
    fShader: u32,

    pub fn create(vSource: []const u8, fSource: []const u8) !Program {
        var prog: Program = undefined;

        prog.programId = gl.createProgram();

        prog.vShader = try compileShader(vSource, gl.VERTEX_SHADER);
        prog.fShader = try compileShader(fSource, gl.FRAGMENT_SHADER);

        gl.attachShader(prog.programId, prog.vShader);
        gl.attachShader(prog.programId, prog.fShader);

        gl.linkProgram(prog.programId);

        var ok: i32 = undefined;
        gl.getProgramiv(prog.programId, gl.LINK_STATUS, &ok);
        if (ok != 0) return prog;

        var errSize: i32 = undefined;
        gl.getProgramiv(prog.programId, gl.INFO_LOG_LENGTH, &errSize);

        const message = c.malloc(@intCast(errSize)) orelse return error.OutOfMemory;
        gl.getProgramInfoLog(prog.programId, errSize, &errSize, @ptrCast(message));
        std.log.err("[GL] Error linking program: {s}", .{message});
        return error.LinkingError;
    }

    pub fn use(p: *Program) void {
        gl.useProgram(p.programId);
    }

    pub fn destroy(p: *Program) void {
        gl.detachShader(p.programId, p.vShader);
        gl.detachShader(p.programId, p.fShader);

        gl.deleteShader(p.vShader);
        gl.deleteShader(p.fShader);

        gl.deleteProgram(p.programId);
    }
};

fn compileShader(source: []const u8, kind: u32) !u32 {
    const shader = gl.createShader(kind);
    const sourceLen: i32 = @intCast(source.len);
    gl.shaderSource(shader, 1, &source.ptr, &sourceLen);
    gl.compileShader(shader);

    var ok: i32 = undefined;
    gl.getShaderiv(shader, gl.COMPILE_STATUS, &ok);
    if (ok != 0) return shader;

    var errSize: i32 = undefined;
    gl.getShaderiv(shader, gl.INFO_LOG_LENGTH, &errSize);

    const message = c.malloc(@intCast(errSize)) orelse return error.OutOfMemory;
    gl.getShaderInfoLog(shader, errSize, &errSize, @ptrCast(message));
    std.log.err("[GL] Error compiling shader: {s}", .{message});
    return error.CompilationError;
}
