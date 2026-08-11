-- =====================================================================
-- 04_fragmentacion.sql — Nodo 3 (SQL Server)
-- =====================================================================
-- Ejecutar conectado a la base 'biblioteca':
--   sqlcmd -S 192.168.10.3,1433 -U sa -P "BiblioSQL2026!" -d biblioteca -i 04_fragmentacion.sql
--
-- Este nodo aloja únicamente:
--   - prestamos -> fragmento Atrasado
-- No aloja usuarios (por eso no participa en esa fragmentación).
-- =====================================================================

USE biblioteca;
GO

-- ---------------------------------------------------------------------
-- Fragmento: prestamos (Atrasado)
-- "WITH CHECK" fuerza a validar también las filas ya existentes, no
-- solo las futuras (por defecto SQL Server valida siempre, pero se deja
-- explícito para que quede documentado).
-- ---------------------------------------------------------------------
ALTER TABLE prestamos WITH CHECK
    ADD CONSTRAINT chk_prestamos_fragmento_atrasado
    CHECK (estado_prestamo = 'Atrasado');
GO

-- ---------------------------------------------------------------------
-- Verificación de completitud/disjunción local
-- ---------------------------------------------------------------------
SELECT 'prestamos' AS tabla, estado_prestamo, COUNT(*) AS filas
FROM prestamos GROUP BY estado_prestamo;
GO

-- ---------------------------------------------------------------------
-- Prueba de rechazo (para la demo en vivo): esto DEBE fallar con
-- "The INSERT statement conflicted with the CHECK constraint"
-- ---------------------------------------------------------------------
-- INSERT INTO prestamos (id_tema_ref, id_usuario_ref, fecha_prestamo,
--     fecha_devolucion_esperada, estado_prestamo)
-- VALUES (1, 1, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Activo');
-- Msg 547: The INSERT statement conflicted with the CHECK constraint
--          "chk_prestamos_fragmento_atrasado".
