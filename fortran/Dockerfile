FROM gcc:13 as builder
RUN apt-get update && apt-get install -y gfortran
WORKDIR /app
COPY server.f90 ./
RUN gfortran -o server server.f90 -O3

FROM debian:bookworm-slim
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]
