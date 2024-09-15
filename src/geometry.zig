const gl = @import("zopengl").bindings;

pub const Quad = struct {
    ebo: u32,
    vbo: u32,
    tbo: u32,

    pub fn create() Quad {
        return createQuad();
    }

    pub fn draw(q: *Quad) void {
        gl.bindBuffer(gl.ARRAY_BUFFER, q.ebo);
        gl.bindBuffer(gl.ARRAY_BUFFER, q.vbo);
        gl.enableVertexAttribArray(0);
        gl.vertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 0, null);
        gl.drawElements(gl.TRIANGLES, 6, gl.UNSIGNED_INT, @ptrFromInt(0));
    }

    pub fn destroy(q: *Quad) void {
        gl.deleteBuffers(1, &q.tbo);
        gl.deleteBuffers(1, &q.tbo);
    }
};

fn createQuad() Quad {
    var quad: Quad = undefined;

    const elements = [_]u32{
        0, 1, 2,
        2, 3, 1,
    };
    gl.genBuffers(1, &quad.ebo);
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, quad.ebo);
    gl.bufferData(
        gl.ELEMENT_ARRAY_BUFFER,
        6 * @sizeOf(u32),
        &elements,
        gl.STATIC_DRAW,
    );

    const vertices = [_][3]f32{
        [_]f32{ 0.0, 0.0, 0.0 }, // bottom left
        [_]f32{ 0.0, 1.0, 0.0 }, // top left
        [_]f32{ 1.0, 0.0, 0.0 }, // bottom right
        [_]f32{ 1.0, 1.0, 0.0 }, // top right
    };
    gl.genBuffers(1, &quad.vbo);
    gl.bindBuffer(gl.ARRAY_BUFFER, quad.vbo);
    gl.bufferData(
        gl.ARRAY_BUFFER,
        4 * 3 * @sizeOf(f32),
        &vertices,
        gl.STATIC_DRAW,
    );
    gl.enableVertexAttribArray(0);
    gl.vertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 0, null);

    const texcoords = [_][2]f32{
        [_]f32{ 0, 0 },
        [_]f32{ 0, 1 },
        [_]f32{ 1, 0 },
        [_]f32{ 1, 1 },
    };
    gl.genBuffers(1, &quad.tbo);
    gl.bindBuffer(gl.ARRAY_BUFFER, quad.tbo);
    gl.bufferData(
        gl.ARRAY_BUFFER,
        4 * 2 * @sizeOf(f32),
        &texcoords,
        gl.STATIC_DRAW,
    );
    gl.enableVertexAttribArray(1);
    gl.vertexAttribPointer(1, 2, gl.FLOAT, gl.FALSE, 0, null);

    return quad;
}
