FROM thevlang/vlang:alpine as builder
WORKDIR /app
COPY server.v ./
RUN v -prod server.v

FROM alpine:latest
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]
