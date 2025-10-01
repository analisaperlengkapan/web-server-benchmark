FROM alpine:latest as builder
RUN apk add --no-cache wget tar xz
RUN wget https://ziglang.org/download/0.11.0/zig-linux-x86_64-0.11.0.tar.xz && \
    tar -xf zig-linux-x86_64-0.11.0.tar.xz && \
    mv zig-linux-x86_64-0.11.0 /zig
WORKDIR /app
COPY server.zig ./
RUN /zig/zig build-exe server.zig -O ReleaseFast

FROM alpine:latest
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]
