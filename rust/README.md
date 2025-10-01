# Rust HTTP Server

Production-optimized HTTP server using Actix-web framework.

## Build & Run

### With Docker
```bash
docker build -t benchmark-rust .
docker run -p 8080:8080 benchmark-rust
```

### Local Development
```bash
cargo build --release
./target/release/rust-server
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

- Release profile with LTO enabled
- Codegen-units set to 1 for maximum optimization
- opt-level 3
- Actix-web for high-performance async I/O
