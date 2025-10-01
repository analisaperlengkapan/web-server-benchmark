FROM debian:bookworm-slim as builder
RUN apt-get update && apt-get install -y nasm
WORKDIR /app
COPY server.asm ./
RUN nasm -f elf64 server.asm && ld -o server server.o

FROM debian:bookworm-slim
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]
