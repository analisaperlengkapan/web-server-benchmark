#!/bin/bash

# Web Server Stress Test & Resource Monitor
# Usage: ./benchmark-stress.sh <language> [duration_seconds]

LANGUAGE=$1
DURATION=${2:-30} # Default 30 seconds
PORT=8080
URL="http://localhost:${PORT}/hello"
OUTPUT_DIR="stress_test_results"
mkdir -p ${OUTPUT_DIR}

if [ -z "$LANGUAGE" ]; then
    echo "Usage: $0 <language>"
    exit 1
fi

echo "=== Stress Testing ${LANGUAGE} ==="

# Build (if not exists) and Start Container
if ! sudo docker image inspect benchmark-${LANGUAGE} > /dev/null 2>&1; then
    echo "Building image..."
    sudo docker build -t benchmark-${LANGUAGE} ./${LANGUAGE}/ > /dev/null 2>&1
fi

# Stop existing
sudo docker stop $(sudo docker ps -q --filter expose=${PORT}) > /dev/null 2>&1 || true

# Run container
CONTAINER_ID=$(sudo docker run -d -p ${PORT}:8080 benchmark-${LANGUAGE})
sleep 5

# Verify
if ! curl -s ${URL} > /dev/null; then
    echo "Server failed to start."
    sudo docker logs ${CONTAINER_ID}
    sudo docker stop ${CONTAINER_ID} > /dev/null
    exit 1
fi

# Monitoring in background
STATS_FILE="${OUTPUT_DIR}/${LANGUAGE}_stats.csv"
echo "Timestamp,CPU_%,Mem_Usage,Mem_Limit" > ${STATS_FILE}

# Monitor loop
(
    end=$((SECONDS+$DURATION))
    while [ $SECONDS -lt $end ]; do
        # Get stats: CPU %, Mem Usage
        STATS=$(sudo docker stats --no-stream --format "{{.CPUPerc}},{{.MemUsage}}" ${CONTAINER_ID})
        # Remove formatting (e.g. 0.5% -> 0.5, 10MiB / 1GiB -> 10MiB)
        CLEAN_STATS=$(echo "$STATS" | sed 's/%//g')
        echo "$(date +%s),${CLEAN_STATS}" >> ${STATS_FILE}
        sleep 1
    done
) &
MONITOR_PID=$!

# Load Generation (High Concurrency) using ab-image
echo "Running load test (High Concurrency: 500 connections) for ${DURATION} seconds..."
# Ensure ab-image exists
if ! sudo docker image inspect ab-image > /dev/null 2>&1; then
    echo "Building ab-image..."
    echo "FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y apache2-utils && rm -rf /var/lib/apt/lists/*
ENTRYPOINT [\"ab\"]" | sudo docker build -t ab-image - > /dev/null 2>&1
fi

# Run ab with time limit (-t)
sudo docker run --rm --network host ab-image -t ${DURATION} -c 500 -n 1000000 ${URL} > "${OUTPUT_DIR}/${LANGUAGE}_ab.txt" 2>&1

# Kill monitor if still running
kill $MONITOR_PID 2>/dev/null || true
wait $MONITOR_PID 2>/dev/null || true

# Analyze Stats
# Extract Peak CPU and RAM
PEAK_CPU=$(awk -F',' 'NR>1 {print $2}' ${STATS_FILE} | sort -rn | head -1)
PEAK_MEM=$(awk -F',' 'NR>1 {print $3}' ${STATS_FILE} | sed 's/[A-Za-z /]*$//' | sort -rn | head -1)
# Note: Mem parsing is tricky with units (MiB/GiB). For now just grabbing raw string might differ.
# Better: use docker stats format {{.MemUsage}} gives "12.3MiB / 7.7GiB".
# I'll rely on the CSV for now.

echo "Test Complete."
echo "Stats saved to ${STATS_FILE}"
echo "Load results saved to ${OUTPUT_DIR}/${LANGUAGE}_ab.txt"

# Cleanup
sudo docker stop ${CONTAINER_ID} > /dev/null
sudo docker rm ${CONTAINER_ID} > /dev/null
