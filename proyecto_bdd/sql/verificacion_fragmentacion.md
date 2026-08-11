# Verificación global de la fragmentación horizontal

Como los 3 nodos son motores heterogéneos, no existe una sola sentencia SQL
que los una automáticamente (eso requeriría un mecanismo adicional tipo
`postgres_fdw` / linked server / `mysql_fdw`, fuera del alcance de esta
fase). La reconstrucción se demuestra ejecutando el conteo en cada nodo por
separado y sumando manualmente — es justo el punto 7 del protocolo de
demostración ("Evidencia de fragmentación horizontal").

## Tabla `prestamos` (debe sumar 200 en total)

| Nodo | Motor | Query | Resultado esperado |
|---|---|---|---|
| Nodo 1 | PostgreSQL | `SELECT COUNT(*) FROM prestamos;` | 80 (solo Activo) |
| Nodo 2 | MySQL | `SELECT COUNT(*) FROM prestamos;` | 80 (solo Devuelto) |
| Nodo 3 | SQL Server | `SELECT COUNT(*) FROM prestamos;` | 40 (solo Atrasado) |
| **Suma** | | | **200** ✔ coincide con la carga inicial |

Adicional — en cada nodo correr también:
```sql
SELECT DISTINCT estado_prestamo FROM prestamos;
```
Debe devolver **una sola fila** en cada nodo (Activo / Devuelto / Atrasado
respectivamente). Si devuelve más de un valor distinto, la fragmentación
está rota en ese nodo.

## Tabla `usuarios` (debe sumar 40 en total)

| Nodo | Motor | Query | Resultado esperado |
|---|---|---|---|
| Nodo 1 | PostgreSQL | `SELECT COUNT(*) FROM usuarios;` | 30 (solo Estudiante) |
| Nodo 2 | MySQL | `SELECT COUNT(*) FROM usuarios;` | 10 (solo Docente) |
| **Suma** | | | **40** ✔ coincide con la carga inicial |

```sql
SELECT DISTINCT tipo_usuario FROM usuarios;
```
Una sola fila por nodo (Estudiante / Docente respectivamente).

## Qué mostrar en la demo (protocolo, sección 7, ~30 seg)

1. Conectarse con la herramienta nativa de cada motor (psql / mysql client /
   SSMS-sqlcmd).
2. Ejecutar el `SELECT COUNT(*)` y el `SELECT DISTINCT` de la tabla
   correspondiente en cada uno de los 3 nodos.
3. Sumar en voz alta los 3 conteos de `prestamos` (80+80+40=200) y los 2 de
   `usuarios` (30+10=40), mostrando que coincide con el total cargado
   inicialmente y que ningún nodo tiene un valor de estado/tipo que no le
   corresponde.

## Nota sobre la interfaz gráfica

Aunque el `CHECK` de cada motor ya bloquea físicamente cualquier fila que no
pertenezca al fragmento, conviene que la GUI (`gui.py`) también filtre en el
formulario — por ejemplo, si el usuario selecciona "Nodo 3" y tabla
`prestamos`, el campo `estado_prestamo` del formulario debería fijarse o
limitarse a `'Atrasado'` en vez de dejarlo libre. Así se evita mostrarle al
usuario un error de base de datos por un dato que la propia interfaz debió
prevenir — el `CHECK` queda como la última línea de defensa, no la primera.
