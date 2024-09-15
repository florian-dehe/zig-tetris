const std = @import("std");
const builtin = @import("builtin");
const zstbi = @import("zstbi");
const zm = @import("zmath");
const gl = @import("zopengl").bindings;

const geometry = @import("geometry.zig");
const Window = @import("window.zig").Window;
const Program = @import("shaders.zig").Program;
const Texture = @import("texture.zig").Texture;
const pieces = @import("pieces.zig");

const cube_vShader = @embedFile("shaders/cube.vert.glsl");
const cube_fShader = @embedFile("shaders/cube.frag.glsl");

// Globals
const Game = struct {
    sProgram: Program = undefined,
    uMVPLoc: i32,
    uColorLoc: i32,
    mainTex: Texture = undefined,
    quad: geometry.Quad = undefined,
};
var g: *Game = undefined;

// Entry point
pub fn main() !void {
    // Memory allocation
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer std.debug.assert(gpa.deinit() == .ok);

    zstbi.init(allocator);
    zstbi.setFlipVerticallyOnLoad(true);
    defer zstbi.deinit();

    // Windowing
    var window: Window = Window.create() catch |err| switch (err) {
        error.LibraryInit => @panic("Can't initialize windowing library."),
        error.WindowCreation => @panic("Can't create window."),
        error.GLContextInit => @panic("Can't initialize GL context."),
    };
    defer window.destroy();

    // Game State
    g = allocator.create(Game) catch @panic("Can't start game (out of memory).");
    defer allocator.destroy(g);

    // Shader Program
    g.sProgram = Program.create(
        cube_vShader,
        cube_fShader,
    ) catch @panic("Error creating shader program.");
    g.uMVPLoc = gl.getUniformLocation(g.sProgram.programId, "uMVP");
    g.uColorLoc = gl.getUniformLocation(g.sProgram.programId, "uColor");
    defer g.sProgram.destroy();

    // Main VAO
    var vao: u32 = undefined;
    gl.genVertexArrays(1, &vao);
    gl.bindVertexArray(vao);
    defer gl.deleteVertexArrays(1, &vao);

    // Geometry
    g.quad = geometry.createQuad();
    defer g.quad.destroy();

    // Texture
    g.mainTex =
        Texture.create("assets/tetris.png") catch @panic("Can't load texture");
    defer g.mainTex.deinit();

    // Drawing
    gl.clearColor(0.0, 0.0, 0.2, 1.0);

    try assertGLError();

    while (!window.shouldClose()) {
        gl.clear(gl.COLOR_BUFFER_BIT);

        const res = window.getFramebufferSize();
        const projMat = zm.orthographicRhGl(
            @as(f32, @floatFromInt(res.width)),
            @as(f32, @floatFromInt(res.height)),
            0,
            10,
        );

        const scale = 50.0;
        drawPiece(&pieces.I, [_]f32{ -300.0, 0.0 }, scale, projMat);
        drawPiece(&pieces.J, [_]f32{ -150.0, 0.0 }, scale, projMat);
        drawPiece(&pieces.L, [_]f32{ -50.0, 0.0 }, scale, projMat);
        drawPiece(&pieces.O, [_]f32{ 50.0, 50.0 }, scale, projMat);
        drawPiece(&pieces.S, [_]f32{ -300.0, -250.0 }, scale, projMat);
        drawPiece(&pieces.T, [_]f32{ -50.0, -250.0 }, scale, projMat);
        drawPiece(&pieces.Z, [_]f32{ 150.0, -250.0 }, scale, projMat);

        window.frame();
    }
    try assertGLError();
}

fn drawPiece(p: *const pieces.Piece, origin: [2]f32, scale: f32, proj: zm.Mat) void {
    g.sProgram.use();
    g.mainTex.bind();
    gl.uniform3f(g.uColorLoc, p.color[0], p.color[1], p.color[2]);

    for (p.pattern, 0..) |sub, y| {
        for (sub, 0..) |block, x| {
            if (!block) continue;

            const offsetX = @as(f32, @floatFromInt(x)) * scale;
            const offsetY = @as(f32, @floatFromInt(y)) * scale;

            const modelMat = zm.mul(
                zm.scaling(scale, scale, 1.0),
                zm.translation(origin[0] + offsetX, origin[1] - offsetY, 0.0),
            );

            const mvp = zm.mul(modelMat, proj);
            gl.uniformMatrix4fv(g.uMVPLoc, 1, gl.FALSE, zm.arrNPtr(&mvp));

            geometry.draw(&g.quad);
        }
    }
}

fn assertGLError() !void {
    if (builtin.mode == .Debug) {
        const err = gl.getError();
        if (err != gl.NO_ERROR) {
            std.log.err("[GL] Error nr {x}", .{err});
            return error.GLError;
        }
    }
}
