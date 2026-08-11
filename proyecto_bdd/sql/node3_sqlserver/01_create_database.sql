-- =====================================================================
-- 01_create_database.sql — Nodo 3 (SQL Server)
-- =====================================================================
-- SE EJECUTA CONECTADO A LA BASE "master" (la de sistema, existe siempre),
-- NO a "biblioteca", porque esta última todavía no existe.
--
-- Desde la laptop del Nodo 3 (o remoto si el puerto 1433 ya es alcanzable):
--   sqlcmd -S 192.168.10.3,1433 -U sa -P "BiblioSQL2026!" -d master -i 01_create_database.sql
--
-- Si el motor corre en Docker:
--   docker exec -it bdd_sqlserver_node3 /opt/mssql-tools18/bin/sqlcmd \
--       -S localhost -U sa -P "BiblioSQL2026!" -C -d master
--   (y luego pegar el contenido de este archivo, terminando cada bloque con GO)
-- =====================================================================

CREATE DATABASE biblioteca;
GO

-- A partir de aquí, 02_create_tables.sql se ejecuta conectado YA a la
-- base "biblioteca", no a "master":
--   sqlcmd -S 192.168.10.3,1433 -U sa -P "BiblioSQL2026!" -d biblioteca -i 02_create_tables.sql
