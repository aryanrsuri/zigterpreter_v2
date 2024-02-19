const std = @import("std");
var gp = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gp.allocator();
pub const lexer = @import("lexer.zig");
pub const token = @import("token.zig");
pub const ast = @import("ast.zig");
pub const parser = @import("parser.zig");

pub fn main() !void {
    var i: usize = 0;
    while (0 < 100) : (i += 1) {
        _ = try repl(gpa);
    }
}

fn repl(g: std.mem.Allocator) !void {
    std.debug.print("$> ", .{});

    const input = try std.io.getStdIn().reader().readUntilDelimiterAlloc(g, '\n', 1024);
    defer g.free(input);
    var lex = lexer.Lexer.init(input);
    var p = parser.Parser.init(&lex);
    var prog: ast.Program = try p.parse_progam(g);
    // defer prog.deinit();
    // std.debug.print("{any}\n", .{prog.statements});
    for (0..prog.statements.items.len) |i| {
        const statement = prog.statements.items[i];
        // if (@tagName(statement) == .let) {
        std.debug.print("ident: {s}\n", .{statement.let.ident.literal});
        std.debug.print("token: {s}\n", .{statement.let.token.literal});
        std.debug.print("expression: {?}\n", .{statement.let.value});
        // } else {
        // std.debug.print("ident: {s}\n", .{statement.@"return".ident.literal});
        // std.debug.print("token: {s}\n", .{statement.@"return".token.literal});
        // std.debug.print("expression: {?}\n", .{statement.@"return".value});
    }
}
// var lex = lexer.Lexer.init(in);
// var tok: token.Token = lex.advance();
//
// while (true) : (tok = lex.advance()) {
//     if (tok.kind == .eof) break;
//     std.debug.print("{} {s}\n", .{ tok.kind, tok.literal });
// }
