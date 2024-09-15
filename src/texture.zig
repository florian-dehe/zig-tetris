const zstbi = @import("zstbi");
const gl = @import("zopengl").bindings;

pub const Texture = struct {
    texId: u32,

    pub fn create(filename: [:0]const u8) !Texture {
        var texId: u32 = undefined;

        var img = try zstbi.Image.loadFromFile(filename, 0);
        defer img.deinit();

        gl.genTextures(1, &texId);
        gl.bindTexture(gl.TEXTURE_2D, texId);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);

        gl.texImage2D(
            gl.TEXTURE_2D,
            0,
            gl.RGB,
            @as(i32, @intCast(img.width)),
            @as(i32, @intCast(img.height)),
            0,
            gl.RGB,
            gl.UNSIGNED_BYTE,
            @ptrCast(img.data),
        );

        gl.bindTexture(gl.TEXTURE_2D, 0);

        return .{
            .texId = texId,
        };
    }

    pub fn bind(tex: *Texture) void {
        gl.bindTexture(gl.TEXTURE_2D, tex.texId);
    }

    pub fn deinit(tex: *Texture) void {
        gl.deleteTextures(1, &tex.texId);
    }
};
