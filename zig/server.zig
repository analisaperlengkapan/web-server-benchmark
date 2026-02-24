const std = @import("std");
const net = std.net;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var pool: std.Thread.Pool = undefined;
    try pool.init(.{ .allocator = allocator });
    defer pool.deinit();

    const address = try net.Address.parseIp("0.0.0.0", 8080);
    var server = net.StreamServer.init(.{ .reuse_address = true });
    defer server.deinit();
    try server.listen(address);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Server running on port 8080\n", .{});

    while (true) {
        const connection = try server.accept();
        try pool.spawn(handleConnection, .{connection});
    }
}

fn handleConnection(connection: net.StreamServer.Connection) void {
    defer connection.stream.close();

    var buffer: [1024]u8 = undefined;

    // Keep-alive loop
    while (true) {
        // Read request
        const bytes_read = connection.stream.read(&buffer) catch |err| {
            // End of stream or other error means we close
            _ = err;
            return;
        };

        if (bytes_read == 0) return;

        const request = buffer[0..bytes_read];

        // Check for GET /hello
        if (std.mem.indexOf(u8, request, "GET /hello ") != null) {
            const response = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: 27\r\nConnection: keep-alive\r\n\r\n{\"message\":\"Hello, world!\"}";
            connection.stream.writeAll(response) catch return;
        } else {
            // Not found - close connection usually, but here we just 404 and maybe close
            const response = "HTTP/1.1 404 Not Found\r\nContent-Length: 9\r\nConnection: close\r\n\r\nNot found";
            _ = connection.stream.writeAll(response) catch {};
            return;
        }
    }
}
