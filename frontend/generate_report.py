import re
import os

def parse_benchmark_results(filepath):
    results = []
    if not os.path.exists(filepath):
        print(f"Warning: {filepath} not found.")
        return results

    with open(filepath, 'r') as f:
        lines = f.readlines()

    # Skip header
    for line in lines:
        if line.strip().startswith('|') and 'Language' not in line and '---' not in line:
            parts = [p.strip() for p in line.split('|') if p.strip()]
            if len(parts) >= 5:
                # Name, Req/sec, Latency, CPU, Memory
                name = parts[0].replace('**', '')
                req_sec = float(parts[1])
                latency = float(parts[2].replace('ms', ''))
                cpu = float(parts[3])
                memory = parts[4]
                results.append({
                    'name': name,
                    'req_sec': req_sec,
                    'latency': latency,
                    'cpu': cpu,
                    'memory': memory
                })
    return results

def generate_html(results, output_path):
    labels = [r['name'] for r in results]
    data_req = [r['req_sec'] for r in results]
    data_lat = [r['latency'] for r in results]

    html = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Benchmark Results</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {{ font-family: sans-serif; padding: 20px; }}
        .container {{ max_width: 800px; margin: 0 auto; }}
        table {{ width: 100%; border-collapse: collapse; margin-top: 20px; }}
        th, td {{ border: 1px solid #ddd; padding: 8px; text-align: left; }}
        th {{ background-color: #f2f2f2; }}
    </style>
</head>
<body>
    <div class="container">
        <h1>Benchmark Results</h1>
        <canvas id="benchmarkChart"></canvas>
        <table>
            <thead>
                <tr>
                    <th>Language</th>
                    <th>Requests/sec</th>
                    <th>Avg Latency (ms)</th>
                    <th>Peak CPU (%)</th>
                    <th>Peak Memory</th>
                </tr>
            </thead>
            <tbody>
"""
    for r in results:
        html += f"""
                <tr>
                    <td>{r['name']}</td>
                    <td>{r['req_sec']}</td>
                    <td>{r['latency']}</td>
                    <td>{r['cpu']}</td>
                    <td>{r['memory']}</td>
                </tr>
"""
    html += """
            </tbody>
        </table>
    </div>
    <script>
        const ctx = document.getElementById('benchmarkChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: """ + str(labels) + """,
                datasets: [{
                    label: 'Requests/sec',
                    data: """ + str(data_req) + """,
                    backgroundColor: 'rgba(54, 162, 235, 0.5)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1,
                    yAxisID: 'y'
                }, {
                    label: 'Latency (ms)',
                    data: """ + str(data_lat) + """,
                    backgroundColor: 'rgba(255, 99, 132, 0.5)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1,
                    yAxisID: 'y1'
                }]
            },
            options: {
                scales: {
                    y: {
                        type: 'linear',
                        display: true,
                        position: 'left',
                        title: { display: true, text: 'Requests/sec' }
                    },
                    y1: {
                        type: 'linear',
                        display: true,
                        position: 'right',
                        grid: { drawOnChartArea: false },
                        title: { display: true, text: 'Latency (ms)' }
                    }
                }
            }
        });
    </script>
</body>
</html>
"""
    with open(output_path, 'w') as f:
        f.write(html)
    print(f"Report generated at {output_path}")

if __name__ == "__main__":
    results = parse_benchmark_results('stress_summary.md')
    generate_html(results, 'frontend/index.html')
