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

    const self = @This();
    pub fn init(lex: *lexer.Lexer) self {
        var parser = Parser{
            .lex = lex,
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
            const statement = parser.parse_statement();
            if (statement) |s| {
                try program.statements.append(s);
            }
        }
        return program;
    }

    pub fn parse_statement(parser: *self) ?ast.Node {
        return switch (parser.curr.kind) {
            Token_Type.let => parser.parse_let(),
            Token_Type.@"return" => parser.parse_return(),
            else => parser.parse_expression(),
        };
    }

    pub fn parse_let(parser: *self) ?ast.Node {
        var statement: ast.Node = ast.Node{ .type = ast.NodeType.LETSTATEMENT, .tag = parser.curr.kind, .data = ast.Data{
            .ident = null,
            .expression = null,
        } };

        if (!parser.expect(.ident)) {
            return null;
        }

        statement.data.ident = parser.curr;
        if (!parser.expect(.assign)) {
            return null;
        }

        return statement;
    }

    pub fn parse_return(parser: *self) ?ast.Node {
        var statement = ast.Node{ .type = ast.NodeType.RETSTATEMENT, .tag = parser.curr.kind, .data = ast.Data{
            .ident = null,
            .expression = null,
        } };

        parser.advance();
        if (!parser.expect(.semicolon)) {
            parser.advance();
        }

        return statement;
    }

    pub fn parse_expression(parser: *self) ?ast.Node {
        var statement = ast.Node{ .type = ast.NodeType.EXPRESSION, .tag = parser.curr.kind, .data = ast.Data{
            .ident = null,
            .expression = null,
        } };

        return statement;
    }

    pub fn expect(parser: *self, token_type: Token_Type) bool {
        if (parser.peek.kind == token_type) {
            parser.advance();
            return true;
        }
        return false;
    }
};
