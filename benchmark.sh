#!/bin/bash

# HTTP Server Benchmark Script
# Usage: ./benchmark.sh [language] [tool]
# Example: ./benchmark.sh rust wrk

set -e

LANGUAGE=${1:-rust}
TOOL=${2:-ab}
PORT=8080
URL="http://localhost:${PORT}/hello"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Web Server Benchmark ===${NC}"
echo -e "Language: ${YELLOW}${LANGUAGE}${NC}"
echo -e "Tool: ${YELLOW}${TOOL}${NC}"
echo ""

# Build the Docker image
echo -e "${GREEN}Building Docker image...${NC}"
docker build -t benchmark-${LANGUAGE} ./${LANGUAGE}/

# Start the server
echo -e "${GREEN}Starting server...${NC}"
CONTAINER_ID=$(docker run -d -p ${PORT}:8080 benchmark-${LANGUAGE})

# Wait for server to be ready
echo -e "${GREEN}Waiting for server to start...${NC}"
sleep 3

# Test endpoint
echo -e "${GREEN}Testing endpoint...${NC}"
RESPONSE=$(curl -s ${URL})
echo "Response: ${RESPONSE}"
echo ""

# Run benchmark based on tool
echo -e "${GREEN}Running benchmark...${NC}"
case ${TOOL} in
  ab)
    # Apache Bench
    ab -n 10000 -c 100 ${URL}
    ;;
  wrk)
    # wrk
    wrk -t4 -c100 -d30s ${URL}
    ;;
  hey)
    # hey
    hey -n 10000 -c 100 ${URL}
    ;;
  *)
    echo -e "${RED}Unknown tool: ${TOOL}${NC}"
    echo "Available tools: ab, wrk, hey"
    ;;
esac

# Cleanup
echo ""
echo -e "${GREEN}Stopping server...${NC}"
docker stop ${CONTAINER_ID} > /dev/null
docker rm ${CONTAINER_ID} > /dev/null

echo -e "${GREEN}Benchmark complete!${NC}"
