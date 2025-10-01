# Python HTTP Server

Production-optimized HTTP server using FastAPI and Uvicorn.

## Build & Run

### With Docker
```bash
docker build -t benchmark-python .
docker run -p 8080:8080 benchmark-python
```

### Local Development
```bash
pip install -r requirements.txt
python main.py
```

## Test
```bash
curl http://localhost:8080/hello
```

Expected response:
```json
{"message":"Hello, world!"}
```

## Optimizations

- FastAPI for high-performance async API
- Uvicorn with standard extras for optimized ASGI server
- Python 3.11 for improved performance
