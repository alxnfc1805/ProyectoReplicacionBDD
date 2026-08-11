"""
tablas_meta.py
Metadatos que describen, para cada tabla:
  - qué columnas tiene y cómo mostrarlas en el formulario dinámico
  - en qué nodo(s) vive
  - si es un fragmento (y qué valor fijo le corresponde en ese nodo)
  - qué tipo de replicación aplica y entre qué nodos

Esta es la única fuente de verdad que usa gui.py para construir el
formulario, habilitar/deshabilitar el selector de replicación, y armar la
etiqueta de resumen. Si el día de mañana cambian criterios de
fragmentación o de replicación, se edita SOLO este archivo.
"""

TABLAS_POR_NODO = {
    "nodo1": ["estantes", "repisas", "categoria", "usuarios", "prestamos"],
    "nodo2": ["categoria", "estantes", "tema", "usuarios", "prestamos"],
    "nodo3": ["repisas", "tema", "prestamos"],
}

TABLA_DEF = {
    "estantes": {
        "pk": "id_estante",
        "columnas": [
            {"nombre": "id_estante", "etiqueta": "ID", "tipo": "int", "pk": True, "en_formulario": False},
            {"nombre": "codigo_estante", "etiqueta": "Código", "tipo": "str", "en_formulario": True, "requerido": True},
            {"nombre": "pasillo", "etiqueta": "Pasillo", "tipo": "str", "en_formulario": True},
            {"nombre": "capacidad_maxima", "etiqueta": "Capacidad máxima", "tipo": "int", "en_formulario": True, "requerido": True},
            {"nombre": "fecha_hora_creacion", "etiqueta": "Creado", "tipo": "str", "en_formulario": False},
            {"nombre": "fecha_hora_actualizacion", "etiqueta": "Actualizado", "tipo": "str", "en_formulario": False},
        ],
        "fragmento_por_nodo": None,
        "replicacion": {"tipo": "bidireccional", "par": ("nodo1", "nodo2")},
    },
    "repisas": {
        "pk": "id_repisa",
        "columnas": [
            {"nombre": "id_repisa", "etiqueta": "ID", "tipo": "int", "pk": True, "en_formulario": False},
            {"nombre": "nombre_nivel", "etiqueta": "Nivel", "tipo": "str", "en_formulario": True, "requerido": True,
             "opciones": ["Baja", "Media", "Alta", "Superior"]},
            {"nombre": "altura_cm", "etiqueta": "Altura (cm)", "tipo": "float", "en_formulario": True},
            {"nombre": "fecha_hora_creacion", "etiqueta": "Creado", "tipo": "str", "en_formulario": False},
            {"nombre": "fecha_hora_actualizacion", "etiqueta": "Actualizado", "tipo": "str", "en_formulario": False},
        ],
        "fragmento_por_nodo": None,
        "replicacion": {"tipo": "bidireccional", "par": ("nodo1", "nodo3")},
    },
    "categoria": {
        "pk": "id_categoria",
        "columnas": [
            {"nombre": "id_categoria", "etiqueta": "ID", "tipo": "int", "pk": True, "en_formulario": False},
            {"nombre": "nombre_categoria", "etiqueta": "Nombre", "tipo": "str", "en_formulario": True, "requerido": True},
            {"nombre": "descripcion", "etiqueta": "Descripción", "tipo": "str", "en_formulario": True},
            {"nombre": "fecha_hora_creacion", "etiqueta": "Creado", "tipo": "str", "en_formulario": False},
            {"nombre": "fecha_hora_actualizacion", "etiqueta": "Actualizado", "tipo": "str", "en_formulario": False},
        ],
        "fragmento_por_nodo": None,
        "replicacion": {"tipo": "unidireccional", "origen": "nodo1", "destino": "nodo2"},
    },
    "tema": {
        "pk": "id_tema",
        "columnas": [
            {"nombre": "id_tema", "etiqueta": "ID", "tipo": "int", "pk": True, "en_formulario": False},
            {"nombre": "titulo", "etiqueta": "Título", "tipo": "str", "en_formulario": True, "requerido": True},
            {"nombre": "autor", "etiqueta": "Autor", "tipo": "str", "en_formulario": True},
            {"nombre": "isbn", "etiqueta": "ISBN", "tipo": "str", "en_formulario": True},
            {"nombre": "anio_publicacion", "etiqueta": "Año", "tipo": "int", "en_formulario": True},
            {"nombre": "id_categoria_ref", "etiqueta": "ID Categoría (Nodo 1)", "tipo": "int", "en_formulario": True, "requerido": True},
            {"nombre": "id_estante_ref", "etiqueta": "ID Estante (Nodo 1)", "tipo": "int", "en_formulario": True, "requerido": True},
            {"nombre": "id_repisa_ref", "etiqueta": "ID Repisa (Nodo 1)", "tipo": "int", "en_formulario": True, "requerido": True},
            {"nombre": "disponible", "etiqueta": "Disponible", "tipo": "bool", "en_formulario": True},
            {"nombre": "fecha_hora_creacion", "etiqueta": "Creado", "tipo": "str", "en_formulario": False},
            {"nombre": "fecha_hora_actualizacion", "etiqueta": "Actualizado", "tipo": "str", "en_formulario": False},
        ],
        "fragmento_por_nodo": None,
        "replicacion": {"tipo": "bidireccional", "par": ("nodo2", "nodo3")},
    },
    "usuarios": {
        "pk": "id_usuario",
        "columnas": [
            {"nombre": "id_usuario", "etiqueta": "ID", "tipo": "int", "pk": True, "en_formulario": False},
            {"nombre": "cedula", "etiqueta": "Cédula", "tipo": "str", "en_formulario": True, "requerido": True},
            {"nombre": "nombres", "etiqueta": "Nombres", "tipo": "str", "en_formulario": True, "requerido": True},
            {"nombre": "apellidos", "etiqueta": "Apellidos", "tipo": "str", "en_formulario": True, "requerido": True},
            {"nombre": "correo_institucional", "etiqueta": "Correo", "tipo": "str", "en_formulario": True},
            {"nombre": "tipo_usuario", "etiqueta": "Tipo", "tipo": "str", "en_formulario": True,
             "opciones": ["Estudiante", "Docente"]},
            {"nombre": "fecha_hora_creacion", "etiqueta": "Creado", "tipo": "str", "en_formulario": False},
            {"nombre": "fecha_hora_actualizacion", "etiqueta": "Actualizado", "tipo": "str", "en_formulario": False},
        ],
        "fragmento_por_nodo": {
            "nodo1": {"columna": "tipo_usuario", "valor": "Estudiante"},
            "nodo2": {"columna": "tipo_usuario", "valor": "Docente"},
        },
        "replicacion": None,
    },
    "prestamos": {
        "pk": "id_prestamo",
        "columnas": [
            {"nombre": "id_prestamo", "etiqueta": "ID", "tipo": "int", "pk": True, "en_formulario": False},
            {"nombre": "id_tema_ref", "etiqueta": "ID Tema (Nodo 2/3)", "tipo": "int", "en_formulario": True, "requerido": True},
            {"nombre": "id_usuario_ref", "etiqueta": "ID Usuario (Nodo 1/2)", "tipo": "int", "en_formulario": True, "requerido": True},
            {"nombre": "fecha_prestamo", "etiqueta": "Fecha préstamo (AAAA-MM-DD)", "tipo": "fecha", "en_formulario": True, "requerido": True},
            {"nombre": "fecha_devolucion_esperada", "etiqueta": "Devolución esperada (AAAA-MM-DD)", "tipo": "fecha", "en_formulario": True, "requerido": True},
            {"nombre": "fecha_devolucion_real", "etiqueta": "Devolución real (AAAA-MM-DD, opcional)", "tipo": "fecha", "en_formulario": True},
            {"nombre": "estado_prestamo", "etiqueta": "Estado", "tipo": "str", "en_formulario": True,
             "opciones": ["Activo", "Devuelto", "Atrasado"]},
            {"nombre": "fecha_hora_creacion", "etiqueta": "Creado", "tipo": "str", "en_formulario": False},
            {"nombre": "fecha_hora_actualizacion", "etiqueta": "Actualizado", "tipo": "str", "en_formulario": False},
        ],
        "fragmento_por_nodo": {
            "nodo1": {"columna": "estado_prestamo", "valor": "Activo"},
            "nodo2": {"columna": "estado_prestamo", "valor": "Devuelto"},
            "nodo3": {"columna": "estado_prestamo", "valor": "Atrasado"},
        },
        "replicacion": None,
    },
}


def opciones_replicacion(tabla, nodo_clave):
    """
    Devuelve la lista de tipos de replicación seleccionables en la GUI
    para esa combinación tabla+nodo, coherente con la matriz de la fase
    de replicación lógica.
    """
    info = TABLA_DEF[tabla].get("replicacion")
    if info is None:
        return ["Ninguna"]

    if info["tipo"] == "unidireccional":
        if nodo_clave == info["origen"]:
            return ["Ninguna", "Unidireccional"]
        return ["Ninguna"]

    if info["tipo"] == "bidireccional":
        if nodo_clave in info["par"]:
            return ["Ninguna", "Bidireccional"]
        return ["Ninguna"]

    return ["Ninguna"]


def nodos_replicacion_para(tabla, nodo_clave):
    """
    Devuelve una lista de tuplas (origen, destino) que hay que disparar
    cuando se escribe en esta tabla desde este nodo. Se cruza contra
    replicator/config_replicacion.py:FLUJOS (mismos campos
    tabla/origen/destino) para encontrar el flujo exacto a ejecutar.
    """
    info = TABLA_DEF[tabla].get("replicacion")
    if info is None:
        return []

    if info["tipo"] == "unidireccional":
        if nodo_clave == info["origen"]:
            return [(info["origen"], info["destino"])]
        return []

    if info["tipo"] == "bidireccional":
        a, b = info["par"]
        if nodo_clave == a:
            return [(a, b)]
        if nodo_clave == b:
            return [(b, a)]
        return []

    return []
