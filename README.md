# Web Server Benchmark

[![Test Language Implementations](https://github.com/analisaperlengkapan/web-server-benchmark/actions/workflows/test-languages.yml/badge.svg)](https://github.com/analisaperlengkapan/web-server-benchmark/actions/workflows/test-languages.yml)

A comprehensive polyglot HTTP server benchmark suite comparing raw throughput performance across 19 programming languages.

## Overview

This benchmark compares production-optimized HTTP server implementations across multiple programming languages:

- **Ada** - AWS (Ada Web Server)
- **Assembly** - x86-64 syscalls
- **C** - GNU libmicrohttpd
- **C++** - Crow framework
- **C#** - ASP.NET Core
- **Crystal** - HTTP::Server (stdlib)
- **Fortran** - Custom implementation
- **Go** - net/http (stdlib)
- **Java** - Spring Boot
- **JavaScript** - Node.js + Express
- **Kotlin** - Ktor
- **Nim** - Jester
- **PHP** - Built-in server
- **Python** - FastAPI + Uvicorn
- **Ruby** - Sinatra + Puma
- **Rust** - Actix-web
- **TypeScript** - Express
- **V** - vweb
- **Zig** - Custom implementation

## Endpoint Specification

Each server implements a single endpoint:

- **Path**: `/hello`
- **Method**: GET
- **Response**: JSON
- **Body**: `{"message":"Hello, world!"}`
- **Port**: 8080

## Quick Start

### Build All Servers

```bash
# Build all Docker images
for dir in ada assembly c cpp csharp crystal fortran go java javascript kotlin nim php python ruby rust typescript v zig; do
  docker build -t benchmark-$dir ./$dir
done
```

### Run Individual Server

```bash
# Example: Run Rust server
docker run -p 8080:8080 benchmark-rust

# Test the endpoint
curl http://localhost:8080/hello
```

### Run with Docker Compose

```bash
# Start all servers (each on different port)
docker-compose up

# Or start specific servers
docker-compose up rust go python
```

## Directory Structure

Each language directory is fully isolated and contains:

- Source code (`server.*`, `main.*`, etc.)
- Dependency files (`Cargo.toml`, `package.json`, `go.mod`, etc.)
- `Dockerfile` for containerized deployment
- Build configuration as needed

## Benchmarking

### Using Apache Bench (ab)

```bash
# Run server
docker run -p 8080:8080 benchmark-rust

# Benchmark (10000 requests, 100 concurrent)
ab -n 10000 -c 100 http://localhost:8080/hello
```

### Using wrk

```bash
# Install wrk first
# Benchmark for 30 seconds with 100 connections
wrk -t4 -c100 -d30s http://localhost:8080/hello
```

### Using hey

```bash
# Install hey first
hey -n 10000 -c 100 http://localhost:8080/hello
```

## Performance Considerations

All implementations prioritize:

1. **Production optimization** - Release builds with full optimizations
2. **Minimal overhead** - Direct routing without middleware
3. **JSON serialization** - Using native or fastest libraries
4. **Concurrency** - Multi-threaded where applicable
5. **Memory efficiency** - Static strings, minimal allocations

## Requirements

- Docker 20.10+
- Docker Compose 2.0+ (optional)
- 4GB+ RAM for building all images
- For local development: respective language toolchains

## Building Without Docker

Each directory includes standard build instructions for the language:

```bash
# Rust
cd rust && cargo build --release

# Go
cd go && go build

# Python
cd python && pip install -r requirements.txt && python main.py

# Node.js
cd javascript && npm install && npm start
```

## Contributing

Contributions are welcome! When adding a new language implementation:

1. Create a new directory with the language name
2. Implement the `/hello` endpoint returning exact JSON format
3. Include a Dockerfile for containerized builds
4. Add production optimizations
5. Document any special build requirements

## License

Apache License 2.0 - See LICENSE file for details
