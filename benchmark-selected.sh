#!/bin/bash

# Benchmark selected language implementations
# Usage: ./benchmark-selected.sh

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

# List of languages to benchmark (simplified list that should work in most environments)
LANGUAGES=(
    "go"
    "javascript"
    "typescript"
    "php"
)

# Clear previous results
> ${RESULTS_FILE}

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Web Server Benchmark - Selected Languages${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to benchmark a language
benchmark_language() {
    local LANGUAGE=$1
    
    echo -e "${GREEN}=== Benchmarking ${LANGUAGE} ===${NC}"
    
    # Build the Docker image
    echo -e "${YELLOW}Building Docker image...${NC}"
    if ! docker build -t benchmark-${LANGUAGE} ./${LANGUAGE}/ > /tmp/build_${LANGUAGE}.log 2>&1; then
        echo -e "${RED}Failed to build ${LANGUAGE}${NC}"
        cat /tmp/build_${LANGUAGE}.log | tail -20
        echo "${LANGUAGE}|BUILD_FAILED|N/A|N/A|N/A" >> ${RESULTS_FILE}
        echo ""
        return 1
    fi
    echo -e "${GREEN}Build successful${NC}"
    
    # Start the server
    echo -e "${YELLOW}Starting server...${NC}"
    CONTAINER_ID=$(docker run -d -p ${PORT}:8080 benchmark-${LANGUAGE})
    
    # Wait for server to be ready
    echo -e "${YELLOW}Waiting for server to start...${NC}"
    sleep 5
    
    # Test endpoint with retries
    echo -e "${YELLOW}Testing endpoint...${NC}"
    local MAX_RETRIES=5
    local RETRY=0
    local RESPONSE=""
    
    while [ $RETRY -lt $MAX_RETRIES ]; do
        RESPONSE=$(curl -s ${URL} 2>/dev/null || echo "")
        if [ -n "$RESPONSE" ] && [ "$RESPONSE" != "FAILED" ]; then
            break
        fi
        RETRY=$((RETRY + 1))
        echo "Retry $RETRY/$MAX_RETRIES..."
        sleep 2
    done
    
    if [ -z "$RESPONSE" ] || [ "$RESPONSE" == "FAILED" ]; then
        echo -e "${RED}Server failed to respond${NC}"
        docker logs ${CONTAINER_ID} | tail -20
        docker stop ${CONTAINER_ID} > /dev/null 2>&1
        docker rm ${CONTAINER_ID} > /dev/null 2>&1
        echo "${LANGUAGE}|SERVER_FAILED|N/A|N/A|N/A" >> ${RESULTS_FILE}
        echo ""
        return 1
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
    return 0
}

# Benchmark each language
for LANGUAGE in "${LANGUAGES[@]}"; do
    benchmark_language ${LANGUAGE}
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
printf "%-15s | %-15s | %-20s | %-10s\n" "Language" "Req/sec" "Time/req (ms)" "Failed"
echo "----------------|-----------------|----------------------|-----------"

# Sort and display results
sort -t'|' -k2 -nr ${RESULTS_FILE} | while IFS='|' read -r lang rps tpr tr fr; do
    if [ "$rps" != "BUILD_FAILED" ] && [ "$rps" != "SERVER_FAILED" ]; then
        printf "%-15s | %-15s | %-20s | %-10s\n" "$lang" "$rps" "$tpr" "$fr"
    else
        printf "%-15s | %-15s | %-20s | %-10s\n" "$lang" "$rps" "N/A" "N/A"
    fi
done
