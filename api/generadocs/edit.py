# api/generadocs/edit.py
import psycopg2
import fitz  # PyMuPDF
import qrcode
import io
import os

# ============================================
# CONEXIÓN A BD SICODOC (que ve itculiacan vía FDW)
# ============================================
def get_conn():
    return psycopg2.connect(
        host="localhost",
        dbname="sicodoc",
        user="sicodoc_user",
        password="SicodocPass123",
        port="5432"
    )

# ============================================
# Cargar metadatos del documento (ITC + plantilla)
# ============================================
def cargar_metadatos(id_doc_sicodoc):
    sql = """
    SELECT
      vsi.id_doc_itc,
      vsi.id_tipo_doc,
      vsi.nombre_doc,
      vsi.plantilla_archivo
    FROM v_spd_documentos_itc vsi
    WHERE vsi.id_doc_sicodoc = %s
    LIMIT 1;
    """
    conn = get_conn()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, (id_doc_sicodoc,))
            row = cur.fetchone()
            if not row:
                raise Exception(f"No se encontró documento ITC para id_doc_sicodoc={id_doc_sicodoc}")
            id_doc_itc, id_tipo_doc, nombre_doc, plantilla_archivo = row
            return {
                "id_doc_itc": id_doc_itc,
                "id_tipo_doc": id_tipo_doc,
                "nombre_doc": nombre_doc,
                "plantilla_archivo": plantilla_archivo
            }
    finally:
        conn.close()

# ============================================
# Cargar campos + valores desde v_spd_documentos_detalle
# ============================================
def cargar_campos_y_valores(id_doc_sicodoc):
    sql = """
    SELECT nombre_campo, valor
    FROM v_spd_documentos_detalle
    WHERE id_doc_sicodoc = %s;
    """
    conn = get_conn()
    campos = {}
    try:
        with conn.cursor() as cur:
            cur.execute(sql, (id_doc_sicodoc,))
            for nombre_campo, valor in cur.fetchall():
                campos[nombre_campo] = valor or ""
        return campos
    finally:
        conn.close()

# ============================================
# Cargar posiciones PDF
# ============================================
def cargar_posiciones(id_tipo_doc):
    sql = """
    SELECT
      cd.nombre_campo,
      p.pagina,
      p.x,
      p.y,
      p.font_size
    FROM posiciones_pdf p
    JOIN itculiacan_fdw.campos_documento cd
      ON cd.id_campo = p.id_campo
    WHERE p.id_tipo_doc = %s;
    """
    conn = get_conn()
    posiciones = []
    try:
        with conn.cursor() as cur:
            cur.execute(sql, (id_tipo_doc,))
            for nombre_campo, pagina, x, y, font_size in cur.fetchall():
                posiciones.append({
                    "nombre_campo": nombre_campo,
                    "pagina": pagina or 0,
                    "x": float(x),
                    "y": float(y),
                    "font_size": float(font_size or 10)
                })
        return posiciones
    finally:
        conn.close()

# ============================================
# Generar QR (si hay campo qr_firma y valor)
# ============================================
def generar_imagen_qr(texto_qr: str):
    qr = qrcode.QRCode(
        version=1,
        box_size=4,
        border=1
    )
    qr.add_data(texto_qr)
    qr.make(fit=True)
    img = qr.make_image(fill_color="black", back_color="white")

    # Convertir a bytes para PyMuPDF
    buf = io.BytesIO()
    img.save(buf, format="PNG")
    buf.seek(0)
    return buf.getvalue()

# ============================================
# FUNCIÓN PRINCIPAL: generar_pdf(id_doc_sicodoc)
# ============================================
def generar_pdf(id_doc_sicodoc: int) -> str:
    meta = cargar_metadatos(id_doc_sicodoc)
    campos = cargar_campos_y_valores(id_doc_sicodoc)
    posiciones = cargar_posiciones(meta["id_tipo_doc"])

    plantilla_path = os.path.join(
        os.path.dirname(__file__),
        "plantillas",
        meta["plantilla_archivo"]
    )

    # Carpeta de salida
    salida_dir = os.path.join(os.path.dirname(__file__), "docs")
    os.makedirs(salida_dir, exist_ok=True)

    salida_path = os.path.join(
        salida_dir,
        f"spd_{id_doc_sicodoc}.pdf"
    )

    if not os.path.exists(plantilla_path):
        raise Exception(f"No existe la plantilla: {plantilla_path}")

    # Abrir plantilla con PyMuPDF
    doc = fitz.open(plantilla_path)

    # Preparar QR si existe campo 'qr_firma'
    qr_image_bytes = None
    if "qr_firma" in campos and campos["qr_firma"]:
        qr_image_bytes = generar_imagen_qr(campos["qr_firma"])

    # Escribir texto en cada posición
    for pos in posiciones:
        nombre_campo = pos["nombre_campo"]
        pagina = pos["pagina"]
        x = pos["x"]
        y = pos["y"]
        font_size = pos["font_size"]

        if pagina < 0 or pagina >= len(doc):
            continue

        page = doc[pagina]

        # Si es el QR
        if nombre_campo == "qr_firma" and qr_image_bytes:
            rect = fitz.Rect(x, y, x + 80, y + 80)  # tamaño aproximado
            img = fitz.Pixmap(qr_image_bytes)
            page.insert_image(rect, pixmap=img)
            continue

        valor = campos.get(nombre_campo, "")

        if not valor:
            continue

        page.insert_text(
            fitz.Point(x, y),
            str(valor),
            fontsize=font_size,
            fontname="helv"
        )

    doc.save(salida_path)
    doc.close()

    print(f"PDF generado correctamente: {salida_path}")
    # Devolver ruta relativa (para que Node la use)
    return salida_path
