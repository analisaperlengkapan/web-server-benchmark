<?php
header('Content-Type: application/json');

$uri = $_SERVER['REQUEST_URI'];

if ($uri === '/hello') {
    echo json_encode(['message' => 'Hello, world!']);
} else {
    http_response_code(404);
    echo json_encode(['error' => 'Not found']);
}
