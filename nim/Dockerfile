FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y nim git && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY nim-server.nimble ./
# Install Jester manually or via nimble
RUN nimble install -y jester
COPY server.nim ./
RUN nim c -d:release --opt:speed server.nim

EXPOSE 8080
CMD ["./server"]
