"""
db_operations.py
Operaciones CRUD genéricas: funcionan para cualquier tabla/nodo sin
necesitar código específico por motor, más allá del placeholder de
parámetros (%s en Postgres/MySQL, ? en SQL Server).
"""
from db_connections import CONNECTORS


def placeholder(engine):
    return "?" if engine == "sqlserver" else "%s"


def listar(node, tabla, orden_por=None):
    conn = CONNECTORS[node["engine"]](node)
    try:
        cur = conn.cursor()
        sql = f"SELECT * FROM {tabla}"
        if orden_por:
            sql += f" ORDER BY {orden_por}"
        cur.execute(sql)
        columnas = [d[0] for d in cur.description]
        filas = cur.fetchall()
        filas_limpias = [tuple(f) for f in filas]
        cur.close()
        return columnas, filas_limpias
    finally:
        conn.close()


def crear(node, tabla, datos: dict):
    conn = CONNECTORS[node["engine"]](node)
    try:
        ph = placeholder(node["engine"])
        cols = list(datos.keys())
        sql = f"INSERT INTO {tabla} ({', '.join(cols)}) VALUES ({', '.join([ph] * len(cols))})"
        cur = conn.cursor()
        cur.execute(sql, [datos[c] for c in cols])
        if node["engine"] != "sqlserver":
            conn.commit()
        cur.close()
    finally:
        conn.close()


def actualizar(node, tabla, pk, pk_valor, datos: dict):
    conn = CONNECTORS[node["engine"]](node)
    try:
        ph = placeholder(node["engine"])
        cols = [c for c in datos.keys() if c != pk]
        set_clause = ", ".join(f"{c} = {ph}" for c in cols)
        sql = f"UPDATE {tabla} SET {set_clause} WHERE {pk} = {ph}"
        valores = [datos[c] for c in cols] + [pk_valor]
        cur = conn.cursor()
        cur.execute(sql, valores)
        filas_afectadas = cur.rowcount
        if node["engine"] != "sqlserver":
            conn.commit()
        cur.close()
        return filas_afectadas
    finally:
        conn.close()


def eliminar(node, tabla, pk, pk_valor):
    conn = CONNECTORS[node["engine"]](node)
    try:
        ph = placeholder(node["engine"])
        sql = f"DELETE FROM {tabla} WHERE {pk} = {ph}"
        cur = conn.cursor()
        cur.execute(sql, [pk_valor])
        filas_afectadas = cur.rowcount
        if node["engine"] != "sqlserver":
            conn.commit()
        cur.close()
        return filas_afectadas
    finally:
        conn.close()


def contar(node, tabla):
    conn = CONNECTORS[node["engine"]](node)
    try:
        cur = conn.cursor()
        cur.execute(f"SELECT COUNT(*) FROM {tabla}")
        total = cur.fetchone()[0]
        cur.close()
        return total
    finally:
        conn.close()
