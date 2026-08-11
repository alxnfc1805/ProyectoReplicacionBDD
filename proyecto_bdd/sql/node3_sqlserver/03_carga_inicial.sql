-- =====================================================================
-- 03_carga_inicial.sql -- Nodo 3 (SQL Server)
-- Generado automáticamente por generate_data.py (no ingresado a mano)
-- Ejecutar conectado a la base 'biblioteca':
--   sqlcmd -S 192.168.10.3,1433 -U sa -P "BiblioSQL2026!" -d biblioteca -i 03_carga_inicial.sql
-- =====================================================================

USE biblioteca;
GO

-- PRESTAMOS -- fragmento Atrasado (40, ids 161-200)
SET IDENTITY_INSERT prestamos ON;
GO
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (161, 51, 21, '2026-07-09', '2026-07-23', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (162, 36, 16, '2026-05-01', '2026-05-15', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (163, 4, 12, '2026-06-19', '2026-07-03', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (164, 67, 25, '2026-06-27', '2026-07-11', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (165, 16, 17, '2026-05-20', '2026-06-03', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (166, 91, 29, '2026-05-14', '2026-05-28', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (167, 79, 19, '2026-07-14', '2026-07-28', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (168, 63, 13, '2026-05-02', '2026-05-16', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (169, 18, 5, '2026-06-13', '2026-06-27', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (170, 23, 29, '2026-04-28', '2026-05-12', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (171, 88, 21, '2026-07-11', '2026-07-25', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (172, 45, 5, '2026-06-26', '2026-07-10', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (173, 70, 19, '2026-05-25', '2026-06-08', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (174, 21, 12, '2026-06-02', '2026-06-16', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (175, 66, 15, '2026-05-02', '2026-05-16', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (176, 26, 9, '2026-05-17', '2026-05-31', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (177, 64, 2, '2026-06-02', '2026-06-16', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (178, 71, 37, '2026-06-03', '2026-06-17', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (179, 60, 36, '2026-05-03', '2026-05-17', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (180, 79, 6, '2026-04-25', '2026-05-09', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (181, 40, 26, '2026-06-17', '2026-07-01', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (182, 68, 27, '2026-06-08', '2026-06-22', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (183, 74, 5, '2026-05-03', '2026-05-17', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (184, 41, 5, '2026-06-13', '2026-06-27', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (185, 60, 34, '2026-05-31', '2026-06-14', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (186, 17, 36, '2026-07-07', '2026-07-21', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (187, 76, 12, '2026-05-03', '2026-05-17', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (188, 56, 33, '2026-04-24', '2026-05-08', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (189, 16, 34, '2026-05-06', '2026-05-20', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (190, 39, 11, '2026-05-07', '2026-05-21', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (191, 42, 15, '2026-05-31', '2026-06-14', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (192, 67, 19, '2026-04-27', '2026-05-11', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (193, 33, 13, '2026-07-07', '2026-07-21', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (194, 71, 18, '2026-05-03', '2026-05-17', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (195, 81, 20, '2026-07-04', '2026-07-18', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (196, 69, 6, '2026-06-20', '2026-07-04', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (197, 83, 11, '2026-07-01', '2026-07-15', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (198, 75, 10, '2026-05-08', '2026-05-22', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (199, 85, 40, '2026-07-03', '2026-07-17', NULL, 'Atrasado');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (200, 44, 37, '2026-04-22', '2026-05-06', NULL, 'Atrasado');
GO
SET IDENTITY_INSERT prestamos OFF;
GO
