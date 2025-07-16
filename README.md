# QRCode.zig

A "binding" of [ricmoo/QRCode](https://github.com/ricmoo/QRCode) for Zig.

### How to set it up
```shell
zig fetch --save git+https://github.com/darltrash/QRCode.zig
```

in your build.zig file:
```zig
const qrcode_pkg = b.dependency("qrcode", .{});
exe.root_module.addImport("qrcode", zigmon_pkg.module("qrcode"));
```

### Example:
```zig
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
```

Output:
```
██████████████  ████    ██  ██████████████
██          ██    ██    ██  ██          ██
██  ██████  ██  ██  ██  ██  ██  ██████  ██
██  ██████  ██  ██    ██    ██  ██████  ██
██  ██████  ██  ██████      ██  ██████  ██
██          ██              ██          ██
██████████████  ██  ██  ██  ██████████████
                  ████
████████    ██  ██  ██    ██    ██████  ██
        ████  ████      ████████  ████
████████    ██    ██    ████  ██      ████
      ██          ██    ██    ██  ██  ██
████    ██████████    ██  ██        ██  ██
                ████  ██    ████    ██  ██
██████████████      ██    ████████
██          ██      ████████  ██  ████
██  ██████  ██    ██  ██    ██    ██  ██
██  ██████  ██  ██      ██  ██    ██████
██  ██████  ██  ████    ██    ██    ██
██          ██  ██    ██  ████████      ██
██████████████  ██  ████  ██  ██
```

> **Note:** You can also run `zig build run` to test out this same demonstration from `src/main.zig`

### License

As I did little to no contribution to the original thing, I've decided to keep the original license of the original repo.
