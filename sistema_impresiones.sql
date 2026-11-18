DROP DATABASE IF EXISTS sistema_impresiones;
CREATE DATABASE sistema_impresiones CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sistema_impresiones;
-- 2. Tabla CLIENTE
CREATE TABLE CLIENTE (
id_cliente INT AUTO_INCREMENT PRIMARY KEY, 
nombre VARCHAR(100) NOT NULL,
apellido VARCHAR(100) NOT NULL,
telefono VARCHAR(30) NULL,
email VARCHAR(150) UNIQUE NULL,
localidad VARCHAR(100) NOT NULL,
zona VARCHAR(50) NULL,
es_profesional TINYINT(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB;

-- 3. Tablas de Catálogo (SOPORTE, MEDIDA, AJUSTE_ENCUADRE)
CREATE TABLE SOPORTE (
id_soporte INT AUTO_INCREMENT PRIMARY KEY,
nombre_soporte VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE MEDIDA (
id_medida INT AUTO_INCREMENT PRIMARY KEY,
dimensiones VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE AJUSTE_ENCUADRE (
id_ajuste INT AUTO_INCREMENT PRIMARY KEY,
nombre_ajuste VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- 4. Tabla PEDIDO (Encabezado)
CREATE TABLE PEDIDO (
numero_pedido INT AUTO_INCREMENT PRIMARY KEY, 
fecha_ingreso DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
fecha_entrega_acordada DATE NULL, 
monto_seña DECIMAL(10,2) NOT NULL DEFAULT 0.00, 
estado_pago ENUM('Señado', 'Pagado', 'Pendiente') NOT NULL DEFAULT 'Pendiente', 
id_cliente INT NOT NULL, 
CONSTRAINT CHK_seña CHECK (monto_seña >= 0),
CONSTRAINT FK_pedido_cliente FOREIGN KEY (id_cliente)
REFERENCES CLIENTE(id_cliente) 
ON DELETE RESTRICT 
ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Tabla DETALLE_IMPRESION (Renglones del Pedido)
CREATE TABLE DETALLE_IMPRESION ( numero_pedido INT NOT NULL, 
numero_item INT NOT NULL, 
cantidad INT NOT NULL, 
precio_unitario DECIMAL(10,2) NOT NULL, 
observaciones TEXT NULL, 
id_soporte INT NOT NULL, 
id_medida INT NOT NULL, 
id_ajuste INT NULL, 
PRIMARY KEY (numero_pedido, numero_item), 
CONSTRAINT CHK_cantidad CHECK (cantidad > 0), 
CONSTRAINT CHK_precio CHECK (precio_unitario >= 0),
CONSTRAINT FK_detalle_pedido FOREIGN KEY (numero_pedido)
REFERENCES PEDIDO(numero_pedido) 
ON DELETE CASCADE 
ON UPDATE CASCADE,
CONSTRAINT FK_detalle_soporte FOREIGN KEY (id_soporte)
REFERENCES SOPORTE(id_soporte) 
ON DELETE RESTRICT 
ON UPDATE CASCADE,
CONSTRAINT FK_detalle_medida FOREIGN KEY (id_medida)
REFERENCES MEDIDA(id_medida) 
ON DELETE RESTRICT 
ON UPDATE CASCADE,
CONSTRAINT FK_detalle_ajuste FOREIGN KEY (id_ajuste) 
REFERENCES AJUSTE_ENCUADRE(id_ajuste)
ON DELETE RESTRICT 
ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Carga de Catálogos de Configuración
INSERT INTO SOPORTE (nombre_soporte) VALUES
('Papel Mate'), ('Papel Brillo'), ('Lona Front'), ('Lona Blackout'), ('Canvas'), ('Ecocuero');

INSERT INTO MEDIDA (dimensiones) VALUES
('9x13'), ('10x15'), ('13x18'), ('15x21'), ('20x30'), ('30x40'), ('30x45'), ('30x60');

INSERT INTO AJUSTE_ENCUADRE (nombre_ajuste) VALUES
('Llenar formato'), ('Adaptar imagen'), ('Con margen'), ('Imán');

-- Carga de Clientes de Prueba
INSERT INTO CLIENTE (nombre, apellido, telefono, email, localidad, zona, es_profesional) VALUES
('Bautista', 'Ceva', '351-4554321', 'Bautista.ceva@email.com', 'Córdoba', 'Centro', 1),
('Manuel', 'Figueroa', '351-6778901', 'Manuel.figueroa@email.com', 'Villa Carlos Paz', 'Norte', 0),
('Santiago', 'Ceballos', '351-8990123', NULL, 'Córdoba', 'Sur', 0);
-- Carga de Pedidos de Ejemplo (Encabezados)
INSERT INTO PEDIDO (fecha_ingreso, fecha_entrega_acordada, monto_seña, estado_pago, id_cliente) VALUES
('2026-08-26 10:30:00', '2026-08-30', 5000.00, 'Señado', 1),
('2026-08-26 11:15:00', '2026-08-28', 12000.00, 'Pagado', 2);
-- Carga de Detalles de Impresión (Renglones) 
-- Pedido #1 (Bautista): 10 fotos 10x15 en Papel Brillo + 1 Canvas 30x40
INSERT INTO DETALLE_IMPRESION (numero_pedido, numero_item, cantidad, precio_unitario, observaciones, id_soporte, id_medida, id_ajuste) VALUES
(1, 1, 10, 500.00, 'Verificar nitidez de rostros', 2, 2, 1),
(1, 2, 1, 7000.00, 'Con bastidor de madera', 5, 6, 2);
-- Pedido #2 (Manuel): 2 Lonas 30x60
INSERT INTO DETALLE_IMPRESION (numero_pedido, numero_item, cantidad, precio_unitario, observaciones, id_soporte, id_medida, id_ajuste) VALUES
(2, 1, 2, 6000.00, 'Ojalillos en las esquinas', 3, 8, 3);

USE sistema_impresiones; SELECT * FROM CLIENTE;