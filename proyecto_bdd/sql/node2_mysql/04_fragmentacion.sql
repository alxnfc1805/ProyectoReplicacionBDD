-- =====================================================================
-- 04_fragmentacion.sql — Nodo 2 (MySQL)
-- =====================================================================
-- Ejecutar conectado a la base 'biblioteca':
--   mysql -h 192.168.10.2 -P 3306 -u root -p biblioteca < 04_fragmentacion.sql
--
-- Este nodo aloja:
--   - usuarios  -> fragmento Docente
--   - prestamos -> fragmento Devuelto
-- La tabla tema NO se fragmenta (va completa en este nodo).
--
-- IMPORTANTE: los CHECK constraints se validan de forma nativa (motor
-- real, no solo sintaxis aceptada) desde MySQL 8.0.16 en adelante. Si el
-- contenedor corre una versión anterior, MySQL acepta la sintaxis pero
-- NO la hace cumplir — verificar con: SELECT VERSION();
-- =====================================================================

-- ---------------------------------------------------------------------
-- Fragmento: usuarios (Docente)
-- ---------------------------------------------------------------------
ALTER TABLE usuarios
    ADD CONSTRAINT chk_usuarios_fragmento_docente
    CHECK (tipo_usuario = 'Docente');

-- ---------------------------------------------------------------------
-- Fragmento: prestamos (Devuelto)
-- ---------------------------------------------------------------------
ALTER TABLE prestamos
    ADD CONSTRAINT chk_prestamos_fragmento_devuelto
    CHECK (estado_prestamo = 'Devuelto');

-- ---------------------------------------------------------------------
-- Verificación de completitud/disjunción local
-- ---------------------------------------------------------------------
SELECT 'usuarios' AS tabla, tipo_usuario, COUNT(*) AS filas
FROM usuarios GROUP BY tipo_usuario;

SELECT 'prestamos' AS tabla, estado_prestamo, COUNT(*) AS filas
FROM prestamos GROUP BY estado_prestamo;

-- ---------------------------------------------------------------------
-- Prueba de rechazo (para la demo en vivo): esto DEBE fallar con
-- "Check constraint ... is violated"
-- ---------------------------------------------------------------------
-- INSERT INTO prestamos (id_tema_ref, id_usuario_ref, fecha_prestamo,
--     fecha_devolucion_esperada, estado_prestamo)
-- VALUES (1, 31, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), 'Activo');
-- ERROR 3819 (HY000): Check constraint 'chk_prestamos_fragmento_devuelto'
--        is violated.
