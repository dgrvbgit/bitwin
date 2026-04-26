<?php
class Database {
    private static $connection = null;
    public static function getConnection() {
        if (self::$connection === null) {
            $host = $_ENV['DB_HOST'] ?? 'db';
            $name = $_ENV['DB_NAME'] ?? 'bitwin';
            $user = $_ENV['DB_USER'] ?? 'root';
            $pass = $_ENV['DB_PASS'] ?? '';

            try {
                self::$connection = new PDO(
                    "mysql:host=$host;dbname=$name;charset=utf8",
                    $user,
                    $pass
                );
                self::$connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            } catch (PDOException $e) {
                http_response_code(500);
                echo json_encode(['error' => 'Error de conexion a la base de datos']);
                exit;
            }
        }
        return self::$connection;
    }
}

