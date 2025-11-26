import { API_URL } from "./config.js";
import { obtenerToken } from "./auth.js";

const params = new URLSearchParams(window.location.search);
const idrevision = params.get("id");

document.addEventListener("DOMContentLoaded", async () => {
    const token = obtenerToken();

    // mostrar nombre del docente y vista previa
    const res = await fetch(`${API_URL}/revisiones/detalle/${idrevision}`, {
        headers: { Authorization: `Bearer ${token}` }
    });

    const dato = await res.json();

    document.getElementById("docentName").textContent = dato.docente;

    // vista previa (solo una imagen o PDF)
    document.querySelector(".document-preview img").src =
        `vistaprev_pdf.html?id=${dato.iddocumento}&name=${dato.tipo}`;

    // botones reales
    document.getElementById("sign-button").onclick = async () => {
        await fetch(`${API_URL}/revisiones/${idrevision}`, {
            method: "POST",
            headers: {
                Authorization: `Bearer ${token}`,
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ estado: "Aprobado", comentarios: "" })
        });

        alert("Documento aprobado");
        window.location.href = "ventana_director.html";
    };

    document.getElementById("reject-button").onclick = async () => {
        const comentarios = prompt("Motivo:");
        await fetch(`${API_URL}/revisiones/${idrevision}`, {
            method: "POST",
            headers: {
                Authorization: `Bearer ${token}`,
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ estado: "Rechazado", comentarios })
        });

        alert("Documento rechazado");
        window.location.href = "ventana_director.html";
    };
});
