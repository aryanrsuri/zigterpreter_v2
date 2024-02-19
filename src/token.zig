const std = @import("std");
pub const Token_Type = enum {
    illegal,
    eof,
    ident,
    function,
    let,
    true,
    false,
    @"if",
    @"else",
    @"return",
    equal,
    not_equal,
    int,
    assign,
    plus,
    minus,
    bang,
    asterisk,
    slash,
    comma,
    semicolon,
    lparen,
    rparen,
    lbrace,
    rbrace,
    ltag,
    rtag,
};

pub const Token = struct {
    kind: Token_Type = .illegal,
    literal: []const u8 = "",
};

pub const keywords = std.ComptimeStringMap(Token_Type, .{ .{ "fn", .function }, .{ "let", .let }, .{ "true", .true }, .{ "false", .true }, .{ "if", .@"if" }, .{ "else", .@"else" }, .{ "return", .@"return" } });
