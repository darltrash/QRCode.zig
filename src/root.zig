const std = @import("std");
pub const Raw = @import("raw/qrcode.zig");

pub const Encoding = enum(u8) {
    numeric = 0,
    alphanumeric = 1,
    byte = 2,
};

pub const ErrorCorrectionLevel = enum(u8) {
    low = 0,
    medium = 1,
    quartile = 2,
    high = 3,
};

pub const QR = struct {
    raw: Raw.QRCode,
    allocator: std.mem.Allocator,
    modules: []const u8,
    size: u8,

    pub fn fromText(
        allocator: std.mem.Allocator,
        version: u8,
        ecc: ErrorCorrectionLevel,
        text: []const u8,
    ) !QR {
        const c_text = try allocator.dupeZ(u8, text);
        defer allocator.free(c_text);

        const size: usize = @intCast(Raw.qrcode_getBufferSize(version));
        const modules = try allocator.alloc(u8, size);

        var qr: Raw.QRCode = undefined;

        if (Raw.qrcode_initText(
            &qr,
            modules.ptr,
            version,
            @intFromEnum(ecc),
            c_text.ptr,
        ) != 0)
            return error.CannotInit;

        return QR{
            .raw = qr,
            .allocator = allocator,
            .modules = modules,
            .size = qr.size,
        };
    }

    pub fn fromBuffer(
        allocator: std.mem.Allocator,
        version: u8,
        ecc: ErrorCorrectionLevel,
        buffer: []const u8,
    ) !QR {
        const size: usize = @bitCast(Raw.qrcode_getBufferSize(version));
        const modules = try allocator.alloc(u8, size);

        var qr: Raw.QRCode = undefined;

        if (Raw.qrcode_initText(
            &qr,
            modules.ptr,
            version,
            @intFromEnum(ecc),
            buffer.ptr,
            buffer.len,
        ) != 0)
            return error.CannotInit;

        return QR{
            .raw = qr,
            .allocator = allocator,
            .modules = modules,
        };
    }

    pub fn getModule(self: *QR, x: u8, y: u8) bool {
        return Raw.qrcode_getModule(&self.raw, x, y);
    }

    pub fn deinit(self: QR) void {
        self.allocator.free(self.modules);
    }
};
