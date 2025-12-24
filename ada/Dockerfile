FROM debian:bullseye-slim as builder
RUN apt-get update && apt-get install -y gnat gprbuild libaws20-dev
WORKDIR /app
COPY server.adb server.gpr ./
# Compile with AWS libraries
RUN gprbuild -P server.gpr

FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y libaws6 openssl ca-certificates mime-support && rm -rf /var/lib/apt/lists/*
# Generate dummy certs
RUN openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes -subj "/CN=localhost"

COPY --from=builder /app/server /server
# Create templates directory just in case
RUN mkdir -p /templates
WORKDIR /
EXPOSE 8080
CMD ["/server"]
