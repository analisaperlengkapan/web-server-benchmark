# Web Server Benchmark

A comprehensive polyglot HTTP server benchmark suite comparing raw throughput performance across 19 programming languages.

## Overview

This benchmark compares production-optimized HTTP server implementations across multiple programming languages. All implementations run in Docker containers (Debian Bookworm or Alpine based) and return a simple JSON response `{"message":"Hello, world!"}`.

### ✅ Successfully Benchmarked Languages

| Rank | Language | Framework/Library | Requests/sec | Avg Latency (ms) |
|------|----------|-------------------|--------------|------------------|
| 1 | **Zig** | Custom (std/http) | 19,908.94 | 5.02 |
| 2 | **C** | libmicrohttpd | 19,682.68 | 5.08 |
| 3 | **Nim** | httpbeast | 19,548.39 | 5.12 |
| 4 | **Rust** | Actix-web | 18,403.43 | 5.43 |
| 5 | **Go** | net/http | 18,359.67 | 5.45 |
| 6 | **C++** | Crow | 15,261.14 | 6.55 |
| 7 | **JavaScript** | Express | 9,408.65 | 10.63 |
| 8 | **TypeScript** | Express | 9,216.33 | 10.85 |
| 9 | **Crystal** | HTTP::Server | 8,491.27 | 11.78 |
| 10 | **Java** | Spring Boot | 5,810.06 | 17.21 |
| 11 | **Kotlin** | Ktor | 3,322.94 | 30.09 |
| 12 | **Python** | FastAPI + Uvicorn | 3,211.23 | 31.14 |
| 13 | **Ruby** | Sinatra + Puma | 1,612.92 | 62.00 |

*\*Ruby latency measured during manual run.*

### 📊 Stress Test & Resource Usage (500 Concurrent Connections)

| Language | Requests/sec | Avg Latency (ms) | Peak CPU (%) | Peak Memory |
|----------|--------------|------------------|--------------|-------------|
| **C** | 13987.69 | 35.746 | 69.58 | 8.777MiB |
| **Crystal** | 10328.92 | 48.408 | 74.66 | 32.96MiB |
| **Rust** | 11614.35 | 43.050 | 97.10 | 9.57MiB |
| **Go** | 10258.75 | 48.739 | 107.88 | 13.99MiB |
| **Zig** | 8374.38 | 59.706 | 108.47 | 797.6MiB |
| **Cpp** | 9453.60 | 52.890 | 89.50 | 6.699MiB |
| **Php** | 8385.18 | 59.629 | 102.50 | 10.82MiB |
| **V** | 493.09 | 1014.021 | 14.25 | 3.984MiB |
| **Kotlin** | 3822.19 | 130.815 | 278.56 | 173.7MiB |
| **Java** | 675.40 | 740.298 | 0.60 | 141.5MiB |
| **Python** | 2164.04 | 231.050 | 109.45 | 33.71MiB |
| **Javascript** | 2093.94 | 238.784 | 121.89 | 76.06MiB |
| **Ruby** | 1105.50 | 452.284 | 112.31 | 39.24MiB |
| **Typescript** | 1687.04 | 296.376 | 124.79 | 82.38MiB |

*Note: Stress tests run for 5-10 seconds with 500 concurrent connections.*

### ⚠️ Functional but Benchmark Issues
- **Nim**: Server works (verified with `curl`) but `ab` benchmark times out consistently in Docker.
- **Fortran**: Server implementation using `iso_c_binding` works partially but connection issues observed under load.

### ❌ Known Issues / Skipped
- **Ada**: `AWS.NET.SOCKET_ERROR` on startup (likely library/Docker compatibility issue).
- **Assembly**: Server hangs during benchmark.
- **C#**: `docker: Error response from daemon: invalid argument` on startup (Runtime/Environment incompatibility).

## Benchmark Environment
- **Tool**: Apache Bench (`ab`) running in Docker.
- **Requests**: 10,000 total, 100 concurrent (Standard) / 500 concurrent (Stress).
- **Hardware**: Virtualized Environment (Docker).

## How to Run

```bash
# Run standard benchmark
./benchmark-all.sh

# Run stress tests
./benchmark-stress-all.sh
```

## Implementation Notes

- **Docker**: All images use `debian:bookworm-slim` or `alpine` with manually installed dependencies to ensure stability and avoid Docker Hub rate limits.
- **Kotlin**: Uses `shadow` plugin for fat JAR creation.
- **Fortran**: Implements raw socket server using `iso_c_binding`.
- **Ruby**: Uses `bundle exec` with `puma` for production performance.
