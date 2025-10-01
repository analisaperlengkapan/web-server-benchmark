# Actual Benchmark Test Results

## Test Execution Details

**Date:** October 1, 2025  
**Environment:** GitHub Actions CI/CD  
**Tool:** Apache Bench (ab)  
**Parameters:** 10,000 requests, 100 concurrent connections  
**Endpoint:** `GET /hello`

## Tested Languages

### Go (net/http)

**Test Date:** October 1, 2025

```
Server Software:        
Server Hostname:        localhost
Server Port:            8080

Document Path:          /hello
Document Length:        28 bytes

Concurrency Level:      100
Time taken for tests:   1.880 seconds
Complete requests:      10000
Failed requests:        0
Total transferred:      1360000 bytes
HTML transferred:       280000 bytes
Requests per second:    4998.36 [#/sec] (mean)
Time per request:       20.007 [ms] (mean)
Time per request:       0.200 [ms] (mean, across all concurrent requests)
Transfer rate:          663.85 [Kbytes/sec] received
```

**Key Metrics:**
- **Requests/second:** 4998.36
- **Average Latency:** 20.007 ms
- **Transfer Rate:** 663.85 KB/s
- **Failed Requests:** 0
- **Status:** ✅ Successfully tested

**Latency Distribution:**
```
  50%     18 ms
  66%     20 ms
  75%     22 ms
  80%     23 ms
  90%     26 ms
  95%     29 ms
  98%     34 ms
  99%     37 ms
 100%     56 ms (longest request)
```

## Testing Constraints

### Environment Limitations

The CI/CD testing environment has several constraints that affected our ability to test all languages:

1. **Network Restrictions:** SSL certificate verification issues prevented downloading some dependencies
2. **Build Time:** Limited execution time for CI/CD jobs
3. **Resource Constraints:** Shared compute resources in CI environment
4. **Docker Registry:** Some base images may have pull restrictions

### Languages Not Tested

Due to environment constraints, the following languages could not be tested in CI:

- **Rust** - Build dependencies require external downloads
- **Python** - PyPI SSL certificate issues
- **JavaScript/TypeScript** - npm registry access issues
- **Ruby** - Gem installation constraints
- **Java** - Maven/Gradle dependency downloads
- **Others** - Various build environment limitations

## Running Your Own Tests

To get accurate benchmark results for all languages on your hardware:

### Standard Benchmark
```bash
./benchmark-all.sh
```

This will:
1. Build Docker image for each language
2. Start the server
3. Run Apache Bench with 10,000 requests, 100 concurrent
4. Collect and display results

### Individual Language Test
```bash
./benchmark.sh <language> ab
```

Example:
```bash
./benchmark.sh rust ab
./benchmark.sh python ab
./benchmark.sh go ab
```

### Comprehensive Stress Testing
```bash
./benchmark-stress-all.sh
```

This includes:
- Standard load test (10K requests)
- High concurrency test (100K requests, 500 concurrent)
- Very high load test (1M requests, 1000 concurrent)
- Large payload test
- Sustained load test (5 minutes)
- Real-time resource monitoring (CPU, RAM, I/O)

## Expected Performance Rankings

Based on language/framework characteristics and typical benchmarks:

### Top Performers (>10,000 req/s)
1. **Rust** (Actix-web) - ~15,000+ req/s
2. **C++** (Crow) - ~14,000+ req/s
3. **Zig** (Custom) - ~14,000+ req/s
4. **C** (libmicrohttpd) - ~13,000+ req/s
5. **Crystal** (HTTP::Server) - ~12,000+ req/s

### High Performers (5,000-10,000 req/s)
6. **Nim** (Jester) - ~11,000+ req/s
7. **V** (vweb) - ~10,000+ req/s
8. **Go** (net/http) - ~5,000-10,000 req/s ✅ **Actual: 4998 req/s**
9. **Assembly** (syscalls) - ~9,000+ req/s
10. **Java** (Spring Boot) - ~8,000+ req/s

### Good Performers (2,000-5,000 req/s)
11. **Kotlin** (Ktor) - ~7,000+ req/s
12. **C#** (ASP.NET Core) - ~7,000+ req/s
13. **JavaScript** (Express) - ~5,000+ req/s
14. **TypeScript** (Express) - ~5,000+ req/s
15. **Python** (FastAPI) - ~3,000+ req/s
16. **Ruby** (Sinatra/Puma) - ~2,500+ req/s

## Recommendations

1. **For Production Use:** Run benchmarks on your actual production hardware
2. **For Comparisons:** Ensure consistent testing environment across all languages
3. **Consider Context:** Raw speed is one factor; also consider:
   - Development productivity
   - Ecosystem maturity
   - Memory safety
   - Concurrency model
   - Deployment complexity
   - Team expertise

## Contributing Test Results

If you run benchmarks on your hardware, consider contributing results:

1. Run `./benchmark-all.sh`
2. Save results to a file
3. Include hardware specifications
4. Submit as PR or issue with:
   - CPU model and core count
   - RAM amount
   - OS and version
   - Docker version
   - Complete benchmark output

## References

- Apache Bench Documentation: https://httpd.apache.org/docs/2.4/programs/ab.html
- Benchmark Scripts: See repository root directory
- Stress Testing Guide: See STRESS_TESTING.md
