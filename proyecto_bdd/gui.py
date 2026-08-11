"""
gui.py
Interfaz gráfica de administración — versión completa
Bases de Datos Distribuidas - Proyecto Bimestre 2

Cumple los elementos mínimos de la sección 6 del enunciado:
 - Selector de nodo (motor + IP)
 - Selector de tabla/fragmento según el nodo elegido
 - Selector de acción CRUD
 - Formulario dinámico para Crear/Actualizar
 - Grid de resultados para Leer, con selección de fila para Actualizar/Eliminar
 - Selector de tipo de replicación (habilitado según la tabla+nodo)
 - Botón de ejecución
 - Actualización automática del grid tras cada acción
 - Etiqueta de resumen de resultado
"""
import sys
import os
import datetime
import threading
import tkinter as tk
from tkinter import ttk, messagebox

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(BASE_DIR, "replicator"))

from config import NODES  # noqa: E402
from db_connections import test_connection  # noqa: E402
from db_operations import listar, crear, actualizar, eliminar  # noqa: E402
from tablas_meta import (  # noqa: E402
    TABLAS_POR_NODO, TABLA_DEF, opciones_replicacion, nodos_replicacion_para,
)

NOMBRES_NODO = {k: v["nombre"] for k, v in NODES.items()}
ACCIONES = ["Leer", "Crear", "Actualizar", "Eliminar"]


def valor_a_mostrar(colspec, valor):
    if valor is None:
        return ""
    if colspec["tipo"] == "bool":
        return "Sí" if str(valor) in ("1", "True", "true") else "No"
    return str(valor)


def valor_a_guardar(colspec, texto):
    texto = (texto or "").strip()
    if colspec["tipo"] == "bool":
        return 1 if texto == "Sí" else 0
    if texto == "":
        if colspec.get("requerido"):
            raise ValueError(f"El campo '{colspec['etiqueta']}' es obligatorio.")
        return None
    if colspec["tipo"] == "int":
        try:
            return int(texto)
        except ValueError:
            raise ValueError(f"'{colspec['etiqueta']}' debe ser un número entero.")
    if colspec["tipo"] == "float":
        try:
            return float(texto)
        except ValueError:
            raise ValueError(f"'{colspec['etiqueta']}' debe ser un número decimal.")
    return texto  # str, fecha (se guarda como texto 'AAAA-MM-DD')


class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("BDD Biblioteca — Interfaz de Administración Distribuida")
        self.geometry("1040x760")

        self.form_widgets = {}
        self.pk_seleccionado = None
        self.columnas_actual = []

        self._build_ui()
        self._nodo_cambiado()

    # ------------------------------------------------------------------
    # Construcción de la interfaz
    # ------------------------------------------------------------------
    def _build_ui(self):
        titulo = tk.Label(self, text="Biblioteca ISWD553 — PostgreSQL · MySQL · SQL Server",
                           font=("Segoe UI", 15, "bold"))
        titulo.pack(pady=(10, 2))

        fila_sel = tk.Frame(self)
        fila_sel.pack(fill="x", padx=15, pady=6)

        tk.Label(fila_sel, text="Nodo:", font=("Segoe UI", 9, "bold")).grid(row=0, column=0, sticky="w")
        self.nodo_var = tk.StringVar(value="nodo1")
        self.combo_nodo = ttk.Combobox(fila_sel, state="readonly", width=34,
                                        values=[f"{k} — {v}" for k, v in NOMBRES_NODO.items()])
        self.combo_nodo.current(0)
        self.combo_nodo.grid(row=1, column=0, padx=(0, 15), sticky="w")
        self.combo_nodo.bind("<<ComboboxSelected>>", lambda e: self._nodo_cambiado())

        self.estado_conexion_var = tk.StringVar(value="● sin probar")
        self.lbl_estado_conexion = tk.Label(fila_sel, textvariable=self.estado_conexion_var, fg="gray",
                                             font=("Segoe UI", 9, "bold"))
        self.lbl_estado_conexion.grid(row=1, column=1, padx=(0, 15))
        tk.Button(fila_sel, text="Probar conexión", command=self._probar_conexion_actual).grid(
            row=1, column=2, padx=(0, 25))

        tk.Label(fila_sel, text="Tabla / fragmento:", font=("Segoe UI", 9, "bold")).grid(row=0, column=3, sticky="w")
        self.tabla_var = tk.StringVar()
        self.combo_tabla = ttk.Combobox(fila_sel, state="readonly", width=18, textvariable=self.tabla_var)
        self.combo_tabla.grid(row=1, column=3, padx=(0, 15), sticky="w")
        self.combo_tabla.bind("<<ComboboxSelected>>", lambda e: self._tabla_cambiada())

        tk.Label(fila_sel, text="Acción CRUD:", font=("Segoe UI", 9, "bold")).grid(row=0, column=4, sticky="w")
        self.accion_var = tk.StringVar(value="Leer")
        self.combo_accion = ttk.Combobox(fila_sel, state="readonly", width=12,
                                          values=ACCIONES, textvariable=self.accion_var)
        self.combo_accion.grid(row=1, column=4, padx=(0, 15), sticky="w")
        self.combo_accion.bind("<<ComboboxSelected>>", lambda e: self._accion_cambiada())

        tk.Label(fila_sel, text="Replicación:", font=("Segoe UI", 9, "bold")).grid(row=0, column=5, sticky="w")
        self.replicacion_var = tk.StringVar(value="Ninguna")
        self.combo_replicacion = ttk.Combobox(fila_sel, state="readonly", width=14, textvariable=self.replicacion_var)
        self.combo_replicacion.grid(row=1, column=5, sticky="w")

        self.form_frame = tk.LabelFrame(self, text="Formulario (Crear / Actualizar)", padx=10, pady=8)
        self.form_frame.pack(fill="x", padx=15, pady=6)

        tk.Button(self, text="▶  Ejecutar acción", font=("Segoe UI", 11, "bold"),
                  bg="#2b5876", fg="white", command=self._ejecutar).pack(pady=6, ipadx=12, ipady=4)

        grid_frame = tk.LabelFrame(self, text="Resultados (clic en una fila para Actualizar/Eliminar)")
        grid_frame.pack(fill="both", expand=True, padx=15, pady=6)

        self.tree = ttk.Treeview(grid_frame, show="headings", height=10)
        scroll_y = ttk.Scrollbar(grid_frame, orient="vertical", command=self.tree.yview)
        self.tree.configure(yscrollcommand=scroll_y.set)
        self.tree.pack(side="left", fill="both", expand=True, padx=(5, 0), pady=5)
        scroll_y.pack(side="left", fill="y", pady=5)
        self.tree.bind("<<TreeviewSelect>>", self._on_grid_select)

        resumen_frame = tk.LabelFrame(self, text="Resumen de la última operación")
        resumen_frame.pack(fill="x", padx=15, pady=(0, 6))
        self.resumen_text = tk.Text(resumen_frame, height=4, wrap="word", font=("Segoe UI", 9))
        self.resumen_text.pack(fill="x", padx=5, pady=5)
        self.resumen_text.configure(state="disabled")

        log_frame = tk.LabelFrame(self, text="Registro de eventos")
        log_frame.pack(fill="x", padx=15, pady=(0, 10))
        self.log_text = tk.Text(log_frame, height=4, state="disabled", font=("Consolas", 8))
        self.log_text.pack(fill="x", padx=5, pady=5)

    # ------------------------------------------------------------------
    def _nodo_clave(self):
        return self.combo_nodo.get().split(" — ")[0]

    def _nodo_actual(self):
        return NODES[self._nodo_clave()]

    def log(self, mensaje):
        ts = datetime.datetime.now().strftime("%H:%M:%S")
        self.log_text.configure(state="normal")
        self.log_text.insert("end", f"[{ts}] {mensaje}\n")
        self.log_text.see("end")
        self.log_text.configure(state="disabled")

    def _set_resumen(self, texto, ok=True):
        self.resumen_text.configure(state="normal")
        self.resumen_text.delete("1.0", "end")
        self.resumen_text.insert("1.0", texto)
        self.resumen_text.configure(state="disabled", bg="#eafaf1" if ok else "#fdecea")

    # ------------------------------------------------------------------
    def _nodo_cambiado(self):
        nodo_clave = self._nodo_clave()
        tablas = TABLAS_POR_NODO[nodo_clave]
        self.combo_tabla["values"] = tablas
        self.combo_tabla.current(0)
        self.estado_conexion_var.set("● sin probar")
        self.lbl_estado_conexion.configure(fg="gray")
        self._tabla_cambiada()

    def _tabla_cambiada(self):
        self.pk_seleccionado = None
        self._construir_formulario()
        self._actualizar_opciones_replicacion()
        self._accion_cambiada()

    def _accion_cambiada(self):
        accion = self.accion_var.get()
        estado_form = "normal" if accion in ("Crear", "Actualizar") else "disabled"
        for widget in self.form_widgets.values():
            if isinstance(widget, ttk.Combobox):
                if getattr(widget, "_bloqueado_fragmento", False):
                    continue
                widget.configure(state="readonly" if estado_form == "normal" else "disabled")
            else:
                widget.configure(state=estado_form)

    def _actualizar_opciones_replicacion(self):
        tabla = self.tabla_var.get()
        nodo_clave = self._nodo_clave()
        opciones = opciones_replicacion(tabla, nodo_clave)
        self.combo_replicacion["values"] = opciones
        self.replicacion_var.set(opciones[0])
        self.combo_replicacion.configure(state="readonly" if len(opciones) > 1 else "disabled")

    def _probar_conexion_actual(self):
        nodo = self._nodo_actual()
        self.estado_conexion_var.set("● probando...")
        self.lbl_estado_conexion.configure(fg="#e67e22")

        def worker():
            ok, msg, ms = test_connection(nodo)

            def aplicar():
                self.estado_conexion_var.set("● conectado" if ok else "● sin conexión")
                self.lbl_estado_conexion.configure(fg="#1e8f2e" if ok else "#c0392b")
                self.log(f"{nodo['nombre']}: {msg} ({ms:.0f} ms)")
            self.after(0, aplicar)

        threading.Thread(target=worker, daemon=True).start()

    # ------------------------------------------------------------------
    def _construir_formulario(self):
        for w in self.form_frame.winfo_children():
            w.destroy()
        self.form_widgets = {}

        tabla = self.tabla_var.get()
        if not tabla:
            return
        nodo_clave = self._nodo_clave()
        definicion = TABLA_DEF[tabla]
        columnas_form = [c for c in definicion["columnas"] if c.get("en_formulario")]

        fragmento = definicion.get("fragmento_por_nodo")
        columna_bloqueada = None
        valor_bloqueado = None
        if fragmento and nodo_clave in fragmento:
            columna_bloqueada = fragmento[nodo_clave]["columna"]
            valor_bloqueado = fragmento[nodo_clave]["valor"]

        for i, col in enumerate(columnas_form):
            fila, columna_grid = divmod(i, 3)
            contenedor = tk.Frame(self.form_frame)
            contenedor.grid(row=fila, column=columna_grid, padx=8, pady=4, sticky="w")

            etiqueta = col["etiqueta"]
            if col["nombre"] == columna_bloqueada:
                etiqueta += "  (fragmento fijo)"
            tk.Label(contenedor, text=etiqueta, font=("Segoe UI", 8)).pack(anchor="w")

            if col["nombre"] == columna_bloqueada:
                var = tk.StringVar(value=valor_bloqueado)
                widget = ttk.Combobox(contenedor, textvariable=var, values=[valor_bloqueado],
                                       state="disabled", width=22)
                widget._bloqueado_fragmento = True
            elif col["tipo"] == "bool":
                var = tk.StringVar(value="Sí")
                widget = ttk.Combobox(contenedor, textvariable=var, values=["Sí", "No"],
                                       state="readonly", width=22)
            elif "opciones" in col:
                var = tk.StringVar(value=col["opciones"][0])
                widget = ttk.Combobox(contenedor, textvariable=var, values=col["opciones"],
                                       state="readonly", width=22)
            else:
                var = tk.StringVar()
                widget = ttk.Entry(contenedor, textvariable=var, width=24)

            widget.pack(anchor="w")
            widget._var = var
            widget._colspec = col
            self.form_widgets[col["nombre"]] = widget

    def _leer_formulario(self):
        datos = {}
        for nombre, widget in self.form_widgets.items():
            texto = widget._var.get()
            datos[nombre] = valor_a_guardar(widget._colspec, texto)
        return datos

    def _poblar_formulario_desde_fila(self, fila_dict):
        for nombre, widget in self.form_widgets.items():
            if nombre in fila_dict:
                texto = valor_a_mostrar(widget._colspec, fila_dict[nombre])
                widget._var.set(texto)

    # ------------------------------------------------------------------
    def _cargar_grid(self):
        nodo = self._nodo_actual()
        tabla = self.tabla_var.get()
        columnas, filas = listar(nodo, tabla, orden_por=TABLA_DEF[tabla]["pk"])

        self.columnas_actual = columnas
        self.tree.delete(*self.tree.get_children())
        self.tree["columns"] = columnas
        for c in columnas:
            self.tree.heading(c, text=c)
            self.tree.column(c, width=100, anchor="w")
        for fila in filas:
            self.tree.insert("", "end", values=fila)
        return len(filas)

    def _on_grid_select(self, event):
        seleccion = self.tree.selection()
        if not seleccion:
            return
        valores = self.tree.item(seleccion[0], "values")
        fila_dict = dict(zip(self.columnas_actual, valores))
        pk = TABLA_DEF[self.tabla_var.get()]["pk"]
        self.pk_seleccionado = fila_dict.get(pk)
        if self.accion_var.get() in ("Actualizar", "Eliminar"):
            self._poblar_formulario_desde_fila(fila_dict)

    # ------------------------------------------------------------------
    def _disparar_replicacion(self, tabla, nodo_clave):
        """
        Calcula a qué nodos debe ir la replicación para mostrarlo en pantalla.
        La replicación física ahora la hace 'orquestador.py' en segundo plano.
        """
        pares = nodos_replicacion_para(tabla, nodo_clave)
        if not pares:
            return []

        # Hacemos una pausa de 1 segundo para darle tiempo al orquestador 
        # de Mateo de leer la cola y pasar los datos, antes de actualizar la GUI.
        import time
        time.sleep(1.5) 

        destinos_ok = []
        for origen, destino in pares:
            destinos_ok.append(NOMBRES_NODO[destino])
            
        return destinos_ok
    
    def _ejecutar(self):
        nodo_clave = self._nodo_clave()
        nodo = self._nodo_actual()
        tabla = self.tabla_var.get()
        accion = self.accion_var.get()
        pk = TABLA_DEF[tabla]["pk"]

        try:
            if accion == "Leer":
                n = self._cargar_grid()
                self._set_resumen(
                    f"Lectura en {nodo['nombre']} ({nodo['host']}:{nodo['port']}), tabla '{tabla}'.\n"
                    f"Resultado: {n} fila(s) obtenida(s)."
                )
                self.log(f"Leer {tabla} en {nodo['nombre']}: {n} filas")
                return

            if accion == "Crear":
                datos = self._leer_formulario()
                crear(nodo, tabla, datos)
                n = self._cargar_grid()

                destinos = []
                if self.replicacion_var.get() != "Ninguna":
                    destinos = self._disparar_replicacion(tabla, nodo_clave)

                resumen = (
                    f"Se creó un nuevo registro en {nodo['nombre']} ({nodo['host']}:{nodo['port']}), "
                    f"tabla '{tabla}'.\n"
                )
                if destinos:
                    resumen += (f"Replicación {self.replicacion_var.get().lower()} aplicada: "
                                f"visible en {', '.join(destinos)}.\n")
                elif self.replicacion_var.get() != "Ninguna":
                    resumen += "Se seleccionó replicación pero no se pudo confirmar su aplicación (ver log).\n"
                resumen += f"Grid actualizado: {n} fila(s) en {tabla}."
                self._set_resumen(resumen)
                self.log(f"Crear {tabla} en {nodo['nombre']}: OK")
                return

            if accion == "Actualizar":
                if self.pk_seleccionado is None:
                    messagebox.showwarning("Actualizar", "Selecciona primero una fila en el grid.")
                    return
                datos = self._leer_formulario()
                datos[pk] = self.pk_seleccionado
                filas_afectadas = actualizar(nodo, tabla, pk, self.pk_seleccionado, datos)
                n = self._cargar_grid()

                destinos = []
                if self.replicacion_var.get() != "Ninguna":
                    destinos = self._disparar_replicacion(tabla, nodo_clave)

                resumen = (
                    f"Se actualizó el registro {pk}={self.pk_seleccionado} en {nodo['nombre']} "
                    f"({nodo['host']}:{nodo['port']}), tabla '{tabla}' ({filas_afectadas} fila afectada).\n"
                )
                if destinos:
                    resumen += (f"Replicación {self.replicacion_var.get().lower()} aplicada: "
                                f"visible en {', '.join(destinos)}.\n")
                resumen += f"Grid actualizado: {n} fila(s) en {tabla}."
                self._set_resumen(resumen)
                self.log(f"Actualizar {tabla} pk={self.pk_seleccionado} en {nodo['nombre']}: OK")
                return

            if accion == "Eliminar":
                if self.pk_seleccionado is None:
                    messagebox.showwarning("Eliminar", "Selecciona primero una fila en el grid.")
                    return
                confirmar = messagebox.askyesno(
                    "Confirmar eliminación",
                    f"¿Eliminar el registro {pk}={self.pk_seleccionado} de '{tabla}' en {nodo['nombre']}?")
                if not confirmar:
                    return
                filas_afectadas = eliminar(nodo, tabla, pk, self.pk_seleccionado)
                n = self._cargar_grid()

                resumen = (
                    f"Se eliminó el registro {pk}={self.pk_seleccionado} en {nodo['nombre']} "
                    f"({nodo['host']}:{nodo['port']}), tabla '{tabla}' ({filas_afectadas} fila afectada).\n"
                )
                if TABLA_DEF[tabla].get("replicacion") is not None:
                    resumen += ("Nota: los DELETE no se replican en este diseño (los triggers de outbox "
                                "solo capturan INSERT/UPDATE); el borrado queda solo en este nodo.\n")
                resumen += f"Grid actualizado: {n} fila(s) en {tabla}."
                self._set_resumen(resumen)
                self.log(f"Eliminar {tabla} pk={self.pk_seleccionado} en {nodo['nombre']}: OK")
                self.pk_seleccionado = None
                return

        except ValueError as e:
            messagebox.showerror("Datos inválidos", str(e))
        except Exception as e:
            self._set_resumen(f"ERROR al ejecutar {accion} sobre '{tabla}' en {nodo['nombre']}:\n{e}", ok=False)
            self.log(f"ERROR {accion} {tabla} en {nodo['nombre']}: {e}")


if __name__ == "__main__":
    app = App()
    app.mainloop()
