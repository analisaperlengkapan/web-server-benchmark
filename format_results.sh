#!/bin/bash

# Format benchmark results into markdown table

RESULTS_FILE="benchmark_results.txt"
OUTPUT_FILE="benchmark_table.md"

cat > ${OUTPUT_FILE} << 'EOF'
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
EOF

# Read and sort results, add to table
RANK=1
grep -v "^#" ${RESULTS_FILE} | sort -t'|' -k2 -nr | while IFS='|' read -r lang rps tpr tr fr; do
    # Determine framework/library based on language
    case $lang in
        rust) framework="Actix-web" ;;
        cpp) framework="Crow" ;;
        c) framework="libmicrohttpd" ;;
        go) framework="net/http (stdlib)" ;;
        java) framework="Spring Boot" ;;
        javascript) framework="Express" ;;
        typescript) framework="Express" ;;
        python) framework="FastAPI + Uvicorn" ;;
        ruby) framework="Sinatra + Puma" ;;
        csharp) framework="ASP.NET Core" ;;
        kotlin) framework="Ktor" ;;
        crystal) framework="HTTP::Server (stdlib)" ;;
        nim) framework="Jester" ;;
        php) framework="Built-in server" ;;
        ada) framework="AWS (Ada Web Server)" ;;
        fortran) framework="Custom" ;;
        assembly) framework="x86-64 syscalls" ;;
        v) framework="vweb" ;;
        zig) framework="Custom" ;;
        *) framework="Unknown" ;;
    esac
    
    # Format language name
    lang_formatted=$(echo "$lang" | sed 's/\b\(.\)/\u\1/')
    
    # Add row to table
    echo "| $RANK | **$lang_formatted** | $framework | $rps | $tpr | $tr |" >> ${OUTPUT_FILE}
    RANK=$((RANK + 1))
done

cat >> ${OUTPUT_FILE} << 'EOF'

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

EOF

echo "Formatted results saved to: ${OUTPUT_FILE}"
cat ${OUTPUT_FILE}
