FROM debian:bookworm-slim as builder
RUN apt-get update && apt-get install -y gnat gprbuild libaws-bin libaws-dev
WORKDIR /app
COPY server.adb ./
RUN gnatmake server.adb -largs -laws -lanet

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y libaws2021 && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]
