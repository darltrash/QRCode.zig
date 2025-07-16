const std = @import("std");
const root = @import("root.zig");

const QR = root.QR;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var qr = try QR.fromText(allocator, 1, .low, "HELLO WORLD!");
    defer qr.deinit();

    const stdout = std.io.getStdOut().writer();

    for (0..qr.size) |y| {
        for (0..qr.size) |x| {
            const is_lit = qr.getModule(@intCast(x), @intCast(y));
            const characters = if (is_lit)
                "██"
            else
                "  ";

            try stdout.writeAll(characters);
        }

        try stdout.writeByte('\n');
    }
}
