# api/generadocs/python_server.py
from flask import Flask, request, jsonify
from edit import generar_pdf  # nuestra función

app = Flask(__name__)

@app.route("/generar-pdf", methods=["POST"])
def generar_pdf_route():
    try:
        data = request.get_json()
        id_doc_sicodoc = int(data.get("id_doc_sicodoc"))

        ruta_pdf = generar_pdf(id_doc_sicodoc)

        return jsonify({"ok": True, "ruta_pdf": ruta_pdf})
    except Exception as e:
        print("Error en generar-pdf:", e)
        return jsonify({"ok": False, "error": str(e)}), 500


if __name__ == "__main__":
    # Puedes ajustar host y puerto según tu docker / entorno
    app.run(host="0.0.0.0", port=5001)
