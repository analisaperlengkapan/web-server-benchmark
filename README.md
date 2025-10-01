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

Performance comparison of language implementations using Apache Bench (`ab -n 10000 -c 100`).

**Test Environment:**
- CPU: 4 cores  
- RAM: 8GB
- Tool: Apache Bench (ab)
- Parameters: 10,000 requests, 100 concurrent connections
- Endpoint: `GET /hello`
- Date: October 2025

### Actual Test Results

The following results were obtained from running the benchmark suite in the CI/CD environment:

| Rank | Language | Framework/Library | Requests/sec | Avg Latency (ms) | Transfer Rate (KB/s) | Status |
|------|----------|-------------------|--------------|------------------|---------------------|--------|
| 1 | **Go** | net/http (stdlib) | 4998.36 | 20.007 | 663.85 | ✅ Tested |

### Expected Performance (Reference)

Based on typical performance characteristics and industry benchmarks, the expected relative performance rankings are:

| Tier | Language | Framework/Library | Expected Requests/sec | Notes |
|------|----------|-------------------|-----------------------|-------|
| 🚀 High | **Rust** | Actix-web | ~15,000+ | Highly optimized, zero-cost abstractions |
| 🚀 High | **C++** | Crow | ~14,000+ | Direct memory control, compiled |
| 🚀 High | **Zig** | Custom | ~14,000+ | Low-level optimization |
| 🚀 High | **C** | libmicrohttpd | ~13,000+ | System-level performance |
| 🚀 High | **Crystal** | HTTP::Server | ~12,000+ | Ruby-like syntax, compiled |
| 🚀 High | **Nim** | Jester | ~11,000+ | Python-like syntax, compiled |
| 🚀 High | **V** | vweb | ~10,000+ | Fast compilation, performance focus |
| 🚀 High | **Go** | net/http | ~5,000-10,000 | **Tested: 4998.36 req/s** |
| ⚡ Good | **Assembly** | x86-64 syscalls | ~9,000+ | Educational implementation |
| ⚡ Good | **Java** | Spring Boot | ~8,000+ | JVM JIT optimization |
| ⚡ Good | **Kotlin** | Ktor | ~7,000+ | JVM-based |
| ⚡ Good | **C#** | ASP.NET Core | ~7,000+ | .NET optimization |
| ⚡ Good | **Ada** | AWS | ~6,000+ | Enterprise reliability |
| ⚡ Good | **JavaScript** | Express | ~5,000+ | V8 engine optimization |
| ⚡ Good | **TypeScript** | Express | ~5,000+ | V8 engine optimization |
| ✅ Moderate | **Fortran** | Custom | ~4,000+ | Numeric computing focus |
| ✅ Moderate | **Python** | FastAPI + Uvicorn | ~3,000+ | ASGI async server |
| ✅ Moderate | **Ruby** | Sinatra + Puma | ~2,500+ | Multi-threaded server |
| ✅ Moderate | **PHP** | Built-in server | ~2,000+ | Development server |

### Performance Tiers

Performance can be categorized into tiers based on expected throughput:

#### 🚀 High Performance (>10,000 req/s)
- **Rust, C++, Zig, C**: Compiled languages with direct memory control and zero-cost abstractions
- **Crystal**: Ruby-like syntax with compiled performance
- **Nim, V**: Modern compiled languages optimized for performance

#### ⚡ Good Performance (5,000-10,000 req/s)
- **Go**: Fast compilation, efficient runtime, excellent concurrency (**Tested: 4998 req/s**)
- **Assembly**: Direct system calls (educational implementation)
- **Java, Kotlin**: JVM with JIT optimization
- **C#**: .NET Core with AOT capabilities
- **JavaScript, TypeScript**: V8 engine optimization

#### ✅ Moderate Performance (2,000-5,000 req/s)
- **Fortran**: Numeric computing focus
- **Python**: Uvicorn ASGI server
- **Ruby**: Puma multi-threaded server
- **PHP**: Built-in development server

### Testing Methodology

**Actual Testing:**
- Tests were run in a CI/CD environment with limited resources
- Go was successfully tested with actual benchmark results: **4998.36 req/s**
- Other languages may require additional dependencies or have build constraints in CI

**Expected Performance:**
- Rankings are based on typical performance characteristics, industry benchmarks, and framework specifications
- Actual results will vary based on:
  - Hardware specifications (CPU, RAM, storage)
  - Operating system and kernel version
  - Network configuration
  - Docker overhead
  - Concurrent load patterns
  - Request/response payload sizes

**To Get Accurate Results for Your Environment:**
```bash
# Run standard benchmarks
./benchmark-all.sh

# Run comprehensive stress tests with resource monitoring
./benchmark-stress-all.sh
```

#### 📊 Important Notes
- Benchmarks represent single-endpoint performance (real applications are more complex)
- Results shown are indicative of relative performance between languages
- All server implementations use production-optimized builds
- Performance characteristics may differ significantly in production environments
- Consider factors beyond raw speed: memory safety, development velocity, ecosystem maturity

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

## Stress Testing & Resource Monitoring

Comprehensive stress testing with CPU, RAM, I/O monitoring and extreme load scenarios.

### Test Scenarios

1. **Standard Load Test**: Baseline performance (10K requests, 100 concurrent)
2. **High Concurrency Test**: Stress with high concurrent connections (100K requests, 500 concurrent)
3. **Very High Load Test**: Extreme stress conditions (1M requests, 1000 concurrent)
4. **Large Payload Test**: Testing with large data transfers
5. **Sustained Load Test**: Endurance testing (continuous load for 5 minutes)

### Resource Monitoring

Each test monitors:
- **CPU Usage**: Average and peak utilization percentages
- **Memory Consumption**: RAM usage in MB (average and peak)
- **Network I/O**: Data transfer rates (RX/TX)
- **Disk I/O**: Block device read/write operations
- **Request Failures**: Error rates under stress conditions

### Running Stress Tests

```bash
# Run comprehensive stress test on a single language
./benchmark-stress.sh <language>

# Example: Stress test Go implementation
./benchmark-stress.sh go

# Run stress tests on all languages
./benchmark-stress-all.sh
```

### Stress Test Results

Results are saved in the `stress_test_results/` directory:

- Individual test results (`.txt` files)
- Resource monitoring data (`.csv` files)
- Comprehensive summary report (`stress_test_summary.md`)

### Example Output

The stress tests provide detailed metrics:

```
Standard Load Test:
  Requests/sec: 15234.67
  Avg latency: 6.564 ms
  Failed requests: 0
  Total time: 0.656 seconds

Resource Usage:
  CPU: avg=45.2%, max=78.5%
  Memory: avg=125.3MB, max=158.7MB
```

### Interpreting Results

- **Throughput**: Higher requests/sec indicates better performance
- **Latency**: Lower average latency means faster response times
- **Failed Requests**: Should be 0 or very low under normal conditions
- **CPU Usage**: Lower usage indicates better efficiency
- **Memory Usage**: Stable memory consumption suggests no memory leaks
- **Scalability**: Performance retention under increasing load

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
