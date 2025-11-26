import psycopg2
import fitz  # PyMuPDF
import qrcode
import io

# ============================================
# CONEXIÓN A BD
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
# CARGAR TODOS LOS DATOS NECESARIOS
# ============================================
def cargar_datos_documento(id_documento):
    conn = get_conn()
    cur = conn.cursor()

    # 1️⃣ obtener id_tipo_doc
    cur.execute("""
        SELECT id_tipo_doc 
        FROM documentos 
        WHERE id_documento = %s
    """, (id_documento,))
    tipo_doc = cur.fetchone()[0]

    # 2️⃣ obtener valores_documento
    cur.execute("""
        SELECT c.nombre_campo, v.valor
          FROM valores_documento v
          JOIN itculiacan_fdw.campos_documento c ON c.id_campo = v.id_campo
         WHERE v.id_documento = %s
    """, (id_documento,))
    valores = {row[0]: row[1] for row in cur.fetchall()}

    # 3️⃣ obtener posiciones
    cur.execute("""
        SELECT c.nombre_campo, p.pagina, p.x, p.y, p.font_size
          FROM posiciones_pdf p
          JOIN itculiacan_fdw.campos_documento c ON c.id_campo = p.id_campo
         WHERE p.id_tipo_doc = %s
         ORDER BY p.id_posicion
    """, (tipo_doc,))
    posiciones = cur.fetchall()

    cur.close()
    conn.close()

    return tipo_doc, valores, posiciones

# ============================================
# GENERAR QR
# ============================================
def generar_qr(contenido: str):
    qr = qrcode.QRCode(version=1, box_size=10, border=2)
    qr.add_data(contenido)
    qr.make(fit=True)

    img = qr.make_image(fill_color="black", back_color="white")
    bytes_qr = io.BytesIO()
    img.save(bytes_qr, format="PNG")

    return bytes_qr.getvalue()

# ============================================
# FUNCIÓN GENERAL PARA RELLENAR CUALQUIER DOCUMENTO
# ============================================
def generar_pdf(id_documento, plantilla_path, salida_path):
    tipo_doc, valores, posiciones = cargar_datos_documento(id_documento)

    doc = fitz.open(plantilla_path)

    # si algún campo requiere QR
    qr_image = None
    if "qr_firma" in valores:
        qr_image = generar_qr(valores["qr_firma"])

    for nombre_campo, pagina, x, y, font_size in posiciones:
        if nombre_campo not in valores:
            continue

        valor = valores[nombre_campo]

        if nombre_campo == "qr_firma":
            rect = fitz.Rect(x, y, x + 80, y + 80)
            doc[pagina].insert_image(rect, stream=qr_image)
        else:
            doc[pagina].insert_text(
                fitz.Point(x, y),
                str(valor),
                fontsize=float(font_size)
            )

    doc.save(salida_path)
    doc.close()

    print(f"PDF generado correctamente: {salida_path}")

# ============================================
# EJEMPLO DE USO
# ============================================
# generar_pdf(
#     id_documento=1,
#     plantilla_path="plantillas/plantilla.pdf",
#     salida_path="docs/Constancia_de_Situacion_Laboral.pdf"
# )
