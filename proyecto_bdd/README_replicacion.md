# Replicación lógica heterogénea — PostgreSQL / MySQL / SQL Server

## Por qué NO se usó publicación/suscripción nativa de PostgreSQL

La replicación lógica nativa de PostgreSQL (`CREATE PUBLICATION` / `CREATE
SUBSCRIPTION`) solo funciona **entre dos bases PostgreSQL**. En este
proyecto los 3 pares de nodos son heterogéneos:

- PostgreSQL ↔ MySQL
- PostgreSQL ↔ SQL Server
- MySQL ↔ SQL Server

No hay ningún par Postgres-Postgres, así que la publicación/suscripción
nativa no aplica a ningún flujo. Lo mismo pasa con MySQL (su replicación
nativa vía binlog solo sirve entre MySQL) y con SQL Server (Transactional
Replication/CDC nativo son para SQL Server-a-SQL Server).

## La solución: patrón Outbox + Trigger + Puente

Esto sigue siendo **replicación lógica** en el sentido que exige el
proyecto (excluye a: streaming replication a nivel de WAL, Data Guard
físico, Always On a nivel de bloque): se está capturando el **cambio a
nivel de fila** (INSERT/UPDATE de una tupla concreta), no un flujo binario
de páginas de disco.

```
 Nodo origen                                    Nodo destino
┌──────────────┐   trigger AFTER INSERT/UPDATE  ┌──────────────┐
│ tabla         │ ─────────────────────────────▶│ outbox_tabla │
│ (categoria,   │        (guarda el cambio       │ (pendiente)  │
│  estantes,    │         en JSON)               └──────┬───────┘
│  repisas,     │                                       │ cada 3s,
│  tema)        │                                       │ replicador.py
└──────────────┘                                       ▼ lee y aplica
                                                  ┌──────────────┐
                                                  │ tabla espejo  │
                                                  │ en el otro    │
                                                  │ nodo (upsert) │
                                                  └──────────────┘
```

## Prevención de bucles infinitos (clave en los pares bidireccionales)

Sin protección, un cambio en Nodo A se replicaría a Nodo B; el trigger de
Nodo B lo volvería a encolar; se replicaría de vuelta a Nodo A; y así para
siempre. La solución: un usuario técnico `replica_bot`, usado
**exclusivamente** por `replicador.py` para escribir en los destinos. Cada
trigger revisa quién está haciendo el cambio:

- PostgreSQL: `IF current_user = 'replica_bot' THEN RETURN NEW;`
- MySQL: `IF CURRENT_USER() NOT LIKE 'replica_bot@%' THEN ... END IF;`
- SQL Server: `IF SUSER_SNAME() = 'replica_bot' RETURN;`

Si el cambio lo hizo `replica_bot`, el trigger no genera un nuevo evento de
outbox — ahí se corta el ciclo.

## Prevención de choque de IDs

En un par bidireccional, ambos nodos pueden recibir un INSERT nuevo desde
su propia GUI. Si los dos generaran ids empezando en 1, tarde o temprano
chocarían. Por eso, en las tablas espejo (el lado que NO es el catálogo
original), el auto-incremento/identity arranca en 1000:

| Tabla | Nodo "dueño" original (ids bajos) | Nodo espejo (ids desde 1000) |
|---|---|---|
| estantes | Nodo 1 (1-20) | Nodo 2 |
| repisas | Nodo 1 (1-4) | Nodo 3 |
| tema | Nodo 2 (1-100) | Nodo 3 |

## Orden de ejecución completo

1. Ya hecho en fases anteriores: `01_create_database.sql`, `02_create_tables.sql`,
   `03_carga_inicial.sql`, `04_fragmentacion.sql` en cada nodo.
2. Ejecutar `05_replicacion_estructuras.sql` en **los 3 nodos** (crea el
   usuario `replica_bot`, las tablas espejo, las tablas outbox y los triggers).
3. Desde la máquina que hará de "puente" (puede ser cualquiera de las 3
   laptops, o una cuarta de control, mientras tenga red hacia las 3 IPs):
   ```bash
   cd replicator
   pip install -r ../requirements.txt
   python3 sincronizacion_inicial.py
   ```
   Esto copia, una sola vez, categoria/estantes/repisas/tema hacia sus
   tablas espejo recién creadas (que están vacías).
4. Iniciar el replicador continuo:
   ```bash
   python3 replicador.py
   ```
   Déjalo corriendo en una terminal durante toda la demo — es el proceso
   que hace que los cambios viajen entre nodos en segundo plano.

## Cómo probar cada flujo en la demo

```bash
python3 replicador.py --listar        # ver los 7 flujos con su índice
python3 replicador.py --flujo 0 --once   # forzar una sola pasada del flujo 0
```

Protocolo sugerido (igual al de la sección 7 del proyecto):
1. Mostrar el estado ANTES en ambos nodos del par (herramienta nativa).
2. Hacer un INSERT/UPDATE real en el nodo origen desde tu GUI (`gui.py`,
   cuando tenga el CRUD completo) o directo por script de prueba.
3. Esperar máximo `INTERVALO_POLLING_SEGUNDOS` (3 segundos) — o correr
   `--flujo N --once` para no esperar.
4. Mostrar el estado DESPUÉS en el nodo destino, con herramienta nativa,
   confirmando que el cambio llegó.

## Latencia de la replicación

Al ser por "polling" (consulta periódica) y no por escucha en tiempo real
del WAL/binlog, hay un retraso máximo de `INTERVALO_POLLING_SEGUNDOS` (3
segundos por defecto, configurable en `config_replicacion.py`) entre que
se hace el cambio y que se aplica en el otro nodo. Es una diferencia
importante frente a la replicación nativa (que es prácticamente
instantánea) y conviene mencionarla en el informe como limitación conocida
del diseño, junto con su justificación: es la alternativa más simple y
portable para sincronizar 3 motores distintos sin herramientas de pago
(GoldenGate) ni infraestructura adicional (Kafka + Debezium).
