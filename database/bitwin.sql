-- BitWin Database
-- Contrasenas seed: admin -> admin123 | jugador1 -> test123

CREATE DATABASE IF NOT EXISTS bitwin;
USE bitwin;

CREATE TABLE usuario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(30) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  saldo DECIMAL(10,2) DEFAULT 100.00,
  rol ENUM('ADMIN','JUGADOR') DEFAULT 'JUGADOR',
  personaje ENUM('MASCULINO','FEMENINO') DEFAULT 'MASCULINO',
  ultimo_bono DATETIME,
  ultimo_rescate DATETIME,
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE maquina (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  tipo ENUM('SLOT','BLACKJACK','DADOS') NOT NULL,
  apuesta_minima DECIMAL(10,2) DEFAULT 10.00,
  bloqueada TINYINT(1) DEFAULT 1
);

CREATE TABLE maquina_desbloqueada (
  usuario_id INT NOT NULL,
  maquina_id INT NOT NULL,
  desbloqueada_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (usuario_id, maquina_id),
  FOREIGN KEY (usuario_id) REFERENCES usuario(id),
  FOREIGN KEY (maquina_id) REFERENCES maquina(id)
);

CREATE TABLE apuesta (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  maquina_id INT NOT NULL,
  cantidad DECIMAL(10,2) NOT NULL,
  resultado DECIMAL(10,2) NOT NULL,
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuario(id),
  FOREIGN KEY (maquina_id) REFERENCES maquina(id)
);

CREATE TABLE item (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  tipo ENUM('MARKET_MAQUINAS','MARKET_ITEMS','MARKET_BAR') NOT NULL,
  calidad ENUM('COMUN','ESPECIAL','EPICA','LEGENDARIA','CELESTIAL','INALCANZABLE') NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  maquina_id INT,
  FOREIGN KEY (maquina_id) REFERENCES maquina(id)
);

CREATE TABLE inventario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  item_id INT NOT NULL,
  cantidad INT DEFAULT 1,
  adquirido_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuario(id),
  FOREIGN KEY (item_id) REFERENCES item(id)
);

CREATE TABLE logro (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  conseguido_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

CREATE TABLE mision (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  descripcion TEXT,
  completada TINYINT(1) DEFAULT 0,
  creada_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

CREATE TABLE log (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT,
  accion VARCHAR(100) NOT NULL,
  detalle TEXT,
  ip VARCHAR(45),
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

-- SEED: Maquinas
INSERT INTO maquina (nombre, tipo, apuesta_minima, bloqueada) VALUES
('Lucky Star', 'SLOT', 10.00, 0),
('Vegas 21', 'BLACKJACK', 20.00, 0),
('Dado de Fuego', 'DADOS', 5.00, 1);

-- SEED: Items
INSERT INTO item (nombre, tipo, calidad, precio, maquina_id) VALUES
('Ficha Dorada', 'MARKET_ITEMS', 'ESPECIAL', 50.00, NULL),
('Trago de la Suerte', 'MARKET_BAR', 'COMUN', 15.00, NULL),
('Acceso Lucky Star', 'MARKET_MAQUINAS', 'EPICA', 200.00, 1);

-- SEED: Usuarios
INSERT INTO usuario (username, email, password_hash, saldo, rol) VALUES
('admin', 'admin@bitwin.es', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 9999.00, 'ADMIN');

INSERT INTO usuario (username, email, password_hash, saldo, rol) VALUES
('jugador1', 'jugador1@bitwin.es', '$2y$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3y', 100.00, 'JUGADOR');
