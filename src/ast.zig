const std = @import("std");
const token = @import("token.zig");
const Token = token.Token;
const fmt = std.fmt;

pub const Node = union(enum) {
    statement: Statement,
    expression: Expression,
};

pub const Statement = union(enum) {
    let: let_statement,
    @"return": return_statement,
    pub const let_statement = struct {
        token: Token, // .let
        ident: Token,
        value: ?Expression,
    };

    pub const return_statement = struct {
        token: Token,
        value: ?Expression,
    };
};
// pub const Identifier = struct {
//     token: Token, // .ident
//     value: []const u8,
// };
pub const Expression = struct {};
pub const Program = struct {
    const self = @This();
    alloc: std.mem.Allocator,
    statements: std.ArrayList(Statement),

    pub fn init(allocator: std.mem.Allocator) self {
        return .{
            .alloc = allocator,
            .statements = std.ArrayList(Statement).init(allocator),
        };
    }

    pub fn deinit(program: *self) void {
        program.statements.deinit();
    }

    // Get token literal from statement
    pub fn get(program: *self) []const u8 {
        if (program.Statements.len > 0) {
            return program.Statements[0].token.literal;
        } else {
            return "";
        }
    }
};
