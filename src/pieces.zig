const F = false;
const X = true;

pub const Piece = struct {
    color: [3]f32,
    pattern: [4][3]bool,
};

pub const I: Piece = .{
    .color = [_]f32{ 0.2, 1.0, 1.0 },
    .pattern = [_][3]bool{
        [_]bool{ F, X, F },
        [_]bool{ F, X, F },
        [_]bool{ F, X, F },
        [_]bool{ F, X, F },
    },
};

pub const J: Piece = .{
    .color = [_]f32{ 0.2, 0.2, 1.0 },
    .pattern = [_][3]bool{
        [_]bool{ F, X, F },
        [_]bool{ F, X, F },
        [_]bool{ X, X, F },
        [_]bool{ F, F, F },
    },
};

pub const L: Piece = .{
    .color = [_]f32{ 1.0, 0.6, 0.1 },
    .pattern = [_][3]bool{
        [_]bool{ F, X, F },
        [_]bool{ F, X, F },
        [_]bool{ F, X, X },
        [_]bool{ F, F, F },
    },
};

pub const O: Piece = .{
    .color = [_]f32{ 1.0, 1.0, 0.2 },
    .pattern = [_][3]bool{
        [_]bool{ F, X, X },
        [_]bool{ F, X, X },
        [_]bool{ F, F, F },
        [_]bool{ F, F, F },
    },
};

pub const S: Piece = .{
    .color = [_]f32{ 0.2, 1.0, 0.2 },
    .pattern = [_][3]bool{
        [_]bool{ F, X, X },
        [_]bool{ X, X, F },
        [_]bool{ F, F, F },
        [_]bool{ F, F, F },
    },
};

pub const T: Piece = .{
    .color = [_]f32{ 0.6, 0.2, 0.9 },
    .pattern = [_][3]bool{
        [_]bool{ X, X, X },
        [_]bool{ F, X, F },
        [_]bool{ F, F, F },
        [_]bool{ F, F, F },
    },
};

pub const Z: Piece = .{
    .color = [_]f32{ 1.0, 0.2, 0.2 },
    .pattern = [_][3]bool{
        [_]bool{ X, X, F },
        [_]bool{ F, X, X },
        [_]bool{ F, F, F },
        [_]bool{ F, F, F },
    },
};
