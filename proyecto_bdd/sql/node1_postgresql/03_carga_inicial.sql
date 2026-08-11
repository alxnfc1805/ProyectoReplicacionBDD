-- =====================================================================
-- 03_carga_inicial.sql -- Nodo 1 (PostgreSQL)
-- Generado automáticamente por generate_data.py (no ingresado a mano)
-- Ejecutar conectado a la base 'biblioteca':
--   psql -h 192.168.10.1 -p 5432 -U admin_biblioteca -d biblioteca -f 03_carga_inicial.sql
-- =====================================================================

-- ESTANTES (20)
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-01', 'Pasillo C', 80);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-02', 'Pasillo C', 105);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-03', 'Pasillo B', 145);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-04', 'Pasillo C', 149);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-05', 'Pasillo A', 137);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-06', 'Pasillo B', 128);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-07', 'Pasillo B', 80);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-08', 'Pasillo D', 108);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-09', 'Pasillo C', 141);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-10', 'Pasillo B', 147);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-11', 'Pasillo C', 67);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-12', 'Pasillo B', 64);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-13', 'Pasillo C', 111);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-14', 'Pasillo C', 68);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-15', 'Pasillo B', 132);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-16', 'Pasillo C', 87);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-17', 'Pasillo D', 110);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-18', 'Pasillo D', 78);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-19', 'Pasillo C', 77);
INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) VALUES ('EST-20', 'Pasillo B', 131);

-- REPISAS (4)
INSERT INTO repisas (nombre_nivel, altura_cm) VALUES ('Baja', 30.0);
INSERT INTO repisas (nombre_nivel, altura_cm) VALUES ('Media', 60.0);
INSERT INTO repisas (nombre_nivel, altura_cm) VALUES ('Alta', 90.0);
INSERT INTO repisas (nombre_nivel, altura_cm) VALUES ('Superior', 120.0);

-- CATEGORIA (20) -- catálogo maestro completo
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Bases de Datos', 'Modelado, administración y motores de bases de datos relacionales y NoSQL.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Redes de Computadoras', 'Protocolos, arquitecturas y administración de redes.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Inteligencia Artificial', 'Fundamentos y aplicaciones de sistemas inteligentes.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Programación', 'Lenguajes de programación y paradigmas de desarrollo.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Sistemas Operativos', 'Diseño, administración y funcionamiento de sistemas operativos.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Ciberseguridad', 'Seguridad informática, criptografía aplicada y ethical hacking.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Ingeniería de Software', 'Procesos, metodologías y gestión de proyectos de software.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Estructuras de Datos', 'Organización y manipulación eficiente de datos en memoria.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Algoritmos', 'Diseño, análisis y complejidad de algoritmos.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Computación en la Nube', 'Servicios, arquitecturas y administración de infraestructura cloud.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Desarrollo Web', 'Tecnologías y frameworks para aplicaciones web.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Desarrollo Móvil', 'Programación de aplicaciones para dispositivos móviles.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Machine Learning', 'Aprendizaje automático y modelos predictivos.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Ciencia de Datos', 'Análisis, visualización y minería de datos.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Arquitectura de Computadores', 'Organización interna y diseño de hardware de cómputo.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Sistemas Distribuidos', 'Diseño y coordinación de sistemas en múltiples nodos.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Compiladores', 'Teoría y construcción de compiladores e intérpretes.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Criptografía', 'Fundamentos matemáticos de la seguridad de la información.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Internet de las Cosas', 'Sistemas embebidos y conectividad de dispositivos IoT.');
INSERT INTO categoria (nombre_categoria, descripcion) VALUES ('Realidad Virtual y Aumentada', 'Tecnologías inmersivas y computación gráfica.');

-- USUARIOS -- fragmento Estudiante (30, ids 1-30)
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (1, '1627694430', 'Nicolás', 'Chuquimarca Cañizares', 'nicolas.chuquimarca@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (2, '1428853029', 'Ariana', 'Rojas Guamán', 'ariana.rojas@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (3, '1547099690', 'Emma', 'Naranjo Sisalema', 'emma.naranjo@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (4, '1050590821', 'Luciana', 'Simbaña Toapanta', 'luciana.simbaña@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (5, '1171779360', 'Mía', 'Sisalema Cando', 'mia.sisalema@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (6, '1413140753', 'Ariana', 'Farinango Simbaña', 'ariana.farinango@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (7, '1568132202', 'Martina', 'Farinango Salazar', 'martina.farinango@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (8, '1012327652', 'Ivanna', 'Montenegro Bravo', 'ivanna.montenegro@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (9, '1576567501', 'Mía', 'Reyes Rojas', 'mia.reyes@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (10, '1365260635', 'Mathías', 'Toapanta Cando', 'mathias.toapanta@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (11, '1169820594', 'Mía', 'Guaman Chávez', 'mia.guaman@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (12, '1940439931', 'Mateo', 'Palacios Cañizares', 'mateo.palacios@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (13, '1191825997', 'Ivanna', 'Tenesaca Toapanta', 'ivanna.tenesaca@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (14, '1934712197', 'Camila', 'Pilliza Espinoza', 'camila.pilliza@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (15, '1545098869', 'David', 'Herrera Cando', 'david.herrera@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (16, '1401486939', 'Valentina', 'Yépez Sisalema', 'valentina.yepez@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (17, '1990456049', 'Abigail', 'Montenegro Toapanta', 'abigail.montenegro@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (18, '1643111853', 'Sebastián', 'Pilliza Palacios', 'sebastian.pilliza@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (19, '1120117054', 'Leonardo', 'Vega Palacios', 'leonardo.vega@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (20, '1866267851', 'Emma', 'Rojas Herrera', 'emma.rojas@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (21, '1258633898', 'David', 'Naranjo Andrade', 'david.naranjo@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (22, '1785879795', 'Renata', 'Simbaña Simbaña', 'renata.simbaña@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (23, '1816690353', 'Luciana', 'Herrera Simbaña', 'luciana.herrera@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (24, '1137859287', 'Nicolás', 'Toapanta Sisalema', 'nicolas.toapanta@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (25, '1284602384', 'Ismael', 'Montenegro Pilamunga', 'ismael.montenegro@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (26, '1454340903', 'Sebastián', 'Bravo Farinango', 'sebastian.bravo@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (27, '1810959828', 'Gabriel', 'Pilliza Montenegro', 'gabriel.pilliza@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (28, '1428414718', 'Amelia', 'Villacís Guaman', 'amelia.villacis@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (29, '1555742829', 'Emma', 'Salazar Rojas', 'emma.salazar@uni.edu.ec', 'Estudiante');
INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) VALUES (30, '1241266931', 'Samuel', 'Espinoza Naranjo', 'samuel.espinoza@uni.edu.ec', 'Estudiante');

-- PRESTAMOS -- fragmento Activo (80, ids 1-80)
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (1, 74, 33, '2026-05-14', '2026-05-28', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (2, 20, 31, '2026-05-15', '2026-05-29', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (3, 14, 23, '2026-06-27', '2026-07-11', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (4, 48, 8, '2026-05-22', '2026-06-05', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (5, 74, 15, '2026-06-10', '2026-06-24', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (6, 72, 40, '2026-07-04', '2026-07-18', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (7, 87, 36, '2026-04-20', '2026-05-04', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (8, 78, 18, '2026-04-20', '2026-05-04', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (9, 24, 18, '2026-07-15', '2026-07-29', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (10, 98, 20, '2026-05-30', '2026-06-13', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (11, 45, 1, '2026-05-10', '2026-05-24', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (12, 19, 37, '2026-07-10', '2026-07-24', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (13, 52, 5, '2026-05-05', '2026-05-19', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (14, 95, 2, '2026-04-28', '2026-05-12', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (15, 96, 34, '2026-05-14', '2026-05-28', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (16, 49, 27, '2026-06-14', '2026-06-28', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (17, 44, 11, '2026-06-03', '2026-06-17', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (18, 40, 21, '2026-06-28', '2026-07-12', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (19, 77, 6, '2026-04-23', '2026-05-07', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (20, 20, 11, '2026-07-05', '2026-07-19', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (21, 7, 6, '2026-05-21', '2026-06-04', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (22, 57, 28, '2026-06-18', '2026-07-02', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (23, 78, 29, '2026-06-09', '2026-06-23', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (24, 35, 14, '2026-06-21', '2026-07-05', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (25, 15, 23, '2026-06-11', '2026-06-25', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (26, 15, 19, '2026-07-12', '2026-07-26', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (27, 87, 38, '2026-06-18', '2026-07-02', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (28, 68, 20, '2026-04-22', '2026-05-06', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (29, 29, 26, '2026-07-02', '2026-07-16', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (30, 8, 1, '2026-05-13', '2026-05-27', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (31, 39, 14, '2026-05-04', '2026-05-18', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (32, 98, 17, '2026-05-24', '2026-06-07', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (33, 42, 8, '2026-04-17', '2026-05-01', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (34, 64, 28, '2026-05-09', '2026-05-23', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (35, 17, 25, '2026-06-24', '2026-07-08', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (36, 91, 15, '2026-06-20', '2026-07-04', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (37, 72, 23, '2026-04-26', '2026-05-10', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (38, 51, 3, '2026-06-11', '2026-06-25', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (39, 3, 30, '2026-04-26', '2026-05-10', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (40, 41, 37, '2026-06-10', '2026-06-24', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (41, 74, 26, '2026-07-07', '2026-07-21', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (42, 54, 19, '2026-05-01', '2026-05-15', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (43, 52, 2, '2026-05-28', '2026-06-11', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (44, 22, 40, '2026-06-14', '2026-06-28', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (45, 89, 24, '2026-04-28', '2026-05-12', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (46, 56, 7, '2026-05-18', '2026-06-01', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (47, 56, 38, '2026-06-07', '2026-06-21', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (48, 68, 6, '2026-06-06', '2026-06-20', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (49, 40, 22, '2026-05-15', '2026-05-29', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (50, 43, 11, '2026-04-26', '2026-05-10', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (51, 66, 8, '2026-06-23', '2026-07-07', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (52, 66, 13, '2026-05-31', '2026-06-14', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (53, 45, 10, '2026-05-17', '2026-05-31', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (54, 14, 10, '2026-05-19', '2026-06-02', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (55, 26, 12, '2026-07-03', '2026-07-17', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (56, 20, 5, '2026-05-09', '2026-05-23', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (57, 99, 32, '2026-06-15', '2026-06-29', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (58, 97, 37, '2026-06-30', '2026-07-14', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (59, 58, 37, '2026-07-08', '2026-07-22', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (60, 82, 40, '2026-05-28', '2026-06-11', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (61, 81, 21, '2026-05-06', '2026-05-20', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (62, 57, 5, '2026-06-16', '2026-06-30', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (63, 57, 20, '2026-05-22', '2026-06-05', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (64, 76, 4, '2026-06-01', '2026-06-15', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (65, 65, 5, '2026-05-26', '2026-06-09', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (66, 60, 29, '2026-04-21', '2026-05-05', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (67, 8, 24, '2026-05-23', '2026-06-06', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (68, 10, 6, '2026-07-04', '2026-07-18', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (69, 77, 33, '2026-06-05', '2026-06-19', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (70, 60, 38, '2026-06-26', '2026-07-10', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (71, 95, 3, '2026-06-13', '2026-06-27', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (72, 74, 13, '2026-05-28', '2026-06-11', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (73, 78, 31, '2026-06-20', '2026-07-04', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (74, 20, 4, '2026-06-13', '2026-06-27', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (75, 14, 22, '2026-04-27', '2026-05-11', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (76, 65, 12, '2026-04-22', '2026-05-06', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (77, 32, 29, '2026-06-12', '2026-06-26', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (78, 68, 34, '2026-07-04', '2026-07-18', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (79, 21, 24, '2026-06-03', '2026-06-17', NULL, 'Activo');
INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) VALUES (80, 37, 25, '2026-06-08', '2026-06-22', NULL, 'Activo');

-- Reajustar las secuencias SERIAL tras la carga con ids explícitos
SELECT setval('usuarios_id_usuario_seq', (SELECT MAX(id_usuario) FROM usuarios));
SELECT setval('prestamos_id_prestamo_seq', (SELECT MAX(id_prestamo) FROM prestamos));
SELECT setval('estantes_id_estante_seq', (SELECT MAX(id_estante) FROM estantes));
SELECT setval('repisas_id_repisa_seq', (SELECT MAX(id_repisa) FROM repisas));
SELECT setval('categoria_id_categoria_seq', (SELECT MAX(id_categoria) FROM categoria));
