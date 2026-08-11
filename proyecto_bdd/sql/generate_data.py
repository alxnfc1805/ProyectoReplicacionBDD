"""
generate_data.py
Genera automáticamente los INSERT de carga inicial para los 3 nodos,
en la sintaxis correspondiente a cada motor (PostgreSQL, MySQL, SQL Server).

No requiere librerías externas (solo stdlib) para que corra en cualquier
máquina sin instalar nada extra.

Uso:
    python3 generate_data.py

Salida:
    sql/node1_postgresql/03_carga_inicial.sql
    sql/node2_mysql/03_carga_inicial.sql
    sql/node3_sqlserver/03_carga_inicial.sql
"""
import random
import datetime
import os

random.seed(42)  # reproducible: siempre genera los mismos datos

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# ---------------------------------------------------------------------
# Catálogo de categorías (20) - temática de sistemas informáticos
# ---------------------------------------------------------------------
CATEGORIAS = [
    ("Bases de Datos", "Modelado, administración y motores de bases de datos relacionales y NoSQL."),
    ("Redes de Computadoras", "Protocolos, arquitecturas y administración de redes."),
    ("Inteligencia Artificial", "Fundamentos y aplicaciones de sistemas inteligentes."),
    ("Programación", "Lenguajes de programación y paradigmas de desarrollo."),
    ("Sistemas Operativos", "Diseño, administración y funcionamiento de sistemas operativos."),
    ("Ciberseguridad", "Seguridad informática, criptografía aplicada y ethical hacking."),
    ("Ingeniería de Software", "Procesos, metodologías y gestión de proyectos de software."),
    ("Estructuras de Datos", "Organización y manipulación eficiente de datos en memoria."),
    ("Algoritmos", "Diseño, análisis y complejidad de algoritmos."),
    ("Computación en la Nube", "Servicios, arquitecturas y administración de infraestructura cloud."),
    ("Desarrollo Web", "Tecnologías y frameworks para aplicaciones web."),
    ("Desarrollo Móvil", "Programación de aplicaciones para dispositivos móviles."),
    ("Machine Learning", "Aprendizaje automático y modelos predictivos."),
    ("Ciencia de Datos", "Análisis, visualización y minería de datos."),
    ("Arquitectura de Computadores", "Organización interna y diseño de hardware de cómputo."),
    ("Sistemas Distribuidos", "Diseño y coordinación de sistemas en múltiples nodos."),
    ("Compiladores", "Teoría y construcción de compiladores e intérpretes."),
    ("Criptografía", "Fundamentos matemáticos de la seguridad de la información."),
    ("Internet de las Cosas", "Sistemas embebidos y conectividad de dispositivos IoT."),
    ("Realidad Virtual y Aumentada", "Tecnologías inmersivas y computación gráfica."),
]

TOPICOS_TITULO = [c[0] for c in CATEGORIAS]

CALIFICADORES = [
    "Fundamentos de", "Introducción a", "Guía práctica de", "Manual avanzado de",
    "Principios de", "Arquitectura de", "Programación aplicada a", "Teoría de",
    "Aplicaciones modernas de", "Curso completo de", "Conceptos esenciales de",
    "Diseño y desarrollo en", "Fundamentos avanzados de", "Estrategias de",
]

AUTORES = [
    "Andrés Villacís", "María Fernanda Reyes", "Carlos Salazar", "Lucía Andrade",
    "Diego Herrera", "Paola Chávez", "Javier Montenegro", "Verónica Espinoza",
    "Roberto Cañizares", "Gabriela Ortiz", "Fernando Palacios", "Silvia Naranjo",
    "Martin Rojas", "Daniela Vega", "Kristian Bravo", "Elena Torres",
    "William Sánchez", "Adriana Freire", "Óscar Guamán", "Camila Puma",
]

NOMBRES = [
    "Mateo", "Valentina", "Samuel", "Isabella", "Emilio", "Camila", "Sebastián",
    "Doménica", "Nicolás", "Emily", "Julián", "Mía", "Santiago", "Sofía",
    "Alejandro", "Renata", "Joaquín", "Antonella", "Gabriel", "Martina",
    "Leonardo", "Abigail", "David", "Amelia", "Iker", "Zoe", "Mathías",
    "Luciana", "Thiago", "Emma", "Adrián", "Regina", "Bruno", "Ariana",
    "Cristóbal", "Ivanna", "Josué", "Paulette", "Ismael", "Danna",
]

APELLIDOS = [
    "Quishpe", "Toapanta", "Guamán", "Cando", "Chuquimarca", "Simbaña",
    "Yépez", "Pilamunga", "Cajamarca", "Tenesaca", "Sisalema", "Pilliza",
    "Farinango", "Guaman", "Villacís", "Cárdenas", "Salazar", "Reyes",
    "Andrade", "Herrera", "Chávez", "Montenegro", "Espinoza", "Cañizares",
    "Ortiz", "Palacios", "Naranjo", "Rojas", "Vega", "Bravo",
]

random.shuffle(NOMBRES)
random.shuffle(APELLIDOS)


def sql_str(texto):
    """Escapa comillas simples para uso seguro en las 3 sintaxis SQL."""
    return texto.replace("'", "''")


def random_fecha(inicio, fin):
    delta = (fin - inicio).days
    return inicio + datetime.timedelta(days=random.randint(0, delta))


# ---------------------------------------------------------------------
# 1) ESTANTES (20) y REPISAS (4) - Nodo 1
# ---------------------------------------------------------------------
def generar_estantes():
    pasillos = ["Pasillo A", "Pasillo B", "Pasillo C", "Pasillo D"]
    filas = []
    for i in range(1, 21):
        codigo = f"EST-{i:02d}"
        pasillo = random.choice(pasillos)
        capacidad = random.randint(60, 150)
        filas.append((codigo, pasillo, capacidad))
    return filas


def generar_repisas():
    return [
        ("Baja", 30.00),
        ("Media", 60.00),
        ("Alta", 90.00),
        ("Superior", 120.00),
    ]


# ---------------------------------------------------------------------
# 2) TEMA (100) - Nodo 2
# ---------------------------------------------------------------------
def generar_temas():
    combinaciones = []
    for topico in TOPICOS_TITULO:
        for calificador in CALIFICADORES:
            combinaciones.append((calificador, topico))
    random.shuffle(combinaciones)
    combinaciones = combinaciones[:100]

    filas = []
    for idx, (calificador, topico) in enumerate(combinaciones, start=1):
        titulo = f"{calificador} {topico}"
        autor = random.choice(AUTORES)
        isbn = f"978-{random.randint(100,999)}-{random.randint(10,99)}-{random.randint(1000,9999)}-{random.randint(0,9)}"
        anio = random.randint(2005, 2026)
        id_categoria_ref = TOPICOS_TITULO.index(topico) + 1  # 1..20
        id_estante_ref = random.randint(1, 20)
        id_repisa_ref = random.randint(1, 4)
        disponible = 1 if random.random() < 0.75 else 0
        filas.append((idx, titulo, autor, isbn, anio, id_categoria_ref,
                       id_estante_ref, id_repisa_ref, disponible))
    return filas


# ---------------------------------------------------------------------
# 3) USUARIOS (40): 30 Estudiante (Nodo 1) + 10 Docente (Nodo 2)
# ---------------------------------------------------------------------
def generar_usuarios():
    usuarios = []
    usados = set()
    for i in range(1, 41):
        while True:
            nombre = random.choice(NOMBRES)
            apellido1 = random.choice(APELLIDOS)
            apellido2 = random.choice(APELLIDOS)
            key = (nombre, apellido1, apellido2)
            if key not in usados:
                usados.add(key)
                break
        cedula = f"{random.randint(1000000000, 1999999999)}"
        correo = f"{nombre.lower()}.{apellido1.lower()}@uni.edu.ec".replace("é", "e").replace("í", "i") \
            .replace("á", "a").replace("ó", "o").replace("ú", "u")
        tipo = "Estudiante" if i <= 30 else "Docente"
        usuarios.append((i, cedula, nombre, f"{apellido1} {apellido2}", correo, tipo))
    return usuarios


# ---------------------------------------------------------------------
# 4) PRESTAMOS (200): 80 Activo (Nodo1) + 80 Devuelto (Nodo2) + 40 Atrasado (Nodo3)
# ---------------------------------------------------------------------
def generar_prestamos():
    hoy = datetime.date(2026, 7, 16)
    prestamos = []

    def nuevo(id_prestamo, estado):
        id_tema_ref = random.randint(1, 100)
        id_usuario_ref = random.randint(1, 40)
        f_prestamo = random_fecha(hoy - datetime.timedelta(days=90), hoy - datetime.timedelta(days=1))
        f_esperada = f_prestamo + datetime.timedelta(days=14)

        if estado == "Devuelto":
            f_real = f_esperada - datetime.timedelta(days=random.randint(-3, 5))
            if f_real > hoy:
                f_real = hoy
        else:
            f_real = None  # Activo y Atrasado aún no se devuelven

        return (id_prestamo, id_tema_ref, id_usuario_ref, f_prestamo, f_esperada, f_real, estado)

    idx = 1
    for _ in range(80):
        prestamos.append(nuevo(idx, "Activo")); idx += 1
    for _ in range(80):
        prestamos.append(nuevo(idx, "Devuelto")); idx += 1
    for _ in range(40):
        prestamos.append(nuevo(idx, "Atrasado")); idx += 1

    return prestamos


# ---------------------------------------------------------------------
# Formateo de fecha portable entre los 3 motores
# ---------------------------------------------------------------------
def f_date(d):
    return "NULL" if d is None else f"'{d.isoformat()}'"


# =======================================================================
# NODO 1 - PostgreSQL: estantes, repisas, categoria, usuarios(Estudiante), prestamos(Activo)
# =======================================================================
def escribir_node1(estantes, repisas, categorias, usuarios, prestamos):
    path = os.path.join(BASE_DIR, "node1_postgresql", "03_carga_inicial.sql")
    with open(path, "w", encoding="utf-8") as f:
        f.write("-- =====================================================================\n")
        f.write("-- 03_carga_inicial.sql -- Nodo 1 (PostgreSQL)\n")
        f.write("-- Generado automáticamente por generate_data.py (no ingresado a mano)\n")
        f.write("-- Ejecutar conectado a la base 'biblioteca':\n")
        f.write("--   psql -h 192.168.10.1 -p 5432 -U admin_biblioteca -d biblioteca -f 03_carga_inicial.sql\n")
        f.write("-- =====================================================================\n\n")

        f.write("-- ESTANTES (20)\n")
        for codigo, pasillo, capacidad in estantes:
            f.write(
                f"INSERT INTO estantes (codigo_estante, pasillo, capacidad_maxima) "
                f"VALUES ('{codigo}', '{sql_str(pasillo)}', {capacidad});\n"
            )

        f.write("\n-- REPISAS (4)\n")
        for nombre_nivel, altura in repisas:
            f.write(
                f"INSERT INTO repisas (nombre_nivel, altura_cm) VALUES ('{nombre_nivel}', {altura});\n"
            )

        f.write("\n-- CATEGORIA (20) -- catálogo maestro completo\n")
        for nombre_cat, desc in categorias:
            f.write(
                f"INSERT INTO categoria (nombre_categoria, descripcion) "
                f"VALUES ('{sql_str(nombre_cat)}', '{sql_str(desc)}');\n"
            )

        f.write("\n-- USUARIOS -- fragmento Estudiante (30, ids 1-30)\n")
        for id_u, cedula, nombres, apellidos, correo, tipo in usuarios:
            if tipo != "Estudiante":
                continue
            f.write(
                f"INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) "
                f"VALUES ({id_u}, '{cedula}', '{sql_str(nombres)}', '{sql_str(apellidos)}', "
                f"'{correo}', '{tipo}');\n"
            )

        f.write("\n-- PRESTAMOS -- fragmento Activo (80, ids 1-80)\n")
        for id_p, id_tema, id_usr, f_prestamo, f_esperada, f_real, estado in prestamos:
            if estado != "Activo":
                continue
            f.write(
                f"INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, "
                f"fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) "
                f"VALUES ({id_p}, {id_tema}, {id_usr}, {f_date(f_prestamo)}, {f_date(f_esperada)}, "
                f"{f_date(f_real)}, '{estado}');\n"
            )

        f.write("\n-- Reajustar las secuencias SERIAL tras la carga con ids explícitos\n")
        f.write("SELECT setval('usuarios_id_usuario_seq', (SELECT MAX(id_usuario) FROM usuarios));\n")
        f.write("SELECT setval('prestamos_id_prestamo_seq', (SELECT MAX(id_prestamo) FROM prestamos));\n")
        f.write("SELECT setval('estantes_id_estante_seq', (SELECT MAX(id_estante) FROM estantes));\n")
        f.write("SELECT setval('repisas_id_repisa_seq', (SELECT MAX(id_repisa) FROM repisas));\n")
        f.write("SELECT setval('categoria_id_categoria_seq', (SELECT MAX(id_categoria) FROM categoria));\n")
    return path


# =======================================================================
# NODO 2 - MySQL: tema, usuarios(Docente), prestamos(Devuelto)
# =======================================================================
def escribir_node2(temas, usuarios, prestamos):
    path = os.path.join(BASE_DIR, "node2_mysql", "03_carga_inicial.sql")
    with open(path, "w", encoding="utf-8") as f:
        f.write("-- =====================================================================\n")
        f.write("-- 03_carga_inicial.sql -- Nodo 2 (MySQL)\n")
        f.write("-- Generado automáticamente por generate_data.py (no ingresado a mano)\n")
        f.write("-- Ejecutar conectado a la base 'biblioteca':\n")
        f.write("--   mysql -h 192.168.10.2 -P 3306 -u root -p biblioteca < 03_carga_inicial.sql\n")
        f.write("-- =====================================================================\n\n")

        f.write("-- TEMA (100) -- catálogo completo\n")
        for id_t, titulo, autor, isbn, anio, id_cat, id_est, id_rep, disp in temas:
            f.write(
                f"INSERT INTO tema (id_tema, titulo, autor, isbn, anio_publicacion, "
                f"id_categoria_ref, id_estante_ref, id_repisa_ref, disponible) "
                f"VALUES ({id_t}, '{sql_str(titulo)}', '{sql_str(autor)}', '{isbn}', {anio}, "
                f"{id_cat}, {id_est}, {id_rep}, {disp});\n"
            )

        f.write("\n-- USUARIOS -- fragmento Docente (10, ids 31-40)\n")
        for id_u, cedula, nombres, apellidos, correo, tipo in usuarios:
            if tipo != "Docente":
                continue
            f.write(
                f"INSERT INTO usuarios (id_usuario, cedula, nombres, apellidos, correo_institucional, tipo_usuario) "
                f"VALUES ({id_u}, '{cedula}', '{sql_str(nombres)}', '{sql_str(apellidos)}', "
                f"'{correo}', '{tipo}');\n"
            )

        f.write("\n-- PRESTAMOS -- fragmento Devuelto (80, ids 81-160)\n")
        for id_p, id_tema, id_usr, f_prestamo, f_esperada, f_real, estado in prestamos:
            if estado != "Devuelto":
                continue
            f.write(
                f"INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, "
                f"fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) "
                f"VALUES ({id_p}, {id_tema}, {id_usr}, {f_date(f_prestamo)}, {f_date(f_esperada)}, "
                f"{f_date(f_real)}, '{estado}');\n"
            )

        f.write("\n-- Nota: en MySQL, AUTO_INCREMENT se autoajusta al insertar ids explícitos\n")
        f.write("-- mayores al contador actual; no se requiere ALTER TABLE adicional.\n")
    return path


# =======================================================================
# NODO 3 - SQL Server: prestamos(Atrasado)
# =======================================================================
def escribir_node3(prestamos):
    path = os.path.join(BASE_DIR, "node3_sqlserver", "03_carga_inicial.sql")
    with open(path, "w", encoding="utf-8") as f:
        f.write("-- =====================================================================\n")
        f.write("-- 03_carga_inicial.sql -- Nodo 3 (SQL Server)\n")
        f.write("-- Generado automáticamente por generate_data.py (no ingresado a mano)\n")
        f.write("-- Ejecutar conectado a la base 'biblioteca':\n")
        f.write("--   sqlcmd -S 192.168.10.3,1433 -U sa -P \"BiblioSQL2026!\" -d biblioteca -i 03_carga_inicial.sql\n")
        f.write("-- =====================================================================\n\n")

        f.write("USE biblioteca;\nGO\n\n")
        f.write("-- PRESTAMOS -- fragmento Atrasado (40, ids 161-200)\n")
        f.write("SET IDENTITY_INSERT prestamos ON;\nGO\n")
        for id_p, id_tema, id_usr, f_prestamo, f_esperada, f_real, estado in prestamos:
            if estado != "Atrasado":
                continue
            f.write(
                f"INSERT INTO prestamos (id_prestamo, id_tema_ref, id_usuario_ref, fecha_prestamo, "
                f"fecha_devolucion_esperada, fecha_devolucion_real, estado_prestamo) "
                f"VALUES ({id_p}, {id_tema}, {id_usr}, {f_date(f_prestamo)}, {f_date(f_esperada)}, "
                f"{f_date(f_real)}, '{estado}');\n"
            )
        f.write("GO\n")
        f.write("SET IDENTITY_INSERT prestamos OFF;\nGO\n")
    return path


def main():
    estantes = generar_estantes()
    repisas = generar_repisas()
    usuarios = generar_usuarios()
    temas = generar_temas()
    prestamos = generar_prestamos()

    p1 = escribir_node1(estantes, repisas, CATEGORIAS, usuarios, prestamos)
    p2 = escribir_node2(temas, usuarios, prestamos)
    p3 = escribir_node3(prestamos)

    print("Generado:")
    print(" -", p1)
    print(" -", p2)
    print(" -", p3)
    print(f"\nTotales -> estantes:{len(estantes)} repisas:{len(repisas)} categoria:{len(CATEGORIAS)} "
          f"tema:{len(temas)} usuarios:{len(usuarios)} prestamos:{len(prestamos)}")


if __name__ == "__main__":
    main()
