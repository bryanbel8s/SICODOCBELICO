import { API_URL } from "./config.js";
import { obtenerToken, cerrarSesion } from "./auth.js";

document.addEventListener("DOMContentLoaded", async () => {
    const token = obtenerToken();
    const lista = document.querySelector(".documents-list");

    const res = await fetch(`${API_URL}/revisiones/pendientes`, {
        headers: { Authorization: `Bearer ${token}` }
    });

    const revisiones = await res.json();
    lista.innerHTML = "";

    if (!revisiones.length) {
        lista.innerHTML = "<p>No hay expedientes pendientes.</p>";
        return;
    }

    revisiones.forEach(r => {
        lista.innerHTML += `
        <a href="revision.html?id=${r.idrevision}" class="document-item-link">
            <div class="document-item">
                <h3>Expediente: ${r.docente}</h3>
                <span class="document-status">Pendiente</span>
            </div>
        </a>`;
    });


    document.getElementById("back-button").onclick = cerrarSesion;

});
