-- =====================================================================
-- 01_create_database.sql — Nodo 2 (MySQL)
-- =====================================================================
-- SE EJECUTA sin estar "dentro" de ninguna base todavía (o conectado a
-- la base por defecto). A diferencia de PostgreSQL, MySQL sí permite
-- crear y seleccionar la base en el mismo script con USE.
--
-- Desde la laptop del Nodo 2 (o remoto si el puerto 3306 ya es alcanzable):
--   mysql -h 192.168.10.2 -P 3306 -u root -p < 01_create_database.sql
--
-- Si el motor corre en Docker:
--   docker exec -it bdd_mysql_node2 mysql -u root -p
--   (y luego pegar el contenido de este archivo)
--
-- IMPORTANTE — Zona horaria:
-- MySQL usa la zona horaria del sistema operativo del contenedor por
-- defecto. Para forzar hora de Ecuador (UTC-5, sin horario de verano)
-- sin depender del SO del host, ejecutar antes de crear las tablas:
SET GLOBAL time_zone = '-05:00';
SET time_zone = '-05:00';
-- (Alternativa más permanente: agregar "command: --default-time-zone=-05:00"
--  al servicio mysql_node2 en el docker-compose.yml de este nodo.)
-- =====================================================================

CREATE DATABASE IF NOT EXISTS biblioteca
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_spanish_ci;

USE biblioteca;

-- A partir de aquí ya queda seleccionada la base "biblioteca", así que
-- 02_create_tables.sql se puede ejecutar directamente a continuación:
--   mysql -h 192.168.10.2 -P 3306 -u root -p biblioteca < 02_create_tables.sql
