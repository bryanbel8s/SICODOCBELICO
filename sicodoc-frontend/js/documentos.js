import { API_URL } from "./config.js";
import { obtenerToken, obtenerUsuario } from "./auth.js";

document.addEventListener("DOMContentLoaded", async () => {
    const token = obtenerToken();
    const usuario = obtenerUsuario();
    if (!token || !usuario) {
        window.location.href = "login.html";
        return;
    }

    const params = new URLSearchParams(window.location.search);
    const idexpediente = params.get("exp");

    const select = document.getElementById("selectTipo");
    const btnGenerar = document.getElementById("btnGenerarDoc");
    const tabla = document.getElementById("tablaDocumentos");

    // Cargar documentos existentes del expediente
    async function cargarDocumentos() {
        const res = await fetch(`${API_URL}/documentos/mis`, {
            headers: {
                "Authorization": `Bearer ${token}`
            }
        });

        const docs = await res.json();
        tabla.innerHTML = "";

        docs
          .filter(d => d.idexpediente == idexpediente)
          .forEach(d => {
            tabla.innerHTML += `
              <tr>
                  <td>${d.tipo}</td>
                  <td>${d.estado || "En captura"}</td>
                  <td>${d.fechageneracion || ""}</td>
              </tr>
            `;
          });
    }

    if (btnGenerar) {
        btnGenerar.addEventListener("click", async () => {
            const tipo = select.value;

            const res = await fetch(`${API_URL}/documentos/generar`, {
                method: "POST",
                headers: {
                    "Authorization": `Bearer ${token}`,
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    tipo,
                    idexpediente,
                    rfc: usuario.rfc
                })
            });

            const data = await res.json();

            if (!res.ok) {
                alert(data.error || "Error al generar documento");
                return;
            }

            alert("Documento generado correctamente");
            cargarDocumentos();
        });
    }

    cargarDocumentos();
});
