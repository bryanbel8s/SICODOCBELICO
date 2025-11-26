import { API_URL } from "./config.js";
import { obtenerToken } from "./auth.js";

document.addEventListener("DOMContentLoaded", async () => {
    const token = obtenerToken();

    const container = document.querySelector(".document-buttons");
    if (!container) return;

    try {
        const res = await fetch(`${API_URL}/documentos/mis`, {
            headers: { Authorization: `Bearer ${token}` }
        });

        const docs = await res.json();
        container.innerHTML = "";

        if (!docs.length) {
            window.location.href = "sin_documentos.html";
            return;
        }

        docs.forEach(doc => {
            container.innerHTML += `
                <button class="document-btn"
                    data-doc-id="${doc.iddocumento}"
                    data-doc-name="${doc.tipo}">
                    ${doc.tipo}
                </button>
            `;
        });

        container.addEventListener("click", (e) => {
            const boton = e.target.closest(".document-btn");
            if (boton) {
                const id = boton.dataset.docId;
                const name = boton.dataset.docName;
                window.location.href = `vistaprev_pdf.html?id=${id}&name=${name}`;
            }
        });

        // cerrar sesión
        document.getElementById("back-button").onclick = () => {
            localStorage.clear();
            window.location.href = "login.html";
        };

    } catch (e) {
        container.innerHTML = "<p>Error al cargar documentos</p>";
    }
});
