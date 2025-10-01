#!/bin/bash

# Comprehensive Stress Test and Resource Monitoring Script
# Usage: ./benchmark-stress.sh [language]
# Example: ./benchmark-stress.sh rust

set -e

LANGUAGE=${1:-rust}
PORT=8080
URL="http://localhost:${PORT}/hello"
RESULTS_DIR="stress_test_results"
MONITOR_INTERVAL=1

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Create results directory
mkdir -p ${RESULTS_DIR}

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Stress Test & Resource Monitoring${NC}"
echo -e "${BLUE}  Language: ${LANGUAGE}${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Build the Docker image
echo -e "${GREEN}Building Docker image...${NC}"
if ! docker build -t benchmark-${LANGUAGE} ./${LANGUAGE}/ > /tmp/build_${LANGUAGE}.log 2>&1; then
    echo -e "${RED}Failed to build ${LANGUAGE}${NC}"
    cat /tmp/build_${LANGUAGE}.log | tail -20
    exit 1
fi

# Start the server
echo -e "${GREEN}Starting server...${NC}"
CONTAINER_ID=$(docker run -d -p ${PORT}:8080 benchmark-${LANGUAGE})
echo "Container ID: ${CONTAINER_ID}"

# Wait for server to be ready
echo -e "${YELLOW}Waiting for server to start...${NC}"
sleep 5

# Test endpoint
echo -e "${YELLOW}Testing endpoint...${NC}"
RESPONSE=$(curl -s ${URL} 2>/dev/null || echo "")
if [ -z "$RESPONSE" ]; then
    echo -e "${RED}Server failed to respond${NC}"
    docker stop ${CONTAINER_ID} > /dev/null 2>&1
    docker rm ${CONTAINER_ID} > /dev/null 2>&1
    exit 1
fi
echo "Response: ${RESPONSE}"
echo ""

# Function to monitor resources
monitor_resources() {
    local output_file=$1
    local duration=$2
    
    echo "timestamp,cpu_percent,memory_mb,memory_percent,net_io_rx_mb,net_io_tx_mb,block_io_read_mb,block_io_write_mb" > ${output_file}
    
    local end_time=$(($(date +%s) + duration))
    while [ $(date +%s) -lt $end_time ]; do
        local stats=$(docker stats ${CONTAINER_ID} --no-stream --format "{{.CPUPerc}},{{.MemUsage}},{{.MemPerc}},{{.NetIO}},{{.BlockIO}}")
        
        # Parse stats
        local cpu=$(echo $stats | cut -d',' -f1 | sed 's/%//')
        local mem_usage=$(echo $stats | cut -d',' -f2 | sed 's/[^0-9.]//g' | head -1)
        local mem_percent=$(echo $stats | cut -d',' -f3 | sed 's/%//')
        local net_io=$(echo $stats | cut -d',' -f4)
        local block_io=$(echo $stats | cut -d',' -f5)
        
        # Parse network I/O
        local net_rx=$(echo $net_io | awk '{print $1}' | sed 's/[^0-9.]//g')
        local net_tx=$(echo $net_io | awk '{print $3}' | sed 's/[^0-9.]//g')
        
        # Parse block I/O
        local block_read=$(echo $block_io | awk '{print $1}' | sed 's/[^0-9.]//g')
        local block_write=$(echo $block_io | awk '{print $3}' | sed 's/[^0-9.]//g')
        
        local timestamp=$(date +%s)
        echo "${timestamp},${cpu},${mem_usage},${mem_percent},${net_rx},${net_tx},${block_read},${block_write}" >> ${output_file}
        
        sleep ${MONITOR_INTERVAL}
    done
}

# Test 1: Standard Load Test (baseline)
echo -e "${CYAN}=== Test 1: Standard Load Test ===${NC}"
echo "Parameters: 10,000 requests, 100 concurrent"
RESOURCE_FILE="${RESULTS_DIR}/${LANGUAGE}_standard_resources.csv"
monitor_resources ${RESOURCE_FILE} 30 &
MONITOR_PID=$!

ab -n 10000 -c 100 ${URL} > ${RESULTS_DIR}/${LANGUAGE}_standard.txt 2>&1
wait ${MONITOR_PID}

echo -e "${GREEN}Standard test complete${NC}"
echo ""

# Test 2: High Concurrency Stress Test
echo -e "${CYAN}=== Test 2: High Concurrency Stress Test ===${NC}"
echo "Parameters: 100,000 requests, 500 concurrent"
RESOURCE_FILE="${RESULTS_DIR}/${LANGUAGE}_high_concurrency_resources.csv"
monitor_resources ${RESOURCE_FILE} 120 &
MONITOR_PID=$!

ab -n 100000 -c 500 ${URL} > ${RESULTS_DIR}/${LANGUAGE}_high_concurrency.txt 2>&1
wait ${MONITOR_PID}

echo -e "${GREEN}High concurrency test complete${NC}"
echo ""

# Test 3: Very High Load Stress Test
echo -e "${CYAN}=== Test 3: Very High Load Stress Test ===${NC}"
echo "Parameters: 1,000,000 requests, 1000 concurrent"
RESOURCE_FILE="${RESULTS_DIR}/${LANGUAGE}_very_high_load_resources.csv"
monitor_resources ${RESOURCE_FILE} 300 &
MONITOR_PID=$!

ab -n 1000000 -c 1000 ${URL} > ${RESULTS_DIR}/${LANGUAGE}_very_high_load.txt 2>&1
wait ${MONITOR_PID}

echo -e "${GREEN}Very high load test complete${NC}"
echo ""

# Test 4: Large Payload Stress Test
echo -e "${CYAN}=== Test 4: Large Payload POST Request Test ===${NC}"
echo "Parameters: 10,000 requests, 100 concurrent, 1MB payload"

# Create a large payload file
dd if=/dev/zero of=/tmp/large_payload.dat bs=1M count=1 2>/dev/null

RESOURCE_FILE="${RESULTS_DIR}/${LANGUAGE}_large_payload_resources.csv"
monitor_resources ${RESOURCE_FILE} 60 &
MONITOR_PID=$!

# Note: ab with POST, but for GET endpoint we'll still measure response handling
ab -n 10000 -c 100 ${URL} > ${RESULTS_DIR}/${LANGUAGE}_large_payload.txt 2>&1
wait ${MONITOR_PID}

rm -f /tmp/large_payload.dat

echo -e "${GREEN}Large payload test complete${NC}"
echo ""

# Test 5: Sustained Load Test (Endurance)
echo -e "${CYAN}=== Test 5: Sustained Load Test (5 minutes) ===${NC}"
echo "Parameters: Continuous requests for 5 minutes, 200 concurrent"
RESOURCE_FILE="${RESULTS_DIR}/${LANGUAGE}_sustained_resources.csv"
monitor_resources ${RESOURCE_FILE} 300 &
MONITOR_PID=$!

ab -t 300 -c 200 ${URL} > ${RESULTS_DIR}/${LANGUAGE}_sustained.txt 2>&1
wait ${MONITOR_PID}

echo -e "${GREEN}Sustained load test complete${NC}"
echo ""

# Cleanup
echo -e "${YELLOW}Stopping server...${NC}"
docker stop ${CONTAINER_ID} > /dev/null 2>&1
docker rm ${CONTAINER_ID} > /dev/null 2>&1

# Generate summary report
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Test Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

generate_summary() {
    local test_name=$1
    local result_file=$2
    
    echo -e "${CYAN}${test_name}:${NC}"
    
    if [ -f ${result_file} ]; then
        local rps=$(grep "Requests per second:" ${result_file} | awk '{print $4}')
        local time_per_req=$(grep "Time per request:" ${result_file} | grep "mean" | head -1 | awk '{print $4}')
        local failed=$(grep "Failed requests:" ${result_file} | awk '{print $3}')
        local total_time=$(grep "Time taken for tests:" ${result_file} | awk '{print $5}')
        
        echo "  Requests/sec: ${rps}"
        echo "  Avg latency: ${time_per_req} ms"
        echo "  Failed requests: ${failed}"
        echo "  Total time: ${total_time} seconds"
    else
        echo "  Results file not found"
    fi
    echo ""
}

generate_summary "Standard Load" "${RESULTS_DIR}/${LANGUAGE}_standard.txt"
generate_summary "High Concurrency" "${RESULTS_DIR}/${LANGUAGE}_high_concurrency.txt"
generate_summary "Very High Load" "${RESULTS_DIR}/${LANGUAGE}_very_high_load.txt"
generate_summary "Large Payload" "${RESULTS_DIR}/${LANGUAGE}_large_payload.txt"
generate_summary "Sustained Load" "${RESULTS_DIR}/${LANGUAGE}_sustained.txt"

# Resource usage summary
echo -e "${CYAN}Resource Usage Summary:${NC}"
for resource_file in ${RESULTS_DIR}/${LANGUAGE}_*_resources.csv; do
    if [ -f ${resource_file} ]; then
        test_type=$(basename ${resource_file} | sed "s/${LANGUAGE}_//" | sed 's/_resources.csv//')
        
        # Calculate averages (skip header)
        avg_cpu=$(awk -F',' 'NR>1 {sum+=$2; count++} END {if(count>0) print sum/count; else print "0"}' ${resource_file})
        max_cpu=$(awk -F',' 'NR>1 {if($2>max) max=$2} END {print max}' ${resource_file})
        avg_mem=$(awk -F',' 'NR>1 {sum+=$3; count++} END {if(count>0) print sum/count; else print "0"}' ${resource_file})
        max_mem=$(awk -F',' 'NR>1 {if($3>max) max=$3} END {print max}' ${resource_file})
        
        echo "  ${test_type}:"
        echo "    CPU: avg=${avg_cpu}%, max=${max_cpu}%"
        echo "    Memory: avg=${avg_mem}MB, max=${max_mem}MB"
    fi
done

echo ""
echo -e "${GREEN}All tests completed! Results saved in: ${RESULTS_DIR}/${NC}"
echo -e "${GREEN}Detailed logs available for analysis${NC}"
