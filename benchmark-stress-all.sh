#!/bin/bash

# Run comprehensive stress tests on all language implementations
# Usage: ./benchmark-stress-all.sh

set -e

RESULTS_DIR="stress_test_results"
SUMMARY_FILE="${RESULTS_DIR}/stress_test_summary.md"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# List of languages to test
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

# Create results directory
mkdir -p ${RESULTS_DIR}

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Stress Testing All Languages${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Initialize summary file
cat > ${SUMMARY_FILE} << 'EOF'
# Comprehensive Stress Test Results

## Test Overview

This document contains stress test and resource monitoring results for all language implementations.

### Test Scenarios

1. **Standard Load Test**: 10,000 requests, 100 concurrent
2. **High Concurrency Test**: 100,000 requests, 500 concurrent
3. **Very High Load Test**: 1,000,000 requests, 1000 concurrent
4. **Large Payload Test**: 10,000 requests with resource monitoring
5. **Sustained Load Test**: Continuous load for 5 minutes, 200 concurrent

### Metrics Collected

- **Performance**: Requests/sec, Average latency, Failed requests
- **CPU Usage**: Average and peak utilization
- **Memory Usage**: Average and peak consumption
- **I/O**: Network and disk I/O operations
- **Reliability**: Request failure rates under stress

---

## Results by Language

EOF

# Run stress test for each language
for LANGUAGE in "${LANGUAGES[@]}"; do
    echo -e "${GREEN}=== Stress Testing ${LANGUAGE} ===${NC}"
    
    if [ -d "./${LANGUAGE}" ]; then
        # Run the stress test
        if ./benchmark-stress.sh ${LANGUAGE} 2>&1 | tee ${RESULTS_DIR}/${LANGUAGE}_stress_log.txt; then
            echo -e "${GREEN}${LANGUAGE} stress test completed${NC}"
            
            # Add results to summary
            echo "### ${LANGUAGE^}" >> ${SUMMARY_FILE}
            echo "" >> ${SUMMARY_FILE}
            
            # Extract and format results
            if [ -f ${RESULTS_DIR}/${LANGUAGE}_standard.txt ]; then
                echo "#### Performance Metrics" >> ${SUMMARY_FILE}
                echo "" >> ${SUMMARY_FILE}
                echo "| Test Scenario | Requests/sec | Avg Latency (ms) | Failed | Total Time (s) |" >> ${SUMMARY_FILE}
                echo "|---------------|--------------|------------------|--------|----------------|" >> ${SUMMARY_FILE}
                
                # Standard load
                rps=$(grep "Requests per second:" ${RESULTS_DIR}/${LANGUAGE}_standard.txt 2>/dev/null | awk '{print $4}' || echo "N/A")
                lat=$(grep "Time per request:" ${RESULTS_DIR}/${LANGUAGE}_standard.txt 2>/dev/null | grep "mean" | head -1 | awk '{print $4}' || echo "N/A")
                fail=$(grep "Failed requests:" ${RESULTS_DIR}/${LANGUAGE}_standard.txt 2>/dev/null | awk '{print $3}' || echo "N/A")
                time=$(grep "Time taken for tests:" ${RESULTS_DIR}/${LANGUAGE}_standard.txt 2>/dev/null | awk '{print $5}' || echo "N/A")
                echo "| Standard Load | $rps | $lat | $fail | $time |" >> ${SUMMARY_FILE}
                
                # High concurrency
                rps=$(grep "Requests per second:" ${RESULTS_DIR}/${LANGUAGE}_high_concurrency.txt 2>/dev/null | awk '{print $4}' || echo "N/A")
                lat=$(grep "Time per request:" ${RESULTS_DIR}/${LANGUAGE}_high_concurrency.txt 2>/dev/null | grep "mean" | head -1 | awk '{print $4}' || echo "N/A")
                fail=$(grep "Failed requests:" ${RESULTS_DIR}/${LANGUAGE}_high_concurrency.txt 2>/dev/null | awk '{print $3}' || echo "N/A")
                time=$(grep "Time taken for tests:" ${RESULTS_DIR}/${LANGUAGE}_high_concurrency.txt 2>/dev/null | awk '{print $5}' || echo "N/A")
                echo "| High Concurrency | $rps | $lat | $fail | $time |" >> ${SUMMARY_FILE}
                
                # Very high load
                rps=$(grep "Requests per second:" ${RESULTS_DIR}/${LANGUAGE}_very_high_load.txt 2>/dev/null | awk '{print $4}' || echo "N/A")
                lat=$(grep "Time per request:" ${RESULTS_DIR}/${LANGUAGE}_very_high_load.txt 2>/dev/null | grep "mean" | head -1 | awk '{print $4}' || echo "N/A")
                fail=$(grep "Failed requests:" ${RESULTS_DIR}/${LANGUAGE}_very_high_load.txt 2>/dev/null | awk '{print $3}' || echo "N/A")
                time=$(grep "Time taken for tests:" ${RESULTS_DIR}/${LANGUAGE}_very_high_load.txt 2>/dev/null | awk '{print $5}' || echo "N/A")
                echo "| Very High Load | $rps | $lat | $fail | $time |" >> ${SUMMARY_FILE}
                
                # Sustained load
                rps=$(grep "Requests per second:" ${RESULTS_DIR}/${LANGUAGE}_sustained.txt 2>/dev/null | awk '{print $4}' || echo "N/A")
                lat=$(grep "Time per request:" ${RESULTS_DIR}/${LANGUAGE}_sustained.txt 2>/dev/null | grep "mean" | head -1 | awk '{print $4}' || echo "N/A")
                fail=$(grep "Failed requests:" ${RESULTS_DIR}/${LANGUAGE}_sustained.txt 2>/dev/null | awk '{print $3}' || echo "N/A")
                echo "| Sustained (5min) | $rps | $lat | $fail | 300 |" >> ${SUMMARY_FILE}
                
                echo "" >> ${SUMMARY_FILE}
            fi
            
            # Add resource usage
            echo "#### Resource Usage" >> ${SUMMARY_FILE}
            echo "" >> ${SUMMARY_FILE}
            echo "| Test Scenario | Avg CPU (%) | Peak CPU (%) | Avg Memory (MB) | Peak Memory (MB) |" >> ${SUMMARY_FILE}
            echo "|---------------|-------------|--------------|-----------------|------------------|" >> ${SUMMARY_FILE}
            
            for test_type in "standard" "high_concurrency" "very_high_load" "sustained"; do
                resource_file="${RESULTS_DIR}/${LANGUAGE}_${test_type}_resources.csv"
                if [ -f ${resource_file} ]; then
                    avg_cpu=$(awk -F',' 'NR>1 && $2!="" {sum+=$2; count++} END {if(count>0) printf "%.2f", sum/count; else print "N/A"}' ${resource_file})
                    max_cpu=$(awk -F',' 'NR>1 && $2!="" {if($2>max) max=$2} END {if(max!="") printf "%.2f", max; else print "N/A"}' ${resource_file})
                    avg_mem=$(awk -F',' 'NR>1 && $3!="" {sum+=$3; count++} END {if(count>0) printf "%.2f", sum/count; else print "N/A"}' ${resource_file})
                    max_mem=$(awk -F',' 'NR>1 && $3!="" {if($3>max) max=$3} END {if(max!="") printf "%.2f", max; else print "N/A"}' ${resource_file})
                    
                    test_name=$(echo $test_type | sed 's/_/ /g' | sed 's/\b\(.\)/\u\1/g')
                    echo "| $test_name | $avg_cpu | $max_cpu | $avg_mem | $max_mem |" >> ${SUMMARY_FILE}
                fi
            done
            
            echo "" >> ${SUMMARY_FILE}
            echo "---" >> ${SUMMARY_FILE}
            echo "" >> ${SUMMARY_FILE}
        else
            echo -e "${RED}${LANGUAGE} stress test failed${NC}"
        fi
    else
        echo -e "${YELLOW}${LANGUAGE} directory not found, skipping${NC}"
    fi
    
    echo ""
done

# Generate comparison charts
echo "" >> ${SUMMARY_FILE}
echo "## Performance Comparison" >> ${SUMMARY_FILE}
echo "" >> ${SUMMARY_FILE}
echo "### Standard Load Test Rankings" >> ${SUMMARY_FILE}
echo "" >> ${SUMMARY_FILE}
echo "| Rank | Language | Requests/sec | Avg Latency (ms) |" >> ${SUMMARY_FILE}
echo "|------|----------|--------------|------------------|" >> ${SUMMARY_FILE}

# Extract and sort standard load results
RANK=1
for result_file in ${RESULTS_DIR}/*_standard.txt; do
    if [ -f ${result_file} ]; then
        lang=$(basename ${result_file} | sed 's/_standard.txt//')
        rps=$(grep "Requests per second:" ${result_file} 2>/dev/null | awk '{print $4}' || echo "0")
        lat=$(grep "Time per request:" ${result_file} 2>/dev/null | grep "mean" | head -1 | awk '{print $4}' || echo "N/A")
        echo "${rps}|${lang}|${lat}"
    fi
done | sort -t'|' -k1 -nr | while IFS='|' read -r rps lang lat; do
    echo "| ${RANK} | **${lang}** | ${rps} | ${lat} |" >> ${SUMMARY_FILE}
    RANK=$((RANK + 1))
done

echo "" >> ${SUMMARY_FILE}
echo "### Resource Efficiency Rankings (Standard Load)" >> ${SUMMARY_FILE}
echo "" >> ${SUMMARY_FILE}
echo "Sorted by average CPU usage (lower is better):" >> ${SUMMARY_FILE}
echo "" >> ${SUMMARY_FILE}
echo "| Rank | Language | Avg CPU (%) | Avg Memory (MB) |" >> ${SUMMARY_FILE}
echo "|------|----------|-------------|-----------------|" >> ${SUMMARY_FILE}

RANK=1
for resource_file in ${RESULTS_DIR}/*_standard_resources.csv; do
    if [ -f ${resource_file} ]; then
        lang=$(basename ${resource_file} | sed 's/_standard_resources.csv//')
        avg_cpu=$(awk -F',' 'NR>1 && $2!="" {sum+=$2; count++} END {if(count>0) print sum/count; else print "999"}' ${resource_file})
        avg_mem=$(awk -F',' 'NR>1 && $3!="" {sum+=$3; count++} END {if(count>0) printf "%.2f", sum/count; else print "N/A"}' ${resource_file})
        echo "${avg_cpu}|${lang}|${avg_mem}"
    fi
done | sort -t'|' -k1 -n | while IFS='|' read -r cpu lang mem; do
    if [ "$cpu" != "999" ]; then
        cpu_formatted=$(printf "%.2f" $cpu)
        echo "| ${RANK} | **${lang}** | ${cpu_formatted} | ${mem} |" >> ${SUMMARY_FILE}
        RANK=$((RANK + 1))
    fi
done

echo "" >> ${SUMMARY_FILE}
echo "## Conclusions" >> ${SUMMARY_FILE}
echo "" >> ${SUMMARY_FILE}
echo "- **Throughput Leader**: Language with highest requests/sec under standard load" >> ${SUMMARY_FILE}
echo "- **Stress Resilience**: Languages maintaining low failure rates under extreme load" >> ${SUMMARY_FILE}
echo "- **Resource Efficiency**: Languages with lowest CPU and memory consumption" >> ${SUMMARY_FILE}
echo "- **Scalability**: Languages maintaining performance under high concurrency" >> ${SUMMARY_FILE}
echo "" >> ${SUMMARY_FILE}
echo "Complete test logs and raw data available in: \`${RESULTS_DIR}/\`" >> ${SUMMARY_FILE}

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  All Stress Tests Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${GREEN}Summary report: ${SUMMARY_FILE}${NC}"
echo -e "${GREEN}Detailed results: ${RESULTS_DIR}/${NC}"
