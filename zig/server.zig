const std = @import("std");
const net = std.net;
const print = std.debug.print;

const Context = struct {
    allocator: std.mem.Allocator,
    connection: net.StreamServer.Connection,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const address = try net.Address.parseIp("0.0.0.0", 8080);
    var server = net.StreamServer.init(.{
        .reuse_address = true,
    });
    defer server.deinit();
    try server.listen(address);

    print("Server running on port 8080\n", .{});

    while (true) {
        const connection = try server.accept();
        const ctx = try allocator.create(Context);
        ctx.* = .{
            .allocator = allocator,
            .connection = connection,
        };
        _ = try std.Thread.spawn(.{}, handleConnectionWrapper, .{ctx});
    }
}

fn handleConnectionWrapper(ctx: *Context) void {
    handleConnection(ctx.allocator, ctx.connection);
    ctx.allocator.destroy(ctx);
}

fn handleConnection(allocator: std.mem.Allocator, connection: net.StreamServer.Connection) void {
    _ = allocator;
    defer connection.stream.close();

    var buffer: [1024]u8 = undefined;
    _ = connection.stream.read(&buffer) catch return;

    const response = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n{\"message\":\"Hello, world!\"}";
    _ = connection.stream.write(response) catch return;
}
