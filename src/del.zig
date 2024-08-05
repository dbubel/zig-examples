const std = @import("std");
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var arr = std.ArrayList(u8).init(allocator);
    try arr.append(1);
    defer arr.deinit();
    std.debug.print("{any}\n", .{arr.items[9]});
}
