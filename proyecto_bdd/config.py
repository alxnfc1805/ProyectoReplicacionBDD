"""
config.py
Configuración de conexión a los tres nodos de la base de datos distribuida.

MODO = "local"      -> usa localhost con puertos distintos (para probar todo
                        en una sola máquina, con docker-compose.local.yml,
                        antes de desplegar en las 3 laptops físicas)
MODO = "produccion" -> usa las IPs físicas reales asignadas a cada laptop/nodo
                        el día de la demostración.
"""

MODO = "produccion"  # cambiar a "produccion" cuando se trabaje con las 3 laptops

if MODO == "local":
    NODES = {
        "nodo1": {
            "nombre": "Nodo 1 - PostgreSQL",
            "engine": "postgresql",
            "host": "localhost",
            "port": 5432,
            "user": "admin_biblioteca",
            "password": "BiblioPG2026",
            "database": "biblioteca",
        },
        "nodo2": {
            "nombre": "Nodo 2 - MySQL",
            "engine": "mysql",
            "host": "localhost",
            "port": 3306,
            "user": "root",
            "password": "BiblioMy2026",
            "database": "biblioteca",
        },
        "nodo3": {
            "nombre": "Nodo 3 - SQL Server",
            "engine": "sqlserver",
            "host": "localhost",
            "port": 1433,
            "user": "sa",
            "password": "BiblioSQL2026!",
            "database": "master",
        },
    }
else:  # produccion - IPs físicas fijas de cada laptop/nodo
    NODES = {
        "nodo1": {
            "nombre": "Nodo 1 - PostgreSQL",
            "engine": "postgresql",
            "host": "192.168.10.1",
            "port": 5432,
            "user": "admin_biblioteca",
            "password": "BiblioPG2026",
            "database": "biblioteca",
        },
        "nodo2": {
            "nombre": "Nodo 2 - MySQL",
            "engine": "mysql",
            "host": "192.168.10.2",
            "port": 3306,
            "user": "root",
            "password": "BiblioMy2026",
            "database": "biblioteca",
        },
        "nodo3": {
            "nombre": "Nodo 3 - SQL Server",
            "engine": "sqlserver",
            "host": "192.168.10.3",
            "port": 1433,
            "user": "sa",
            "password": "BiblioSQL2026!",
            "database": "biblioteca",
        },
    }
