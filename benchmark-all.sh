#!/bin/bash

# Benchmark all language implementations
# Usage: ./benchmark-all.sh

set -e

PORT=8080
URL="http://localhost:${PORT}/hello"
RESULTS_FILE="benchmark_results.txt"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# List of all languages to benchmark
LANGUAGES=(
    "rust"
    "go"
    "c"
    "cpp"
    "crystal"
    "zig"
    "nim"
    "v"
    "assembly"
    "java"
    "kotlin"
    "csharp"
    "javascript"
    "typescript"
    "python"
    "ruby"
    "php"
    "ada"
    "fortran"
)

# Clear previous results
> ${RESULTS_FILE}

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Web Server Benchmark - All Languages${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Benchmark each language
for LANGUAGE in "${LANGUAGES[@]}"; do
    echo -e "${GREEN}=== Benchmarking ${LANGUAGE} ===${NC}"
    
    # Build the Docker image
    echo -e "${YELLOW}Building Docker image...${NC}"
    if ! docker build -t benchmark-${LANGUAGE} ./${LANGUAGE}/ 2>&1 | tail -5; then
        echo -e "${RED}Failed to build ${LANGUAGE}${NC}"
        echo "${LANGUAGE}: BUILD_FAILED" >> ${RESULTS_FILE}
        echo ""
        continue
    fi
    
    # Start the server
    echo -e "${YELLOW}Starting server...${NC}"
    CONTAINER_ID=$(docker run -d -p ${PORT}:8080 benchmark-${LANGUAGE})
    
    # Wait for server to be ready
    sleep 5
    
    # Test endpoint
    echo -e "${YELLOW}Testing endpoint...${NC}"
    RESPONSE=$(curl -s ${URL} || echo "FAILED")
    if [ "$RESPONSE" == "FAILED" ]; then
        echo -e "${RED}Server failed to respond${NC}"
        docker stop ${CONTAINER_ID} > /dev/null 2>&1
        docker rm ${CONTAINER_ID} > /dev/null 2>&1
        echo "${LANGUAGE}: SERVER_FAILED" >> ${RESULTS_FILE}
        echo ""
        continue
    fi
    echo "Response: ${RESPONSE}"
    
    # Run benchmark with Apache Bench
    echo -e "${YELLOW}Running benchmark (10000 requests, 100 concurrent)...${NC}"
    AB_OUTPUT=$(ab -n 10000 -c 100 ${URL} 2>&1)
    
    # Extract key metrics
    REQUESTS_PER_SEC=$(echo "$AB_OUTPUT" | grep "Requests per second:" | awk '{print $4}')
    TIME_PER_REQUEST=$(echo "$AB_OUTPUT" | grep "Time per request:" | grep "mean" | head -1 | awk '{print $4}')
    TRANSFER_RATE=$(echo "$AB_OUTPUT" | grep "Transfer rate:" | awk '{print $3}')
    FAILED_REQUESTS=$(echo "$AB_OUTPUT" | grep "Failed requests:" | awk '{print $3}')
    
    # Save results
    echo "${LANGUAGE}|${REQUESTS_PER_SEC}|${TIME_PER_REQUEST}|${TRANSFER_RATE}|${FAILED_REQUESTS}" >> ${RESULTS_FILE}
    
    echo -e "${GREEN}Results: ${REQUESTS_PER_SEC} req/sec, ${TIME_PER_REQUEST} ms/req${NC}"
    
    # Cleanup
    echo -e "${YELLOW}Stopping server...${NC}"
    docker stop ${CONTAINER_ID} > /dev/null 2>&1
    docker rm ${CONTAINER_ID} > /dev/null 2>&1
    
    echo ""
done

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Benchmark Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Results saved to: ${RESULTS_FILE}"
echo ""

# Display summary
echo -e "${GREEN}Summary (sorted by requests per second):${NC}"
echo ""
printf "%-15s | %-15s | %-20s\n" "Language" "Req/sec" "Time/req (ms)"
echo "----------------|-----------------|---------------------"

# Sort and display results
sort -t'|' -k2 -nr ${RESULTS_FILE} | while IFS='|' read -r lang rps tpr tr fr; do
    if [ "$rps" != "BUILD_FAILED" ] && [ "$rps" != "SERVER_FAILED" ]; then
        printf "%-15s | %-15s | %-20s\n" "$lang" "$rps" "$tpr"
    else
        printf "%-15s | %-15s | %-20s\n" "$lang" "$rps" "N/A"
    fi
done
