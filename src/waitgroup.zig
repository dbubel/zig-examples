const std = @import("std");
const t = @import("thread_safe_arraylist.zig");

pub fn main() !void {
    var wg = std.Thread.WaitGroup{};
    var gpa = std.heap.GeneralPurposeAllocator(.{ .thread_safe = true }){};
    var allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var arrayList = t.ThreadSafeArrayList(@Vector(2, f32)).init(&allocator);
    defer arrayList.deinit();

    var thread_pool: std.Thread.Pool = undefined;
    try thread_pool.init(.{ .allocator = allocator, .n_jobs = 12 });
    defer thread_pool.deinit();

    for (0..10) |_| {
        thread_pool.spawnWg(&wg, f, .{&arrayList});
    }
    thread_pool.waitAndWork(&wg);

    for (arrayList.list.items) |item| {
        std.debug.print("value: {any}\n", .{item});
    }
}

fn f(al: *t.ThreadSafeArrayList(@Vector(2, f32))) void {
    al.append(@Vector(2, f32){ 1, 2 }) catch |err| {
        std.debug.print("{any}\n", .{err});
    };
}
