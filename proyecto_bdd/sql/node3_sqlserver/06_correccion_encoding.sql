-- =====================================================================
-- 06_correccion_encoding.sql — Nodo 3 (SQL Server)
-- =====================================================================
-- Ejecutar conectado a la base 'biblioteca':
--   sqlcmd -S 192.168.10.3,1433 -U sa -P "BiblioSQL2026!" -d biblioteca -i 06_correccion_encoding.sql
--
-- Motivo: las columnas de texto se crearon como VARCHAR (1 byte por
-- carácter, según el collation del servidor). Los títulos/descripciones
-- en español (tildes, ñ) no sobreviven ese viaje intactos cuando llegan
-- desde PostgreSQL/MySQL (que sí usan UTF-8 de forma nativa). NVARCHAR
-- almacena Unicode real y elimina el problema de raíz.
--
-- IMPORTANTE: correr esto ANTES de sincronizacion_inicial.py, para que
-- los datos entren ya bien desde la primera copia. Si 'tema' ya tiene
-- filas con texto corrupto, hay que limpiarlas después de este script
-- (ver el bloque comentado al final).
-- =====================================================================

USE biblioteca;
GO

ALTER TABLE repisas ALTER COLUMN nombre_nivel NVARCHAR(30) NOT NULL;
GO

ALTER TABLE tema ALTER COLUMN titulo NVARCHAR(200) NOT NULL;
ALTER TABLE tema ALTER COLUMN autor NVARCHAR(150) NULL;
ALTER TABLE tema ALTER COLUMN isbn NVARCHAR(20) NULL;
GO

-- ---------------------------------------------------------------------
-- Si 'tema' ya tiene filas con texto corrupto (llegaron ANTES de correr
-- este script), la forma más simple es borrarlas y dejar que
-- sincronizacion_inicial.py las vuelva a copiar bien. Descomenta y
-- ejecuta esto SOLO si ya viste caracteres especiales en el grid:
--
-- DELETE FROM tema;
-- DBCC CHECKIDENT ('tema', RESEED, 999);  -- para que el próximo insert local siga en 1000
-- GO
