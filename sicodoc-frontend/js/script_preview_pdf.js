// --- INICIO DE script_preview_pdf.js (Versión con API) ---

// 1. LEER LOS PARÁMETROS DE LA URL
const params = new URLSearchParams(window.location.search);
const docId = params.get('id');       // Ej: "2.3.4.1"
const docName = params.get('name');   // Ej: "Asesoría por proyecto..."

// 2. CONSTRUIR LA URL DE LA API
// ▼▼▼ ¡ESTA ES LA LÍNEA CLAVE! ▼▼▼
// Apunta a tu backend de Node.js que está corriendo en el puerto 3000
const url = `http://localhost:3000/api/get-pdf/${docId}`; 
// ▲▲▲ FIN DE LA LÍNEA CLAVE ▲▲▲

// 3. ACTUALIZAR EL TÍTULO EN LA PÁGINA
document.getElementById("doc-name").textContent = docName;

// --- Variables de PDF.js ---
let pdfDoc = null,
    pageNum = 1,
    scale = 1.2,
    rotation = 0,
    canvas = document.getElementById("pdf-render"),
    ctx = canvas.getContext("2d");

// --- Referencias de la Notificación ---
const downloadNotification = document.getElementById("download-notification");
const notificationText = document.getElementById("notification-text");
const notificationIconCheck = document.getElementById("notification-icon-check") || document.querySelector(".notification-icon");
const notificationSpinner = document.getElementById("notification-spinner-gif") || document.querySelector(".notification-spinner");
let isNotifying = false;

// 4. CARGAR EL PDF (Ahora desde la URL de tu API)
pdfjsLib.getDocument(url).promise.then(pdf => {
    pdfDoc = pdf;
    document.getElementById("page-count").textContent = pdf.numPages;
    renderPage(pageNum);
}).catch(err => {
    console.error("Error al cargar el PDF:", err);
    document.getElementById("doc-name").textContent = `Error: No se pudo cargar el documento ${docId}.`;
});

// --- Función de Renderizado (Sin cambios) ---
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

// --- Botones de Paginación y Zoom (Sin cambios) ---
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


// --- LÓGICA DE DESCARGA (Usando fetch, ya apunta a la API) ---
document.getElementById("download").onclick = () => {
    if (isNotifying) return;
    isNotifying = true;

    notificationText.textContent = "Preparando documento, espere un momento...";
    if (notificationSpinner) notificationSpinner.style.display = 'block';
    if (notificationIconCheck) notificationIconCheck.style.display = 'none';
    downloadNotification.classList.add('show');

    fetch(url) // 'url' es la API de tu backend
        .then(response => response.blob())
        .then(blob => {
            notificationText.textContent = `Actividad Completada. Descargando ${docName}...`;
            if (notificationSpinner) notificationSpinner.style.display = 'none';
            if (notificationIconCheck) notificationIconCheck.style.display = 'block';

            const a = document.createElement("a");
            a.href = URL.createObjectURL(blob);
            a.download = `${docId}_${docName}.pdf`;
            a.click();
            URL.revokeObjectURL(a.href);

            setTimeout(() => {
                downloadNotification.classList.remove('show');
                isNotifying = false;
            }, 4000);
        })
        .catch(err => {
            console.error('Error al descargar:', err);
            notificationText.textContent = "Error al preparar la descarga.";
            if (notificationSpinner) notificationSpinner.style.display = 'none';
            if (notificationIconCheck) notificationIconCheck.style.display = 'none';
            
            setTimeout(() => {
                downloadNotification.classList.remove('show');
                isNotifying = false;
            }, 5000);
        });
};


// --- Botón de Imprimir (Sin cambios) ---
document.getElementById("print").onclick = () => {
    const iframe = document.createElement("iframe");
    iframe.style.display = "none";
    iframe.src = url; 
    document.body.appendChild(iframe);
    iframe.contentWindow.focus();
    iframe.contentWindow.print();
};

// --- Botón de Volver (Sin cambios) ---
document.getElementById("back-button").onclick = () => {
    window.location.href = 'home.html'; // Más explícito que history.back
};