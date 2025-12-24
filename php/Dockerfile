FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y php-cli php-common && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY index.php ./
EXPOSE 8080
CMD ["php", "-S", "0.0.0.0:8080", "index.php"]
