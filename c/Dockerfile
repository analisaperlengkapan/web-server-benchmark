FROM gcc:13 as builder
RUN apt-get update && apt-get install -y libmicrohttpd-dev
WORKDIR /app
COPY server.c ./
RUN gcc -o server server.c -lmicrohttpd -O3

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y libmicrohttpd12 && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]
