-- =====================================================================
-- 05_replicacion_estructuras.sql — Nodo 3 (SQL Server)
-- =====================================================================
-- Ejecutar conectado a la base 'biblioteca':
--   sqlcmd -S 192.168.10.3,1433 -U sa -P "BiblioSQL2026!" -d biblioteca -i 05_replicacion_estructuras.sql
--
-- Este nodo participa en 2 pares bidireccionales:
--   - repisas -> con Nodo 1 (PostgreSQL)
--   - tema    -> con Nodo 2 (MySQL)
-- =====================================================================
-- Guía de configuración para la infraestructura de replicación en Nodo 3:
-- 1. Creación del login/usuario técnico y permisos.
-- 2. Creación de las tablas base (repisas y tema con IDENTITY optimizado).
-- 3. Creación de la tabla unificada de cola de replicación.
-- 4. Creación de los triggers unificados con FOR JSON PATH.
-- =====================================================================

USE biblioteca;
GO

-- ---------------------------------------------------------------------
-- 1. Crear login y usuario técnico, y otorgar privilegios
-- ---------------------------------------------------------------------
CREATE LOGIN usr_replicador WITH PASSWORD = 'UsrReplicador2026!', CHECK_POLICY = OFF;
CREATE USER usr_replicador FOR LOGIN usr_replicador;
GRANT SELECT, INSERT, UPDATE, DELETE ON repisas TO usr_replicador;
GRANT SELECT, INSERT, UPDATE, DELETE ON tema TO usr_replicador;
GO

-- ---------------------------------------------------------------------
-- 2. Tablas base (repisas y tema)
-- ---------------------------------------------------------------------
CREATE TABLE repisas (
    id_repisa INT IDENTITY(1000,1) PRIMARY KEY,
    nombre_nivel VARCHAR(30) NOT NULL,
    altura_cm NUMERIC(6,2),
    fecha_hora_creacion DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    fecha_hora_actualizacion DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE tema (
    id_tema INT IDENTITY(1000,1) PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(150),
    isbn VARCHAR(20),
    anio_publicacion INT,
    id_categoria_ref INT NOT NULL,
    id_estante_ref INT NOT NULL,
    id_repisa_ref INT NOT NULL,
    disponible BIT NOT NULL DEFAULT 1,
    fecha_hora_creacion DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    fecha_hora_actualizacion DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

-- ---------------------------------------------------------------------
-- 3. Crear tabla única de cola de replicación
-- ---------------------------------------------------------------------
CREATE TABLE cola_replicacion (
    id INT IDENTITY(1,1) PRIMARY KEY,
    tabla_afectada VARCHAR(50),
    accion VARCHAR(10),
    datos NVARCHAR(MAX),
    nodo_origen VARCHAR(20),
    fecha_registro DATETIME2 DEFAULT SYSDATETIME()
);
GRANT SELECT, INSERT, DELETE ON cola_replicacion TO usr_replicador;
GO

-- ---------------------------------------------------------------------
-- 4. Creación de Triggers para Repisas y Tema
-- ---------------------------------------------------------------------

-- Trigger para repisas
CREATE TRIGGER trg_repl_repisas ON repisas AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF SUSER_SNAME() = 'usr_replicador' RETURN;

    INSERT INTO cola_replicacion (tabla_afectada, accion, datos, nodo_origen)
    SELECT 
        'repisas',
        CASE WHEN EXISTS (SELECT 1 FROM deleted) THEN 'UPDATE' ELSE 'INSERT' END,
        j.datos_json,
        'SQLServer'
    FROM inserted i
    CROSS APPLY (
        SELECT 
            i.id_repisa, 
            i.nombre_nivel, 
            i.altura_cm,
            CONVERT(varchar(19), i.fecha_hora_creacion, 120) AS fecha_hora_creacion,
            CONVERT(varchar(19), i.fecha_hora_actualizacion, 120) AS fecha_hora_actualizacion
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    ) j(datos_json);
END;
GO

-- Trigger para tema
CREATE TRIGGER trg_repl_tema ON tema AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF SUSER_SNAME() = 'usr_replicador' RETURN;

    INSERT INTO cola_replicacion (tabla_afectada, accion, datos, nodo_origen)
    SELECT 
        'tema',
        CASE WHEN EXISTS (SELECT 1 FROM deleted) THEN 'UPDATE' ELSE 'INSERT' END,
        j.datos_json,
        'SQLServer'
    FROM inserted i
    CROSS APPLY (
        SELECT 
            i.id_tema, 
            i.titulo, 
            i.autor, 
            i.isbn, 
            i.anio_publicacion, 
            i.id_categoria_ref, 
            i.id_estante_ref, 
            i.id_repisa_ref, 
            i.disponible,
            CONVERT(varchar(19), i.fecha_hora_creacion, 120) AS fecha_hora_creacion,
            CONVERT(varchar(19), i.fecha_hora_actualizacion, 120) AS fecha_hora_actualizacion
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    ) j(datos_json);
END;
GO