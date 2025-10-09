FROM debian:bookworm-slim as builder
RUN apt-get update && apt-get install -y gnat gprbuild
WORKDIR /app
COPY server.adb ./
RUN gnatmake server.adb -largs -laws -lanet

FROM debian:bookworm-slim
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]
