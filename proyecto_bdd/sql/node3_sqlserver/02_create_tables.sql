-- =====================================================================
-- 02_create_tables.sql — Nodo 3 (SQL Server)
-- =====================================================================
-- SE EJECUTA con la base "biblioteca" ya seleccionada (creada por 01_create_database.sql):
--   sqlcmd -S 192.168.10.3,1433 -U sa -P "BiblioSQL2026!" -d biblioteca -i 02_create_tables.sql
--
-- Este nodo aloja únicamente el fragmento de prestamos donde
-- estado_prestamo = 'Atrasado' (se restringe con CHECK en la fase de
-- fragmentación). id_tema_ref e id_usuario_ref son FK lógicas hacia
-- tablas que viven en Nodo 1 (PostgreSQL) o Nodo 2 (MySQL); no se
-- declaran como FOREIGN KEY físicas por ser referencias cruzadas.
--
-- IMPORTANTE — Zona horaria:
-- SYSDATETIME() usa la hora del sistema operativo del contenedor. Para
-- forzar hora de Ecuador sin depender del huso del host, agregar
-- "TZ: America/Guayaquil" a las variables de entorno del servicio
-- sqlserver_node3 en su docker-compose.yml.
-- =====================================================================

USE biblioteca;
GO

CREATE TABLE prestamos (
    id_prestamo                  INT IDENTITY(1,1) PRIMARY KEY,
    id_tema_ref                  INT NOT NULL,   -- FK lógica -> tema.id_tema (Nodo 2)
    id_usuario_ref                INT NOT NULL,   -- FK lógica -> usuarios.id_usuario
    fecha_prestamo                 DATE NOT NULL,
    fecha_devolucion_esperada     DATE NOT NULL,
    fecha_devolucion_real          DATE NULL,
    estado_prestamo                VARCHAR(20) NOT NULL,  -- Activo, Devuelto, Atrasado
    fecha_hora_creacion       DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    fecha_hora_actualizacion  DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

-- Trigger para actualizar fecha_hora_actualizacion en cada UPDATE
CREATE TRIGGER trg_prestamos_upd
ON prestamos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE p
    SET p.fecha_hora_actualizacion = SYSDATETIME()
    FROM prestamos p
    INNER JOIN inserted i ON p.id_prestamo = i.id_prestamo;
END;
GO
