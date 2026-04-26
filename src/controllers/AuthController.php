<?php
require_once __DIR__ . '/../models/Usuario.php';

class AuthController {

    public function register($data) {
        if (empty($data['username']) || empty($data['email']) || empty($data['password'])) {
            http_response_code(400);
            echo json_encode(['error' => 'Todos los campos son obligatorios']);
            return;
        }

        if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            http_response_code(400);
            echo json_encode(['error' => 'Email no valido']);
            return;
        }

        if (strlen($data['password']) < 6) {
            http_response_code(400);
            echo json_encode(['error' => 'La contrasena debe tener al menos 6 caracteres']);
            return;
        }

        $usuario = new Usuario();

        if ($usuario->findByEmail($data['email'])) {
            http_response_code(409);
            echo json_encode(['error' => 'El email ya esta registrado']);
            return;
        }

        if ($usuario->findByUsername($data['username'])) {
            http_response_code(409);
            echo json_encode(['error' => 'El nombre de usuario ya esta en uso']);
            return;
        }

        $id = $usuario->create($data['username'], $data['email'], $data['password']);

        http_response_code(201);
        echo json_encode([
            'mensaje' => 'Usuario registrado correctamente',
            'id' => $id
        ]);
    }

    public function login($data) {
        if (empty($data['email']) || empty($data['password'])) {
            http_response_code(400);
            echo json_encode(['error' => 'Email y contrasena son obligatorios']);
            return;
        }

        $usuario = new Usuario();
        $user = $usuario->findByEmail($data['email']);

        if (!$user || !password_verify($data['password'], $user['password_hash'])) {
            http_response_code(401);
            echo json_encode(['error' => 'Credenciales incorrectas']);
            return;
        }

        // TODO: implementar sesiones en siguiente entregable
        http_response_code(200);
        echo json_encode([
            'mensaje' => 'Login correcto',
            'usuario' => [
                'id'       => $user['id'],
                'username' => $user['username'],
                'rol'      => $user['rol']
            ]
        ]);
    }
}
