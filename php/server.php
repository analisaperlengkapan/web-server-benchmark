<?php
require_once __DIR__ . '/vendor/autoload.php';

use Workerman\Worker;
use Workerman\Protocols\Http\Response;

$worker = new Worker('http://0.0.0.0:8080');
$worker->count = (int) shell_exec('nproc') ?: 4;

$worker->onMessage = function($connection, $request) {
    if ($request->path() === '/hello') {
        $connection->send(new Response(
            200,
            ['Content-Type' => 'application/json'],
            '{"message":"Hello, world!"}'
        ));
    } else {
        $connection->send(new Response(404, [], 'Not Found'));
    }
};

Worker::runAll();
