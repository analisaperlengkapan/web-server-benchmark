FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y gfortran && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY server.f90 ./
RUN gfortran -o server server.f90 -O3

EXPOSE 8080
CMD ["./server"]
