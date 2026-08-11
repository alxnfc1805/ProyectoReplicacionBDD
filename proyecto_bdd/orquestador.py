import psycopg2          # Para PostgreSQL
import mysql.connector   # Para MySQL
import pyodbc            # Para SQL Server
import time
import json

# 1. Configurar las 3 conexiones con el usuario técnico de replicación
pg_conn = psycopg2.connect(host="192.168.10.1", user="usr_replicador", password="UsrReplicador2026", dbname="biblioteca")
my_conn = mysql.connector.connect(host="192.168.10.2", user="usr_replicador", password="UsrReplicador2026", database="biblioteca")
sql_conn = pyodbc.connect('DRIVER={SQL Server};SERVER=192.168.10.3;DATABASE=biblioteca;UID=usr_replicador;PWD=UsrReplicador2026!')

# autcommit
pg_conn.autocommit = True
my_conn.autocommit = True
sql_conn.autocommit = True

# Mapeo exacto de las llaves primarias por tabla para evitar errores de identidad
PK_MAP = {
    'categoria': 'id_categoria',
    'estantes': 'id_estante',
    'repisas': 'id_repisa',
    'tema': 'id_tema'
}

def ejecutar_en_destino(conexion, tabla, accion, datos):
    """Función genérica para armar y ejecutar el INSERT/UPDATE en el nodo destino"""
    cursor = conexion.cursor()
    ph = '?' if isinstance(conexion, pyodbc.Connection) else '%s'
    is_sqlserver = isinstance(conexion, pyodbc.Connection)
    
    if accion == 'INSERT':
        columnas = ', '.join(datos.keys())
        placeholders = ', '.join([ph] * len(datos))
        valores = tuple(datos.values())
        
        try:
            # Habilitar inserción manual en columnas Identity si es SQL Server
            if is_sqlserver:
                try:
                    cursor.execute(f"SET IDENTITY_INSERT {tabla} ON")
                except Exception:
                    pass
            
            sql = f"INSERT INTO {tabla} ({columnas}) VALUES ({placeholders})"
            cursor.execute(sql, valores)
            
            # Deshabilitar IDENTITY_INSERT tras la inserción
            if is_sqlserver:
                try:
                    cursor.execute(f"SET IDENTITY_INSERT {tabla} OFF")
                except Exception:
                    pass
                
        except Exception as e:
            if is_sqlserver:
                try:
                    cursor.execute(f"SET IDENTITY_INSERT {tabla} OFF")
                except:
                    pass
            raise e
        
    elif accion == 'UPDATE':
        pk_col = PK_MAP.get(tabla)
        if not pk_col or pk_col not in datos:
            pk_col = next((k for k in datos.keys() if k.lower() == f"id_{tabla.lower()}"), list(datos.keys())[0])
            
        columnas_a_actualizar = [k for k in datos.keys() if k != pk_col]
        
        set_cols = ', '.join([f"{k} = {ph}" for k in columnas_a_actualizar])
        valores = tuple([datos[k] for k in columnas_a_actualizar] + [datos[pk_col]])
        
        sql = f"UPDATE {tabla} SET {set_cols} WHERE {pk_col} = {ph}"
        cursor.execute(sql, valores)
        
    conexion.commit()
    cursor.close()

def orquestar_replicacion():
    while True:
        try:
            # --- REVISAR COLA DE POSTGRESQL ---
            pg_cursor = pg_conn.cursor()
            pg_cursor.execute("SELECT id, tabla_afectada, accion, datos FROM cola_replicacion ORDER BY id ASC LIMIT 1")
            registro_pg = pg_cursor.fetchone()
            
            if registro_pg:
                id_cola, tabla, accion, datos = registro_pg
                datos_json = json.loads(datos) if isinstance(datos, str) else datos
                
                try:
                    if tabla in ('categoria', 'estantes'):
                        ejecutar_en_destino(my_conn, tabla, accion, datos_json)
                    elif tabla == 'repisas':
                        ejecutar_en_destino(sql_conn, tabla, accion, datos_json)
                        
                    pg_cursor.execute("DELETE FROM cola_replicacion WHERE id = %s", (id_cola,))
                    pg_conn.commit()
                except Exception as e:
                    print(f"[Aviso Postgres Destino] Error: {e}")
                    my_conn.rollback()
                    if "Duplicate entry" in str(e) or "already exists" in str(e):
                        pg_cursor.execute("DELETE FROM cola_replicacion WHERE id = %s", (id_cola,))
                        pg_conn.commit()
            pg_cursor.close()

            # --- REVISAR COLA DE MYSQL ---
            my_cursor = my_conn.cursor()
            my_cursor.execute("SELECT id, tabla_afectada, accion, datos FROM cola_replicacion ORDER BY id ASC LIMIT 1")
            registro_my = my_cursor.fetchone()
            
            if registro_my:
                id_cola, tabla, accion, datos = registro_my
                print(f"[Rastreo] Procesando ID {id_cola} - Tabla: {tabla} - Accion: {accion}")
                datos_json = json.loads(datos) if isinstance(datos, str) else datos
                
                try:
                    if tabla == 'estantes':
                        ejecutar_en_destino(pg_conn, tabla, accion, datos_json)
                    elif tabla == 'tema':
                        ejecutar_en_destino(sql_conn, tabla, accion, datos_json)
                        
                    my_cursor.execute("DELETE FROM cola_replicacion WHERE id = %s", (id_cola,))
                    my_conn.commit()
                    print(f"[Rastreo] ¡Éxito al replicar ID {id_cola}!")
                except Exception as e:
                    print(f"[Aviso MySQL Destino] Error detallado: {e}")
                    pg_conn.rollback()
                    sql_conn.rollback()
                    if "duplicate key" in str(e) or "Duplicate entry" in str(e) or "already exists" in str(e):
                        my_cursor.execute("DELETE FROM cola_replicacion WHERE id = %s", (id_cola,))
                        my_conn.commit()
            my_cursor.close()

            # --- REVISAR COLA DE SQL SERVER ---
            sql_cursor = sql_conn.cursor()
            sql_cursor.execute("SELECT TOP 1 id, tabla_afectada, accion, datos FROM cola_replicacion ORDER BY id ASC")
            registro_sql = sql_cursor.fetchone()
            
            if registro_sql:
                id_cola, tabla, accion, datos = registro_sql
                datos_json = json.loads(datos) if isinstance(datos, str) else datos
                
                try:
                    if tabla == 'repisas':
                        ejecutar_en_destino(pg_conn, tabla, accion, datos_json)
                    elif tabla == 'tema':
                        ejecutar_en_destino(my_conn, tabla, accion, datos_json)
                        
                    sql_cursor.execute("DELETE FROM cola_replicacion WHERE id = ?", (id_cola,))
                    sql_conn.commit()
                except Exception as e:
                    print(f"[Aviso SQLServer Destino] Error: {e}")
                    sql_conn.rollback()
                    if "duplicate key" in str(e) or "Violation of PRIMARY KEY" in str(e) or "identity column" in str(e):
                        sql_cursor.execute("DELETE FROM cola_replicacion WHERE id = ?", (id_cola,))
                        sql_conn.commit()
            sql_cursor.close()

        except Exception as e:
            print(f"Error general procesando cola: {e}")
            try: pg_conn.rollback()
            except: pass
            try: my_conn.rollback()
            except: pass
            try: sql_conn.rollback()
            except: pass
            time.sleep(2)
            
        time.sleep(0.5)

if __name__ == "__main__":
    orquestar_replicacion()