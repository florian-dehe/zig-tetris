const gl = @import("zopengl").bindings;

const Program = @import("shaders.zig").Program;
const Texture = @import("texture.zig").Texture;
const Quad = @import("geometry.zig").Quad;

pub const RenderingPipeline = struct {
    vao: u32 = undefined,
    sProgram: Program = undefined,
    uMVPLoc: i32,
    uColorLoc: i32,
    quad: Quad = undefined,

    pub fn create(vShader: []const u8, fShader: []const u8) !RenderingPipeline {
        var vao: u32 = undefined;
        gl.genVertexArrays(1, &vao);
        gl.bindVertexArray(vao);

        const program = try Program.create(vShader, fShader);
        const uMVPLoc = gl.getUniformLocation(program.programId, "uMVP");
        const uColorLoc = gl.getUniformLocation(program.programId, "uColor");

        return .{
            .vao = vao,
            .sProgram = program,
            .uMVPLoc = uMVPLoc,
            .uColorLoc = uColorLoc,
            .quad = Quad.create(),
        };
    }

    pub fn draw(p: *RenderingPipeline, color: [3]f32, mvp: [*c]const f32) void {
        p.sProgram.use();
        gl.uniform3f(p.uColorLoc, color[0], color[1], color[2]);
        gl.uniformMatrix4fv(p.uMVPLoc, 1, gl.FALSE, mvp);
        p.quad.draw();
    }

    pub fn destroy(p: *RenderingPipeline) void {
        p.quad.destroy();
        p.sProgram.destroy();
        gl.deleteVertexArrays(1, &p.vao);
    }
};
