// --- Contenido para js/home.js ---
document.addEventListener("DOMContentLoaded", () => {
    
    // Busca el contenedor de botones
    const container = document.querySelector(".document-buttons");

    if (container) {
        container.addEventListener("click", (e) => {
            // Encuentra el botón específico al que se le hizo clic
            const boton = e.target.closest(".document-btn");
            
            if (boton) {
                // Obtiene los datos del botón
                const docId = boton.dataset.docId;
                const docName = boton.dataset.docName;

                if (docId && docName) {
                    // Crea los parámetros de la URL
                    const params = new URLSearchParams();
                    params.append('id', docId);
                    params.append('name', docName);

                    // Redirige al usuario al visor de PDF
                    window.location.href = `vistaprev_pdf.html?${params.toString()}`;
                }
            }
        });
    }
});