-- =====================================================================
-- 01_create_database.sql — Nodo 1 (PostgreSQL)
-- =====================================================================
-- SE EJECUTA CONECTADO A LA BASE DE MANTENIMIENTO "postgres"
-- (la que existe por defecto), NO a "biblioteca", porque esta última
-- todavía no existe.
--
-- Desde la laptop del Nodo 1 (o remoto si el puerto 5432 ya es alcanzable):
--   psql -h 192.168.10.1 -p 5432 -U admin_biblioteca -d postgres -f 01_create_database.sql
--
-- Si el motor corre en Docker y prefieres ejecutar el script dentro del
-- contenedor:
--   docker exec -it bdd_postgres_node1 psql -U admin_biblioteca -d postgres
--   (y luego pegar el contenido de este archivo)
-- =====================================================================

CREATE DATABASE biblioteca
    WITH OWNER = admin_biblioteca
    ENCODING = 'UTF8'
    LC_COLLATE = 'es_EC.UTF-8'
    LC_CTYPE = 'es_EC.UTF-8'
    TEMPLATE = template0;

-- Nota: si el locale es_EC.UTF-8 no está disponible en la imagen de Docker,
-- usar simplemente:
-- CREATE DATABASE biblioteca WITH OWNER = admin_biblioteca ENCODING = 'UTF8';

-- A partir de aquí, TODO lo demás (02_create_tables.sql, cargas, etc.)
-- se ejecuta conectado YA a la base "biblioteca", no a "postgres":
--   psql -h 192.168.10.1 -p 5432 -U admin_biblioteca -d biblioteca -f 02_create_tables.sql
