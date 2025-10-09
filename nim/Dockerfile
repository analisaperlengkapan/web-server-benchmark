FROM nimlang/nim:2.0.0-alpine as builder
WORKDIR /app
COPY nim-server.nimble ./
RUN nimble install -y jester
COPY server.nim ./
RUN nim c -d:release --opt:speed server.nim && ls -la

FROM alpine:latest
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]
