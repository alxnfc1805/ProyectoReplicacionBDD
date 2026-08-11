# Conexión entre PostgreSQL, MySQL y SQL Server + Interfaz de Conexión

Este paquete cubre **solo** la parte de conexión/infraestructura y la interfaz
gráfica base, tal como se pidió. No incluye tablas, datos, réplicas ni CRUD
todavía: eso se construye después sobre `config.py` y `db_connections.py`,
que ya quedan listos para reutilizarse.

## 1. Estructura

```
proyecto_bdd/
├── config.py                # IPs/puertos/credenciales de los 3 nodos
├── db_connections.py         # Lógica real de conexión a cada motor
├── gui.py                    # Interfaz gráfica (Tkinter)
├── requirements.txt
└── docker/
    ├── docker-compose.local.yml       # los 3 motores en 1 sola máquina (pruebas)
    ├── node1_postgres/docker-compose.yml   # solo Postgres -> laptop Nodo 1
    ├── node2_mysql/docker-compose.yml      # solo MySQL    -> laptop Nodo 2
    └── node3_sqlserver/docker-compose.yml  # solo SQL Srv  -> laptop Nodo 3
```

## 2. Opción A — Probar todo en una sola laptop (recomendado primero)

```bash
cd docker
docker compose -f docker-compose.local.yml up -d
docker compose -f docker-compose.local.yml ps   # verificar que los 3 estén "healthy"/running
```

En `config.py` deja `MODO = "local"`. Instala dependencias y corre la interfaz:

```bash
pip install -r requirements.txt
python gui.py
```

Debe mostrar los 3 nodos en verde ("Conectado"). SQL Server tarda ~15-20
segundos en arrancar la primera vez; si sale rojo, espera y pulsa
"Probar los 3 nodos" de nuevo.

## 3. Opción B — Despliegue real en las 3 laptops físicas

### 3.1. Configurar IP fija en cada laptop (a nivel de sistema operativo)

| Nodo | IP fija | Motor |
|---|---|---|
| Nodo 1 | 192.168.10.1 | PostgreSQL |
| Nodo 2 | 192.168.10.2 | MySQL |
| Nodo 3 | 192.168.10.3 | SQL Server |

En Windows: Panel de Control → Redes → Propiedades del adaptador → IPv4 →
Usar la siguiente dirección IP.
En Linux: `nmcli` o editando la configuración de red de tu distro.
La conexión física (cable, switch, hotspot, red ad-hoc) es libre, según el
proyecto.

### 3.2. Levantar el contenedor correspondiente en cada laptop

En la laptop del **Nodo 1**:
```bash
cd docker/node1_postgres
docker compose up -d
```

En la laptop del **Nodo 2**:
```bash
cd docker/node2_mysql
docker compose up -d
```

En la laptop del **Nodo 3**:
```bash
cd docker/node3_sqlserver
docker compose up -d
```

Cada contenedor publica su puerto en `0.0.0.0`, es decir, en la IP física
de esa laptop (192.168.10.x), no solo en localhost — así lo exige el
enunciado.

### 3.3. Abrir el puerto en el firewall del sistema operativo de cada laptop

**Linux (ufw):**
```bash
sudo ufw allow 5432/tcp   # solo en la laptop del Nodo 1
sudo ufw allow 3306/tcp   # solo en la laptop del Nodo 2
sudo ufw allow 1433/tcp   # solo en la laptop del Nodo 3
```

**Windows (PowerShell como administrador):**
```powershell
netsh advfirewall firewall add rule name="PostgreSQL" dir=in action=allow protocol=TCP localport=5432
netsh advfirewall firewall add rule name="MySQL"      dir=in action=allow protocol=TCP localport=3306
netsh advfirewall firewall add rule name="SQLServer"  dir=in action=allow protocol=TCP localport=1433
```
(Ejecuta solo la regla correspondiente al motor de esa laptop.)

### 3.4. Verificar conectividad cruzada ANTES de abrir la interfaz

Desde cualquier laptop, hacia las otras dos:
```bash
ping 192.168.10.1
telnet 192.168.10.1 5432        # o: Test-NetConnection 192.168.10.1 -Port 5432 en Windows

Test-NetConnection 192.168.10.1 -Port 5432 
Test-NetConnection 192.168.10.2 -Port 3306
Test-NetConnection 192.168.10.3 -Port 1433
```

### 3.5. Cambiar a modo producción y correr la interfaz

En `config.py`:
```python
MODO = "produccion"
```

Instala dependencias y corre `gui.py` desde cualquiera de las laptops (o desde
una cuarta máquina de control conectada a la misma red):
```bash
pip install -r requirements.txt
python gui.py
```

## 4. Requisitos de la máquina que ejecuta `gui.py`

- Python 3.10+
- `pip install -r requirements.txt`
- Para SQL Server: tener instalado el **ODBC Driver 17 o 18 for SQL Server**
  (driver de Microsoft, se instala aparte del paquete `pyodbc`).
  - Windows: normalmente ya viene o se instala con un instalador MSI de Microsoft.
  - Linux: `msodbcsql18` vía el repositorio de Microsoft para tu distro.

## 5. Qué hace la interfaz por ahora

- Selector visual de los 3 nodos, mostrando motor e IP:puerto.
- Botón "Probar conexión" por nodo y botón global "Probar los 3 nodos".
- Verifica primero si el puerto TCP está abierto (detecta problemas de red/
  firewall) y luego intenta un login real contra el motor (detecta problemas
  de usuario/contraseña).
- Semáforo verde/rojo por nodo y log de eventos con marca de tiempo.

Esto es la base de conectividad sobre la que después se construyen: selector
de tabla, CRUD, formulario dinámico, grid de resultados, selector de
replicación y etiqueta de resumen (sección 6 del enunciado).
