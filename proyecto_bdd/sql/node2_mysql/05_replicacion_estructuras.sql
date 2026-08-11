-- =====================================================================
-- 05_replicacion_estructuras.sql — Nodo 2 (MySQL)
-- =====================================================================
-- Ejecutar conectado a la base 'biblioteca':
--   mysql -h 192.168.10.2 -P 3306 -u root -p biblioteca < 05_replicacion_estructuras.sql
--
-- Este nodo:
--   - RECIBE categoria desde Nodo 1 (unidireccional) -> tabla espejo,
--     SIN outbox/trigger (nunca escribe de vuelta a Nodo 1).
--   - Participa en bidireccional con Nodo 1 en estantes -> tabla espejo
--     CON outbox/trigger.
--   - Es ORIGEN de tema hacia Nodo 3 (bidireccional, tema ya es la tabla
--     maestra completa que se cargó en la fase 1) -> outbox/trigger.
-- =====================================================================

-- Guía de configuración para la infraestructura de replicación en Nodo 2:
-- 1. Creación del usuario técnico y privilegios.
-- 2. Creación de las tablas base (categoria y estantes con auto_increment ajustado).
-- 3. Creación de la tabla unificada de cola de replicación.
-- 4. Creación de los triggers para capturar cambios en estantes y tema.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Crear usuario técnico y otorgar privilegios
-- ---------------------------------------------------------------------
CREATE USER 'usr_replicador'@'%' IDENTIFIED BY 'UsrReplicador2026';
GRANT ALL PRIVILEGES ON biblioteca.* TO 'usr_replicador'@'%';
FLUSH PRIVILEGES;

-- ---------------------------------------------------------------------
-- 2. Tablas base (categoria y estantes)
-- ---------------------------------------------------------------------
CREATE TABLE categoria (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL,
    descripcion VARCHAR(250),
    fecha_hora_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_hora_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE estantes (
    id_estante INT AUTO_INCREMENT PRIMARY KEY,
    codigo_estante VARCHAR(10) NOT NULL,
    pasillo VARCHAR(50),
    capacidad_maxima INT NOT NULL,
    fecha_hora_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_hora_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci
AUTO_INCREMENT = 1000;

-- ---------------------------------------------------------------------
-- 3. Crear tabla única de cola de replicación
-- ---------------------------------------------------------------------
CREATE TABLE cola_replicacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tabla_afectada VARCHAR(50),
    accion VARCHAR(10),
    datos JSON,
    nodo_origen VARCHAR(20),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 4. Creación de Triggers para Estantes y Tema
-- ---------------------------------------------------------------------
DELIMITER $$

-- TRIGGERS PARA ESTANTES (Insert y Update)
CREATE TRIGGER trg_estantes_repl_ins AFTER INSERT ON estantes FOR EACH ROW
BEGIN
    IF SUBSTRING_INDEX(USER(), '@', 1) != 'usr_replicador' THEN
        INSERT INTO cola_replicacion (tabla_afectada, accion, datos, nodo_origen)
        VALUES ('estantes', 'INSERT', JSON_OBJECT('id_estante', NEW.id_estante, 'codigo_estante', NEW.codigo_estante, 'pasillo', NEW.pasillo, 'capacidad_maxima', NEW.capacidad_maxima, 'fecha_hora_creacion', DATE_FORMAT(NEW.fecha_hora_creacion, '%Y-%m-%d %H:%i:%s'), 'fecha_hora_actualizacion', DATE_FORMAT(NEW.fecha_hora_actualizacion, '%Y-%m-%d %H:%i:%s')), 'MySQL');
    END IF;
END$$

CREATE TRIGGER trg_estantes_repl_upd AFTER UPDATE ON estantes FOR EACH ROW
BEGIN
    IF SUBSTRING_INDEX(USER(), '@', 1) != 'usr_replicador' THEN
        INSERT INTO cola_replicacion (tabla_afectada, accion, datos, nodo_origen)
        VALUES ('estantes', 'UPDATE', JSON_OBJECT('id_estante', NEW.id_estante, 'codigo_estante', NEW.codigo_estante, 'pasillo', NEW.pasillo, 'capacidad_maxima', NEW.capacidad_maxima, 'fecha_hora_creacion', DATE_FORMAT(NEW.fecha_hora_creacion, '%Y-%m-%d %H:%i:%s'), 'fecha_hora_actualizacion', DATE_FORMAT(NEW.fecha_hora_actualizacion, '%Y-%m-%d %H:%i:%s')), 'MySQL');
    END IF;
END$$

-- TRIGGERS PARA TEMA (Insert y Update)
CREATE TRIGGER trg_tema_repl_ins AFTER INSERT ON tema FOR EACH ROW
BEGIN
    IF SUBSTRING_INDEX(USER(), '@', 1) != 'usr_replicador' THEN
        INSERT INTO cola_replicacion (tabla_afectada, accion, datos, nodo_origen)
        VALUES ('tema', 'INSERT', JSON_OBJECT('id_tema', NEW.id_tema, 'titulo', NEW.titulo, 'autor', NEW.autor, 'isbn', NEW.isbn, 'anio_publicacion', NEW.anio_publicacion, 'id_categoria_ref', NEW.id_categoria_ref, 'id_estante_ref', NEW.id_estante_ref, 'id_repisa_ref', NEW.id_repisa_ref, 'disponible', NEW.disponible, 'fecha_hora_creacion', DATE_FORMAT(NEW.fecha_hora_creacion, '%Y-%m-%d %H:%i:%s'), 'fecha_hora_actualizacion', DATE_FORMAT(NEW.fecha_hora_actualizacion, '%Y-%m-%d %H:%i:%s')), 'MySQL');
    END IF;
END$$

CREATE TRIGGER trg_tema_repl_upd AFTER UPDATE ON tema FOR EACH ROW
BEGIN
    IF SUBSTRING_INDEX(USER(), '@', 1) != 'usr_replicador' THEN
        INSERT INTO cola_replicacion (tabla_afectada, accion, datos, nodo_origen)
        VALUES ('tema', 'UPDATE', JSON_OBJECT('id_tema', NEW.id_tema, 'titulo', NEW.titulo, 'autor', NEW.autor, 'isbn', NEW.isbn, 'anio_publicacion', NEW.anio_publicacion, 'id_categoria_ref', NEW.id_categoria_ref, 'id_estante_ref', NEW.id_estante_ref, 'id_repisa_ref', NEW.id_repisa_ref, 'disponible', NEW.disponible, 'fecha_hora_creacion', DATE_FORMAT(NEW.fecha_hora_creacion, '%Y-%m-%d %H:%i:%s'), 'fecha_hora_actualizacion', DATE_FORMAT(NEW.fecha_hora_actualizacion, '%Y-%m-%d %H:%i:%s')), 'MySQL');
    END IF;
END$$

DELIMITER ;