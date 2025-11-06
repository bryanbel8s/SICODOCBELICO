// --- INICIO DE script_preview_pdf.js ---

const url = "../CASO DE USO FULL Y BREVE.pdf";
let pdfDoc = null,
    pageNum = 1,
    scale = 1.2,
    rotation = 0,
    canvas = document.getElementById("pdf-render"),
    ctx = canvas.getContext("2d");

// ▼▼▼ NUEVO: Obtener la notificación y una variable de estado ▼▼▼
const downloadNotification = document.getElementById("download-notification");
let isNotifying = false; // Para evitar que el usuario haga spam de clics
// ▲▲▲ FIN DE CÓDIGO NUEVO ▲▲▲

pdfjsLib.getDocument(url).promise.then(pdf => {
    pdfDoc = pdf;
    document.getElementById("page-count").textContent = pdf.numPages;
    renderPage(pageNum);
});

function renderPage(num) {
    pdfDoc.getPage(num).then(page => {
    const viewport = page.getViewport({ scale, rotation });
    canvas.height = viewport.height;
    canvas.width = viewport.width;
    const renderCtx = {
        canvasContext: ctx,
        viewport: viewport
    };
    page.render(renderCtx);
    document.getElementById("page-num").textContent = num;
    });
}

document.getElementById("prev").onclick = () => {
    if (pageNum <= 1) return;
    pageNum--;
    renderPage(pageNum);
};
document.getElementById("next").onclick = () => {
    if (pageNum >= pdfDoc.numPages) return;
    pageNum++;
    renderPage(pageNum);
};
document.getElementById("zoom-in").onclick = () => {
    scale += 0.2;
    renderPage(pageNum);
};
document.getElementById("zoom-out").onclick = () => {
    if (scale <= 0.6) return;
    scale -= 0.2;
    renderPage(pageNum);
};
document.getElementById("rotate").onclick = () => {
    rotation = (rotation + 90) % 360;
    renderPage(pageNum);
};

// ▼▼▼ MODIFICADO: Lógica del botón de descarga ▼▼▼
document.getElementById("download").onclick = () => {
    // Si la notificación ya está activa, no hagas nada
    if (isNotifying) return;

    // 1. Ejecuta tu código de descarga original
    const a = document.createElement("a");
    a.href = url;
    a.download = url.split("/").pop();
    a.click();

    // 2. Muestra la notificación
    isNotifying = true; // Bloquea más clics
    downloadNotification.classList.add("show"); // Inicia la animación de "bajar"

    // 3. Oculta la notificación después de 4 segundos
    setTimeout(() => {
        downloadNotification.classList.remove("show"); // Inicia la animación de "subir"
        // Espera a que termine la animación de subida (0.5s) antes de desbloquear
        setTimeout(() => {
            isNotifying = false; // Desbloquea el botón
        }, 500); 
    }, 4000); // La notificación estará visible por 4 segundos
};
// ▲▲▲ FIN DE LA MODIFICACIÓN ▲▲▲

document.getElementById("print").onclick = () => {
    const iframe = document.createElement("iframe");
    iframe.style.display = "none";
    iframe.src = url;
    document.body.appendChild(iframe);
    iframe.contentWindow.focus();
    iframe.contentWindow.print();
};

document.getElementById("back-button").onclick = () => {
    window.history.back();
};

document.getElementById("doc-name").textContent = url.split("/").pop();