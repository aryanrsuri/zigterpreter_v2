//! AST . ZIG defines the syntax tree for the mlang parser
const std = @import("std");
const token = @import("token.zig");
const Token = token.Token;
const fmt = std.fmt;

pub const NodeType = enum {
    EXPRESSION,
    LETSTATEMENT,
    RETSTATEMENT,
    INT,
    FLOAT,
    BOOL,
    NULL,
    STRING,
};

pub const Node = struct {
    type: NodeType,
    tag: token.Token_Type,
    data: Data,
};

pub const Data = struct {
    ident: ?Token,
    expression: ?[]const u8,
};
// what is an expression?
// containers for the expression being evaluated
// is that not just a Node?
//  5
//  where the tag is the type INT
//  where the data is  { .ident NULL, .expression "5" }
//
//
//
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

pub const Program = struct {
    const self = @This();
    alloc: std.mem.Allocator,
    statements: std.ArrayList(Node),

    pub fn init(allocator: std.mem.Allocator) self {
        return .{
            .alloc = allocator,
            .statements = std.ArrayList(Node).init(allocator),
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

pub const NodeV2 = struct {
    tag: token.Token_Type,
    packet: Packet,

    pub const Packet = struct {
        label: Token,
        expr: Token,
    };
};

// let f = 45;
// tag = .let
// packet = {
//  .label = Token { .kind = ident, .value = "f"}
//  .expr = Token {.kind = int, .value = "45"}
// }
