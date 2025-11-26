from flask import Flask, request, Response
from edit import generar_pdf
import os

app = Flask(__name__)

@app.post("/generar-documento")
def generar_documento():
    data = request.json
    id_documento = data["id_documento"]

    plantilla = f"plantillas/{id_documento}.pdf"
    salida = f"/tmp/{id_documento}.pdf"

    generar_pdf(id_documento, plantilla, salida)

    with open(salida, "rb") as f:
        pdf_bytes = f.read()

    return Response(pdf_bytes, mimetype="application/pdf")

app.run(port=5000)
