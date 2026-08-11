-- =====================================================================
-- 02_create_tables.sql — Nodo 1 (PostgreSQL)
-- =====================================================================
-- SE EJECUTA CONECTADO A LA BASE "biblioteca" (ya creada por 01_create_database.sql)
--   psql -h 192.168.10.1 -p 5432 -U admin_biblioteca -d biblioteca -f 02_create_tables.sql
--
-- Tablas que aloja este nodo: estantes, repisas, categoria (catálogos
-- completos) + usuarios y prestamos (aquí se crean completas; el fragmento
-- por nodo se restringe en la fase de fragmentación con un CHECK).
-- =====================================================================

-- ---------------------------------------------------------------------
-- Función reutilizable para actualizar fecha_hora_actualizacion
-- (hora local de Ecuador, America/Guayaquil, UTC-5 sin horario de verano)
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION set_fecha_hora_actualizacion()
RETURNS TRIGGER AS $$
BEGIN
    NEW.fecha_hora_actualizacion := (now() AT TIME ZONE 'America/Guayaquil');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------------------
-- Tabla: estantes
-- ---------------------------------------------------------------------
CREATE TABLE estantes (
    id_estante          SERIAL PRIMARY KEY,
    codigo_estante      VARCHAR(10) NOT NULL,
    pasillo             VARCHAR(50),
    capacidad_maxima    INTEGER NOT NULL,
    fecha_hora_creacion       TIMESTAMP NOT NULL DEFAULT (now() AT TIME ZONE 'America/Guayaquil'),
    fecha_hora_actualizacion  TIMESTAMP NOT NULL DEFAULT (now() AT TIME ZONE 'America/Guayaquil')
);

CREATE TRIGGER trg_estantes_upd
    BEFORE UPDATE ON estantes
    FOR EACH ROW EXECUTE FUNCTION set_fecha_hora_actualizacion();

-- ---------------------------------------------------------------------
-- Tabla: repisas
-- ---------------------------------------------------------------------
CREATE TABLE repisas (
    id_repisa           SERIAL PRIMARY KEY,
    nombre_nivel        VARCHAR(30) NOT NULL,   -- Baja, Media, Alta, Superior
    altura_cm           NUMERIC(6,2),
    fecha_hora_creacion       TIMESTAMP NOT NULL DEFAULT (now() AT TIME ZONE 'America/Guayaquil'),
    fecha_hora_actualizacion  TIMESTAMP NOT NULL DEFAULT (now() AT TIME ZONE 'America/Guayaquil')
);

CREATE TRIGGER trg_repisas_upd
    BEFORE UPDATE ON repisas
    FOR EACH ROW EXECUTE FUNCTION set_fecha_hora_actualizacion();

-- ---------------------------------------------------------------------
-- Tabla: categoria
-- ---------------------------------------------------------------------
CREATE TABLE categoria (
    id_categoria         SERIAL PRIMARY KEY,
    nombre_categoria     VARCHAR(100) NOT NULL,
    descripcion          VARCHAR(250),
    fecha_hora_creacion       TIMESTAMP NOT NULL DEFAULT (now() AT TIME ZONE 'America/Guayaquil'),
    fecha_hora_actualizacion  TIMESTAMP NOT NULL DEFAULT (now() AT TIME ZONE 'America/Guayaquil')
);

CREATE TRIGGER trg_categoria_upd
    BEFORE UPDATE ON categoria
    FOR EACH ROW EXECUTE FUNCTION set_fecha_hora_actualizacion();

-- ---------------------------------------------------------------------
-- Tabla: usuarios (fragmento de este nodo: tipo_usuario = 'Estudiante')
-- Sin FK física: no aplica (usuarios no referencia a otras tablas).
-- ---------------------------------------------------------------------
CREATE TABLE usuarios (
    id_usuario            SERIAL PRIMARY KEY,
    cedula                VARCHAR(10) NOT NULL,
    nombres               VARCHAR(100) NOT NULL,
    apellidos             VARCHAR(100) NOT NULL,
    correo_institucional  VARCHAR(150),
    tipo_usuario          VARCHAR(20) NOT NULL,  -- Estudiante, Docente
    fecha_hora_creacion       TIMESTAMP NOT NULL DEFAULT (now() AT TIME ZONE 'America/Guayaquil'),
    fecha_hora_actualizacion  TIMESTAMP NOT NULL DEFAULT (now() AT TIME ZONE 'America/Guayaquil')
);

CREATE TRIGGER trg_usuarios_upd
    BEFORE UPDATE ON usuarios
    FOR EACH ROW EXECUTE FUNCTION set_fecha_hora_actualizacion();

-- ---------------------------------------------------------------------
-- Tabla: prestamos (fragmento de este nodo: estado_prestamo = 'Activo')
-- id_tema_ref  -> lógicamente referencia a tema (vive en Nodo 2 / MySQL)
-- id_usuario_ref -> lógicamente referencia a usuarios (puede vivir en
--                    Nodo 1 o Nodo 2 según tipo_usuario)
-- Ninguna de las dos se declara como FK física por ser referencia
-- potencialmente cruzada entre nodos.
-- ---------------------------------------------------------------------
CREATE TABLE prestamos (
    id_prestamo                SERIAL PRIMARY KEY,
    id_tema_ref                INTEGER NOT NULL,   -- FK lógica -> tema.id_tema (Nodo 2)
    id_usuario_ref              INTEGER NOT NULL,   -- FK lógica -> usuarios.id_usuario
    fecha_prestamo               DATE NOT NULL,
    fecha_devolucion_esperada   DATE NOT NULL,
    fecha_devolucion_real        DATE,
    estado_prestamo              VARCHAR(20) NOT NULL,  -- Activo, Devuelto, Atrasado
    fecha_hora_creacion       TIMESTAMP NOT NULL DEFAULT (now() AT TIME ZONE 'America/Guayaquil'),
    fecha_hora_actualizacion  TIMESTAMP NOT NULL DEFAULT (now() AT TIME ZONE 'America/Guayaquil')
);

CREATE TRIGGER trg_prestamos_upd
    BEFORE UPDATE ON prestamos
    FOR EACH ROW EXECUTE FUNCTION set_fecha_hora_actualizacion();
