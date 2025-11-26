from flask import Flask, request, send_file
import io
from generar_documento import crear_pdf   # tu función real

app = Flask(__name__)

@app.post("/generar-documento")
def generar():
    data = request.json
    tipo = data["tipo"]
    rfc = data["rfc"]

    # TU FUNCIÓN QUE GENERA EL PDF
    pdf_bytes = crear_pdf(tipo, rfc)

    return pdf_bytes

app.run(port=5000)
