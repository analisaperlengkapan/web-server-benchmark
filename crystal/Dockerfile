FROM crystallang/crystal:1.10-alpine as builder
WORKDIR /app
COPY server.cr ./
RUN crystal build --release --static server.cr

FROM alpine:latest
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]
