# Benchmark Report Generator

This directory contains the frontend component for the Web Server Benchmark suite.

## Purpose

The `generate_report.py` script parses the benchmark results from `stress_summary.md` and generates a static HTML report (`index.html`) visualizing the performance data (Requests/sec and Latency) using Chart.js.

## Usage

The report generator is automatically integrated into the main benchmark script `benchmark-stress-all.sh`.

To run it manually:

```bash
python3 frontend/generate_report.py
```

This assumes `stress_summary.md` exists in the repository root.

## Output

The script generates `frontend/index.html`. Open this file in a web browser to view the benchmark results.
