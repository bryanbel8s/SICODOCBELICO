import { API_URL } from "./config.js";
import { obtenerToken } from "./auth.js";

// Obtener parámetros de la URL
const params = new URLSearchParams(window.location.search);
const docId = params.get("id");
const docName = params.get("name");
const origen = params.get("origen");

const token = obtenerToken();

// URL correcta
const url = `${API_URL}/documentos/pdf/${origen}/${docId}`;

// Título
document.getElementById("doc-name").textContent = docName;

// Variables PDF
let pdfDoc = null;
let pageNum = 1;
let scale = 1.2;
let rotation = 0;

const canvas = document.getElementById("pdf-render");
const ctx = canvas.getContext("2d");

// Función para renderizar página
function renderPage(num) {
    pdfDoc.getPage(num).then(page => {
        const viewport = page.getViewport({ scale, rotation });

        canvas.height = viewport.height;
        canvas.width = viewport.width;

        const renderContext = {
            canvasContext: ctx,
            viewport: viewport
        };

        page.render(renderContext);
        document.getElementById("page-num").textContent = num;
    });
}

// ======== Cargar el PDF ========
pdfjsLib.getDocument({
    url,
    httpHeaders: {
        Authorization: `Bearer ${token}`
    }
}).promise
.then(pdf => {
    pdfDoc = pdf;

    if (pdf.numPages === 0) {
        alert("El PDF está vacío");
        return;
    }

    document.getElementById("page-count").textContent = pdf.numPages;

    renderPage(pageNum);
})
.catch(err => {
    console.error("Error cargando PDF:", err);
    alert("No se pudo cargar el PDF");
});

// ======== Navegación ========
document.getElementById("prev").addEventListener("click", () => {
    if (pageNum <= 1) return;
    pageNum--;
    renderPage(pageNum);
});

document.getElementById("next").addEventListener("click", () => {
    if (pageNum >= pdfDoc.numPages) return;
    pageNum++;
    renderPage(pageNum);
});

// ======== Zoom ========
document.getElementById("zoom-in").addEventListener("click", () => {
    scale += 0.2;
    renderPage(pageNum);
});

document.getElementById("zoom-out").addEventListener("click", () => {
    if (scale <= 0.6) return;
    scale -= 0.2;
    renderPage(pageNum);
});

// ======== Rotar ========
document.getElementById("rotate").addEventListener("click", () => {
    rotation = (rotation + 90) % 360;
    renderPage(pageNum);
});
