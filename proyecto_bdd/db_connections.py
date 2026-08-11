"""
db_connections.py
Funciones de conexión y prueba de conectividad real para los tres motores.
"""
import time
import socket


def check_port(host, port, timeout=2):
    """Verifica si el puerto TCP está abierto (paso previo antes de intentar login SQL)."""
    try:
        with socket.create_connection((host, port), timeout=timeout):
            return True
    except OSError:
        return False


def connect_postgresql(node):
    import psycopg2
    return psycopg2.connect(
        host=node["host"],
        port=node["port"],
        user=node["user"],
        password=node["password"],
        dbname=node["database"],
        connect_timeout=5,
        client_encoding="UTF8",
    )


def connect_mysql(node):
    import mysql.connector
    return mysql.connector.connect(
        host=node["host"],
        port=node["port"],
        user=node["user"],
        password=node["password"],
        database=node["database"],
        connection_timeout=5,
    )


def connect_sqlserver(node):
    import pyodbc
    drivers = [d for d in pyodbc.drivers() if "SQL Server" in d]
    driver = drivers[0] if drivers else "ODBC Driver 18 for SQL Server"
    conn_str = (
        f"DRIVER={{{driver}}};"
        f"SERVER={node['host']},{node['port']};"
        f"DATABASE={node['database']};"
        f"UID={node['user']};PWD={node['password']};"
        f"TrustServerCertificate=yes;"
        f"Connection Timeout=5;"
    )
    conn = pyodbc.connect(conn_str, autocommit=True)
    # Fuerza UTF-8 en ambos sentidos, independiente del collation de la
    # base o de si alguna columna quedó como VARCHAR en vez de NVARCHAR.
    conn.setdecoding(pyodbc.SQL_CHAR, encoding="utf-8")
    conn.setdecoding(pyodbc.SQL_WCHAR, encoding="utf-8")
    conn.setencoding(encoding="utf-8")
    return conn


CONNECTORS = {
    "postgresql": connect_postgresql,
    "mysql": connect_mysql,
    "sqlserver": connect_sqlserver,
}


def test_connection(node):
    """
    Intenta conectarse al nodo indicado.
    Retorna (ok: bool, mensaje: str, ms: float)
    """
    start = time.time()
    port_open = check_port(node["host"], node["port"])
    if not port_open:
        elapsed = (time.time() - start) * 1000
        return False, f"No se pudo alcanzar {node['host']}:{node['port']} (puerto cerrado o firewall)", elapsed

    try:
        conn = CONNECTORS[node["engine"]](node)
        conn.close()
        elapsed = (time.time() - start) * 1000
        return True, f"Conexión exitosa a {node['nombre']} ({node['host']}:{node['port']})", elapsed
    except Exception as e:
        elapsed = (time.time() - start) * 1000
        return False, f"Puerto abierto pero falló la autenticación/login: {e}", elapsed
