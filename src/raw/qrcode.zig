pub extern fn qrcode_getBufferSize(version: u8) u16;

pub extern fn qrcode_initText(qrcode: *QRCode, modules: [*]u8, version: u8, ecc: u8, data: [*:0]const u8) i8;
pub extern fn qrcode_initBytes(qrcode: *QRCode, modules: [*]u8, version: u8, ecc: u8, data: [*]u8, length: u16) i8;

pub extern fn qrcode_getModule(qrcode: *QRCode, x: u8, y: u8) bool;

pub const QRCode = extern struct {
    version: u8,
    size: u8,
    ecc: u8,
    mode: u8,
    mask: u8,
    modules: [*]u8,
};
