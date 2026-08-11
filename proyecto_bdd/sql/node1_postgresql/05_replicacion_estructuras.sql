-- =====================================================================
-- 05_replicacion_estructuras.sql — Nodo 1 (PostgreSQL)
-- =====================================================================
-- Ejecutar conectado a la base 'biblioteca':
--   psql -h 192.168.10.1 -p 5432 -U admin_biblioteca -d biblioteca -f 05_replicacion_estructuras.sql
--
-- Este nodo es ORIGEN de:
--   - categoria -> Nodo 2 (unidireccional, Postgres nunca recibe de vuelta)
--   - estantes  -> Nodo 2 (bidireccional)
--   - repisas   -> Nodo 3 (bidireccional)
-- Por eso necesita outbox + trigger en las 3 tablas.
-- =====================================================================
-- =====================================================================
-- Guía de configuración para la infraestructura de replicación en Nodo 1:
-- 1. Creación del usuario técnico (usr_replicador) y sus privilegios.
-- 2. Creación de la tabla unificada de cola de replicación.
-- 3. Creación de la función genérica con row_to_json.
-- 4. Creación de los triggers para las tablas involucradas.
-- =====================================================================
-- ---------------------------------------------------------------------
-- 1. Crear usuario técnico y otorgar permisos
-- ---------------------------------------------------------------------
CREATE ROLE usr_replicador LOGIN PASSWORD 'UsrReplicador2026';
GRANT CONNECT ON DATABASE biblioteca TO usr_replicador;
GRANT SELECT, INSERT, UPDATE, DELETE ON categoria, estantes, repisas TO usr_replicador;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO usr_replicador;

-- ---------------------------------------------------------------------
-- 2. Crear tabla única de cola de replicación
-- ---------------------------------------------------------------------
CREATE TABLE cola_replicacion (
    id SERIAL PRIMARY KEY,
    tabla_afectada VARCHAR(50),
    accion VARCHAR(10),
    datos JSON,
    nodo_origen VARCHAR(20),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
GRANT SELECT, INSERT, DELETE ON cola_replicacion TO usr_replicador;

-- ---------------------------------------------------------------------
-- 3. Crear función genérica para los triggers de replicación
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION notificar_cambio_replicacion()
RETURNS TRIGGER AS $$
BEGIN
    IF current_user = 'usr_replicador' THEN
        IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
    END IF;

    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        INSERT INTO cola_replicacion (tabla_afectada, accion, datos, nodo_origen)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(NEW), 'PostgreSQL');
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO cola_replicacion (tabla_afectada, accion, datos, nodo_origen)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), 'PostgreSQL');
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------------------
-- 4. Asignar triggers a las tablas correspondientes
-- ---------------------------------------------------------------------
CREATE TRIGGER trg_repl_categoria 
    AFTER INSERT OR UPDATE OR DELETE ON categoria 
    FOR EACH ROW EXECUTE FUNCTION notificar_cambio_replicacion();

CREATE TRIGGER trg_repl_estantes 
    AFTER INSERT OR UPDATE OR DELETE ON estantes 
    FOR EACH ROW EXECUTE FUNCTION notificar_cambio_replicacion();

CREATE TRIGGER trg_repl_repisas 
    AFTER INSERT OR UPDATE OR DELETE ON repisas 
    FOR EACH ROW EXECUTE FUNCTION notificar_cambio_replicacion();