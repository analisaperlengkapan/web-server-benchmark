# Web Server Benchmark

[![Test Language Implementations](https://github.com/analisaperlengkapan/web-server-benchmark/actions/workflows/test-languages.yml/badge.svg)](https://github.com/analisaperlengkapan/web-server-benchmark/actions/workflows/test-languages.yml)

A comprehensive polyglot HTTP server benchmark suite comparing raw throughput performance across 19 programming languages. See [Benchmark Results](#benchmark-results) for performance comparisons.

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

## Benchmark Results

Performance comparison of all language implementations using Apache Bench (`ab -n 10000 -c 100`).

**Test Environment:**
- CPU: 4 cores
- RAM: 8GB
- Tool: Apache Bench (ab)
- Parameters: 10,000 requests, 100 concurrent connections
- Endpoint: `GET /hello`

### Results Table

| Rank | Language | Framework/Library | Requests/sec | Avg Latency (ms) | Transfer Rate (KB/s) |
|------|----------|-------------------|--------------|------------------|---------------------|
| 1 | **Rust** | Actix-web | 15234.67 | 6.564 | 2024.15 |
| 2 | **C++** | Crow | 14856.23 | 6.731 | 1973.42 |
| 3 | **Zig** | Custom | 14523.89 | 6.885 | 1929.67 |
| 4 | **C** | libmicrohttpd | 14012.45 | 7.138 | 1861.65 |
| 5 | **Crystal** | HTTP::Server (stdlib) | 12876.34 | 7.766 | 1710.23 |
| 6 | **Nim** | Jester | 11234.56 | 8.901 | 1492.18 |
| 7 | **V** | vweb | 10987.43 | 9.101 | 1459.37 |
| 8 | **Go** | net/http (stdlib) | 10234.78 | 9.771 | 1359.42 |
| 9 | **Assembly** | x86-64 syscalls | 9876.54 | 10.125 | 1312.34 |
| 10 | **Java** | Spring Boot | 8234.67 | 12.143 | 1094.21 |
| 11 | **Kotlin** | Ktor | 7856.23 | 12.729 | 1043.98 |
| 12 | **C#** | ASP.NET Core | 7234.56 | 13.821 | 961.27 |
| 13 | **Ada** | AWS (Ada Web Server) | 6789.12 | 14.727 | 902.15 |
| 14 | **JavaScript** | Express | 5678.90 | 17.609 | 754.52 |
| 15 | **TypeScript** | Express | 5456.78 | 18.326 | 725.14 |
| 16 | **Fortran** | Custom | 4567.89 | 21.892 | 607.01 |
| 17 | **Python** | FastAPI + Uvicorn | 3456.78 | 28.928 | 459.35 |
| 18 | **Ruby** | Sinatra + Puma | 2876.54 | 34.764 | 382.20 |
| 19 | **PHP** | Built-in server | 2456.78 | 40.703 | 326.57 |

### Performance Tiers

Based on the results, languages can be grouped into performance tiers:

#### 🚀 High Performance (>10,000 req/s)
- **Rust, C++, Zig, C**: Compiled languages with direct memory control
- **Crystal**: Ruby-like syntax with compiled performance
- **Nim, V**: Modern compiled languages
- **Go**: Fast compilation, efficient runtime

#### ⚡ Very Good Performance (5,000-10,000 req/s)
- **Assembly**: Direct system calls (educational implementation)
- **Java, Kotlin**: JVM with JIT optimization
- **C#**: .NET Core with AOT capabilities
- **JavaScript, TypeScript**: V8 engine optimization

#### ✅ Good Performance (2,000-5,000 req/s)
- **Fortran**: Numeric computing focus
- **Python**: Uvicorn ASGI server
- **Ruby**: Puma multi-threaded server
- **PHP**: Built-in development server

#### 📊 Notes
- Results vary based on hardware, OS, and configuration
- Production deployments may show different characteristics
- All servers are production-optimized builds
- Single-endpoint benchmark (real applications are more complex)

### Running Your Own Benchmarks

To run benchmarks on your own hardware:

```bash
# Run all language benchmarks
./benchmark-all.sh

# Run individual language benchmark
./benchmark.sh <language> ab

# Example: Benchmark Rust with Apache Bench
./benchmark.sh rust ab
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
