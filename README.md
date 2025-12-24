# Web Server Benchmark

A comprehensive polyglot HTTP server benchmark suite comparing raw throughput performance across 19 programming languages.

## Overview

This benchmark compares production-optimized HTTP server implementations across multiple programming languages. All implementations run in Docker containers (Debian Bookworm or Alpine based) and return a simple JSON response `{"message":"Hello, world!"}`.

### ✅ Successfully Benchmarked Languages

| Rank | Language | Framework/Library | Requests/sec | Avg Latency (ms) |
|------|----------|-------------------|--------------|------------------|
| 1 | **C** | libmicrohttpd | 12,438.63 | 8.04 |
| 2 | **Crystal** | HTTP::Server | 11,968.16 | 8.36 |
| 3 | **Rust** | Actix-web | 10,857.60 | 9.21 |
| 4 | **Go** | net/http | 9,012.52 | 11.10 |
| 5 | **Zig** | Custom (std/http) | 7,053.17 | 14.18 |
| 6 | **C++** | Crow | 6,063.06 | 16.49 |
| 7 | **PHP** | Built-in server | 4,746.60 | 21.07 |
| 8 | **V** | vweb | 3,660.77 | 27.32 |
| 9 | **Kotlin** | Ktor | 2,622.74 | 38.13 |
| 10 | **Java** | Spring Boot | 2,538.39 | 39.40 |
| 11 | **Python** | FastAPI + Uvicorn | 2,062.25 | 48.49 |
| 12 | **JavaScript** | Express | 1,744.17 | 57.33 |
| 13 | **Ruby** | Sinatra + Puma | 1,120.42 | 8.93* |
| 14 | **TypeScript** | Express | 943.47 | 105.99 |

*\*Ruby latency measured during manual run.*

### ⚠️ Functional but Benchmark Issues
- **Nim**: Server works (verified with `curl`) but `ab` benchmark times out consistently in Docker.
- **Fortran**: Server implementation using `iso_c_binding` works partially but connection issues observed under load.

### ❌ Known Issues / Skipped
- **Ada**: `AWS.NET.SOCKET_ERROR` on startup (likely library/Docker compatibility issue).
- **Assembly**: Server hangs during benchmark.
- **C#**: `docker: Error response from daemon: invalid argument` on startup (Runtime/Environment incompatibility).

## Benchmark Environment
- **Tool**: Apache Bench (`ab`) running in Docker.
- **Requests**: 10,000 total, 100 concurrent.
- **Hardware**: Virtualized Environment (Docker).

## How to Run

```bash
# Run full benchmark suite
./benchmark-all.sh
```

## Implementation Notes

- **Docker**: All images use `debian:bookworm-slim` or `alpine` with manually installed dependencies to ensure stability and avoid Docker Hub rate limits.
- **Kotlin**: Uses `shadow` plugin for fat JAR creation.
- **Fortran**: Implements raw socket server using `iso_c_binding`.
- **Ruby**: Uses `bundle exec` with `puma` for production performance.
