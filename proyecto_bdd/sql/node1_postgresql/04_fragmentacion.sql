-- =====================================================================
-- 04_fragmentacion.sql — Nodo 1 (PostgreSQL)
-- =====================================================================
-- Ejecutar conectado a la base 'biblioteca':
--   psql -h 192.168.10.1 -p 5432 -U admin_biblioteca -d biblioteca -f 04_fragmentacion.sql
--
-- Este nodo aloja:
--   - usuarios  -> fragmento Estudiante
--   - prestamos -> fragmento Activo
-- Las tablas categoria, estantes, repisas NO se fragmentan (van completas
-- en este nodo), por lo que no llevan CHECK de fragmentación.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Fragmento: usuarios (Estudiante)
-- La cláusula "WITH CHECK" (implícita al usar ADD CONSTRAINT) valida
-- también las 30 filas ya cargadas; si alguna no cumpliera, el ALTER
-- fallaría y avisaría cuál.
-- ---------------------------------------------------------------------
ALTER TABLE usuarios
    ADD CONSTRAINT chk_usuarios_fragmento_estudiante
    CHECK (tipo_usuario = 'Estudiante');

-- ---------------------------------------------------------------------
-- Fragmento: prestamos (Activo)
-- ---------------------------------------------------------------------
ALTER TABLE prestamos
    ADD CONSTRAINT chk_prestamos_fragmento_activo
    CHECK (estado_prestamo = 'Activo');

-- ---------------------------------------------------------------------
-- Verificación de completitud/disjunción local (ejecutar y mostrar
-- durante la demo, sección 7 del protocolo: "Evidencia de fragmentación")
-- ---------------------------------------------------------------------
SELECT 'usuarios' AS tabla, tipo_usuario, COUNT(*) AS filas
FROM usuarios GROUP BY tipo_usuario;

SELECT 'prestamos' AS tabla, estado_prestamo, COUNT(*) AS filas
FROM prestamos GROUP BY estado_prestamo;

-- ---------------------------------------------------------------------
-- Prueba de rechazo (para la demo en vivo): esto DEBE fallar con
-- "violates check constraint" — demuestra que el fragmento está
-- realmente protegido, no solo por convención.
-- ---------------------------------------------------------------------
-- INSERT INTO prestamos (id_tema_ref, id_usuario_ref, fecha_prestamo,
--     fecha_devolucion_esperada, estado_prestamo)
-- VALUES (1, 1, CURRENT_DATE, CURRENT_DATE + 14, 'Devuelto');
-- ERROR: new row for relation "prestamos" violates check constraint
--        "chk_prestamos_fragmento_activo"
