# api/python/generar_pdf.py

import sys
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from utils_sql import get_connection

def generar_pdf(id_docente):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT nombre, rfc, academia, periodo
        FROM docentes
        WHERE id_docente = ?
    """, id_docente)
    d = cursor.fetchone()

    if not d:
        print("❌ Docente no encontrado.")
        return

    nombre_archivo = f"constancia_{d.nombre}.pdf"
    c = canvas.Canvas(nombre_archivo, pagesize=A4)

    c.setFont("Helvetica-Bold", 14)
    c.drawString(100, 780, "CONSTANCIA DE PARTICIPACIÓN")

    c.setFont("Helvetica", 12)
    c.drawString(100, 740, f"Nombre del docente: {d.nombre}")
    c.drawString(100, 720, f"RFC: {d.rfc}")
    c.drawString(100, 700, f"Academia: {d.academia}")
    c.drawString(100, 680, f"Periodo: {d.periodo}")

    c.save()
    print(f"✅ PDF generado correctamente: {nombre_archivo}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        generar_pdf(sys.argv[1])
    else:
        print("⚠️ Falta el parámetro id_docente.")
