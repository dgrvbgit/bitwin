<?php

require_once __DIR__ . '/../src/controllers/AuthController.php';

$metodo = $_SERVER['REQUEST_METHOD'];
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$uri = rtrim($uri, '/');

if ($uri === '' || $uri === '/') {
    header('Content-Type: text/html; charset=UTF-8');
    readfile(__DIR__ . '/landing.html');
    exit;
}

header('Content-Type: application/json; charset=UTF-8');

$datos = json_decode(file_get_contents('php://input'), true) ?? [];
$ctrl = new AuthController();

if ($uri === '/api/auth/register' && $metodo === 'POST') {
    $ctrl->register($datos);
    exit;
}

if ($uri === '/api/auth/login' && $metodo === 'POST') {
    $ctrl->login($datos);
    exit;
}
http_response_code(404);
echo json_encode(['error' => 'Ruta no encontrada']);
