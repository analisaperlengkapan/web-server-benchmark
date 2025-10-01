# Go HTTP Server

Production-optimized HTTP server using standard library net/http.

## Build & Run

### With Docker
```bash
docker build -t benchmark-go .
docker run -p 8080:8080 benchmark-go
```

### Local Development
```bash
go build -o server main.go
./server
```

## Test
```bash
curl http://localhost:8080/hello
```

Expected response:
```json
{"message":"Hello, world!"}
```

## Optimizations

- Standard library net/http (no external dependencies)
- Efficient JSON encoding
- Alpine-based Docker image for minimal size
