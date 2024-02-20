//! PARSER . ZIG defines the semantic analysis for mlang
const std = @import("std");
const ast = @import("ast.zig");
const token = @import("token.zig");
const lexer = @import("lexer.zig");
const Token = token.Token;
const Token_Type = token.Token_Type;

pub const Parser = struct {
    lex: *lexer.Lexer,
    curr: Token = Token{ .kind = .illegal, .literal = "" },
    peek: Token = Token{ .kind = .illegal, .literal = "" },
    allocator: std.mem.Allocator,

    const self = @This();
    pub fn init(lex: *lexer.Lexer, alloc: std.mem.Allocator) self {
        var parser = Parser{
            .lex = lex,
            .allocator = alloc,
        };

        parser.advance();
        parser.advance();
        return parser;
    }

    pub fn advance(parser: *self) void {
        parser.curr = parser.peek;
        parser.peek = parser.lex.advance();
    }

    pub fn parse_progam(parser: *self, allocator: std.mem.Allocator) !ast.Program {
        var program = ast.Program.init(allocator);
        while (parser.curr.kind != Token_Type.eof) : (parser.advance()) {
            const statement = try parser.parse_statement();
            if (statement) |s| {
                try program.statements.append(s);
            }
        }
        return program;
    }

    pub fn parse_statement(parser: *self) !?ast.Node {
        return switch (parser.curr.kind) {
            Token_Type.let => try parser.parse_let(),
            // Token_Type.@"return" => parser.parse_return(),
            // else => parser.parse_expression(),
            else => null,
        };
    }

    pub fn parse_let(parser: *self) !?ast.Node {
        var statement: ast.Node = ast.Node.init(parser.allocator, ast.NodeType.LET_STATEMENT, parser.curr);
        if (!parser.expect(.ident)) {
            return null;
        }

        var next_token = parser.curr;
        var next_node = ast.Node.init(parser.allocator, ast.NodeType.IDENTIFIER, next_token);
        try statement.children.append(&next_node);

        if (!parser.expect(.assign)) {
            return null;
        }

        // while (!(parser.curr.kind == Token_Type.semicolon)) {
        //     parser.advance();
        // }

        // statement.data.expression = parser.parse_expression();
        return statement;
    }
    //
    // pub fn parse_return(parser: *self) ?ast.Node {
    //     var statement = ast.Node{ .type = ast.NodeType.RETURN_STATEMENT, .tag = parser.curr.kind, .data = ast.Data{
    //         .ident = null,
    //         .expression = null,
    //     } };
    //
    //     parser.advance();
    //     if (!parser.expect(.semicolon)) {
    //         parser.advance();
    //     }
    //
    //     return statement;
    // }
    //
    // pub fn parse_expression(parser: *self) ?ast.Node {
    //     var statement = ast.Node{ .type = ast.NodeType.EXPRESSION, .tag = parser.curr.kind, .data = ast.Data{
    //         .ident = null,
    //         .expression = null,
    //     } };
    //
    //     return statement;
    // }
    //
    pub fn expect(parser: *self, token_type: Token_Type) bool {
        if (parser.peek.kind == token_type) {
            parser.advance();
            return true;
        }
        return false;
    }
};
