const std = @import("std");
pub fn main() !void {
    const file = try std.fs.cwd().openFile("README.md", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const reader = buf_reader.reader();

    var line: [1024]u8 = undefined;
    var writer = std.io.fixedBufferStream(&line);

    while (true) {
        reader.streamUntilDelimiter(writer.writer(), '\n', null) catch |err| {
            switch (err) {
                error.EndOfStream => {
                    return;
                },
                else => {
                    std.debug.print("{any}", .{err});
                },
            }
        };

        std.debug.print("SIZE {any}", .{writer.pos});
        std.debug.print("{s}\n", .{line[0..writer.pos]});
        writer.reset();
    }
}
