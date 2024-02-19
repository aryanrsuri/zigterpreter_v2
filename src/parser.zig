const std = @import("std");
const ast = @import("../ast/ast.zig");
const token = @import("../lexer/token.zig");
const lexer = @import("../lexer/lexer.zig");
const Token = token.Token;
const Token_Type = token.Token_Type;

pub const Parser = struct {
    lex: *lexer.Lexer,
    curr: Token = undefined,
    peek: Token = undefined,

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
        while (parser.curr.kind != Token_Type.eof) {
            const statement = parser.parse_statement();
            if (statement) |s| {
                try program.statements.append(s);
            }
            parser.advance();
        }
        return program;
    }

    pub fn parse_statement(parser: *self) ?ast.Statement {
        return switch (parser.curr.kind) {
            .let => parser.parse_let(),
            .@"return" => parser.parse_return(),
            else => null,
        };
    }

    pub fn parse_let(parser: *self) ?ast.Statement {
        var statement: ast.Statement.let_statement = ast.Statement.let_statement{
            .token = parser.curr,
            .ident = Token{},
            .value = null,
        };

        if (!parser.expect(.ident)) {
            return null;
        }

        statement.ident = parser.curr;
        if (!parser.expect(.assign)) {
            return null;
        }
        //
        // while (parser.curr.kind == .semicolon) {
        //     parser.advance();
        // }
        //
        return ast.Statement{ .let = statement };
    }

    pub fn parse_return(parser: *self) ?ast.Statement {
        var statement = ast.Statement.return_statement{
            .token = parser.curr,
            .value = null,
        };

        parser.advance();
        while (parser.curr.kind == token.Token_Type.semicolon) {
            parser.advance();
        }

        return ast.Statement{ .@"return" = statement };
    }
    //
    // pub fn parse_expression(parser: *self) {
    //     _ = parser;
    // }

    pub fn expect(parser: *self, token_type: Token_Type) bool {
        if (parser.peek.kind == token_type) {
            parser.advance();
            return true;
        }
        return false;
    }
};
