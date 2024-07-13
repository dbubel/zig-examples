const std = @import("std");
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var file = try std.fs.cwd().openFile("large-file.json", .{});
    defer file.close();

    // Things are _a lot_ slower if we don't use a BufferedReader
    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    // lines will get read into this
    var arr = std.ArrayList(u8).init(allocator);
    defer arr.deinit();

    var line_count: usize = 0;
    var byte_count: usize = 0;
    while (true) {
        reader.streamUntilDelimiter(arr.writer(), '\n', null) catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };
        line_count += 1;
        byte_count += arr.items.len;
        arr.clearRetainingCapacity();
    }
    std.debug.print("{d} lines, {d} bytes", .{ line_count, byte_count });
}
