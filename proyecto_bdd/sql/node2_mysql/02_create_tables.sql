-- =====================================================================
-- 02_create_tables.sql — Nodo 2 (MySQL)
-- =====================================================================
-- SE EJECUTA con la base "biblioteca" ya seleccionada (ver 01_create_database.sql):
--   mysql -h 192.168.10.2 -P 3306 -u root -p biblioteca < 02_create_tables.sql
--
-- Tablas que aloja este nodo: tema (catálogo completo) + usuarios y
-- prestamos (aquí se crean completas; el fragmento por nodo se restringe
-- en la fase de fragmentación con un CHECK).
--
-- MySQL resuelve fecha_hora_actualizacion con "ON UPDATE CURRENT_TIMESTAMP"
-- de forma nativa, sin necesidad de trigger explícito.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Tabla: tema (catálogo completo, 100 registros)
-- id_categoria_ref, id_estante_ref, id_repisa_ref -> FK lógicas hacia
-- categoria/estantes/repisas, que viven en Nodo 1 (PostgreSQL).
-- No se declaran como FOREIGN KEY físicas por ser referencias cruzadas
-- entre nodos.
-- ---------------------------------------------------------------------
CREATE TABLE tema (
    id_tema             INT AUTO_INCREMENT PRIMARY KEY,
    titulo               VARCHAR(200) NOT NULL,
    autor                VARCHAR(150),
    isbn                 VARCHAR(20),
    anio_publicacion     INT,
    id_categoria_ref     INT NOT NULL,   -- FK lógica -> categoria.id_categoria (Nodo 1)
    id_estante_ref       INT NOT NULL,   -- FK lógica -> estantes.id_estante (Nodo 1)
    id_repisa_ref        INT NOT NULL,   -- FK lógica -> repisas.id_repisa (Nodo 1)
    disponible           TINYINT(1) NOT NULL DEFAULT 1,  -- 1 = disponible, 0 = prestado
    fecha_hora_creacion       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_hora_actualizacion  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
                                ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- ---------------------------------------------------------------------
-- Tabla: usuarios (fragmento de este nodo: tipo_usuario = 'Docente')
-- ---------------------------------------------------------------------
CREATE TABLE usuarios (
    id_usuario            INT AUTO_INCREMENT PRIMARY KEY,
    cedula                VARCHAR(10) NOT NULL,
    nombres               VARCHAR(100) NOT NULL,
    apellidos             VARCHAR(100) NOT NULL,
    correo_institucional  VARCHAR(150),
    tipo_usuario          VARCHAR(20) NOT NULL,  -- Estudiante, Docente
    fecha_hora_creacion       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_hora_actualizacion  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
                                ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- ---------------------------------------------------------------------
-- Tabla: prestamos (fragmento de este nodo: estado_prestamo = 'Devuelto')
-- id_tema_ref, id_usuario_ref -> FK lógicas, sin constraint físico por
-- ser referencias potencialmente cruzadas entre nodos.
-- ---------------------------------------------------------------------
CREATE TABLE prestamos (
    id_prestamo                 INT AUTO_INCREMENT PRIMARY KEY,
    id_tema_ref                 INT NOT NULL,   -- FK lógica -> tema.id_tema (este mismo nodo)
    id_usuario_ref               INT NOT NULL,   -- FK lógica -> usuarios.id_usuario
    fecha_prestamo                DATE NOT NULL,
    fecha_devolucion_esperada    DATE NOT NULL,
    fecha_devolucion_real         DATE,
    estado_prestamo               VARCHAR(20) NOT NULL,  -- Activo, Devuelto, Atrasado
    fecha_hora_creacion       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_hora_actualizacion  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
                                ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
