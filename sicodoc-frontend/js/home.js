import { API_URL } from "./config.js";
import { obtenerToken, cerrarSesion } from "./auth.js";

document.addEventListener("DOMContentLoaded", async () => {
    const token = obtenerToken();

    const container = document.querySelector(".document-buttons");
    if (!container) return;

    try {
        const res = await fetch(`${API_URL}/docente/dashboard`, {
            headers: { Authorization: `Bearer ${token}` }
        });


        const data = await res.json();
        console.log("Respuesta /documentos/mis =>", res.status, data);

        // ⚠️ SI EL TOKEN ES INVÁLIDO O NO LLEGA
        if (!res.ok) {
            if (res.status === 401) {
                // Token malo o inexistente → mándalo a login
                alert(data.error || "Sesión expirada, inicia sesión de nuevo.");
                localStorage.clear();
                window.location.href = "login.html";
                return;
            }

            container.innerHTML = "<p>Error al cargar documentos.</p>";
            return;
        }

        // En este punto estamos seguros de que data ES un arreglo
        const docs = Array.isArray(data) ? data : [];

        container.innerHTML = "";

        if (docs.length === 0) {
            // Aquí sí es válido mandarlo a sin_documentos
            window.location.href = "sin_documentos.html";
            return;
        }

        // Pintar los documentos
        docs.forEach(doc => {
            container.innerHTML += `
                <button class="document-btn"
                    data-doc-id="${doc.id}"
                    data-doc-name="${doc.tipo}"
                    data-doc-origen="${doc.origen}">
                    Documento ${doc.tipo} (${doc.origen})
                </button>
            `;
        });

        container.addEventListener("click", (e) => {
            const boton = e.target.closest(".document-btn");
            if (boton) {
                const id = boton.dataset.docId;
                const name = boton.dataset.docName;
                const origen = boton.dataset.docOrigen;

                window.location.href = `vistaprev_pdf.html?id=${id}&name=${name}&origen=${origen}`;
            }
        });


        document.getElementById("back-button").onclick = cerrarSesion;


    } catch (e) {
        console.error(e);
        container.innerHTML = "<p>Error al cargar documentos (catch).</p>";
    }
});
