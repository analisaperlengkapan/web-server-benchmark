const std = @import("std");
const net = std.net;
const print = std.debug.print;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const address = try net.Address.parseIp("0.0.0.0", 8080);
    var server = try address.listen(.{
        .reuse_address = true,
    });
    defer server.deinit();

    print("Server running on port 8080\n", .{});

    while (true) {
        const connection = try server.accept();
        const thread = try std.Thread.spawn(.{}, handleConnection, .{ allocator, connection });
        thread.detach();
    }
}

fn handleConnection(allocator: std.mem.Allocator, connection: net.Server.Connection) void {
    defer connection.stream.close();

    var buffer: [1024]u8 = undefined;
    _ = connection.stream.read(&buffer) catch return;

    const response = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n{\"message\":\"Hello, world!\"}";
    _ = connection.stream.write(response) catch return;
}
