//! AST . ZIG defines the syntax tree for the mlang parser
const std = @import("std");
const token = @import("token.zig");
const Token = token.Token;
const fmt = std.fmt;
pub const Node = struct {
    type: NodeType,
    tag: token.Token,
    data: Data,
    pub const Index = u32;
    pub const Data = struct {
        l: ?token.Token,
        r: ?token.Token,
    };
};

pub const NodeList = std.MultiArrayList(Node);
pub const NodeType = enum {
    LET_STATEMENT,
    RETURN_EXPRESSION,
    IDENT_EXPRESSION,
    MUL,
    DIV,
    ADD,
    SUBTRACT,
    INT,
    BOOL,
    NULL,
    STRING,
};

pub const Program = struct {
    const self = @This();
    alloc: std.mem.Allocator,
    nodes: std.ArrayList(Node),

    pub fn deinit(program: *self) void {
        program.nodes.deinit();
        program.* = undefined;
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

// let f = 45;
// tag = .let
// packet = {
//  .label = Token { .kind = ident, .value = "f"}
//  .expr = Token {.kind = int, .value = "45"}
// }
// pub const Statement = union(enum) {
//     let: let_statement,
//     @"return": return_statement,
//     pub const let_statement = struct {
//         token: Token, // .let
//         ident: Token,
//         value: ?Expression,
//     };
//
//     pub const return_statement = struct {
//         token: Token,
//         value: ?Expression,
//     };
// };
