import { API_URL } from "./config.js";
import { obtenerToken } from "./auth.js";

const params = new URLSearchParams(window.location.search);
const docId = params.get("id");
const docName = params.get("name");

const token = obtenerToken();

const url = `${API_URL}/documentos/pdf/${docId}`;

document.getElementById("doc-name").textContent = docName;

let pdfDoc = null,
    pageNum = 1,
    scale = 1.2,
    rotation = 0,
    canvas = document.getElementById("pdf-render"),
    ctx = canvas.getContext("2d");

pdfjsLib.getDocument({
    url,
    httpHeaders: {
        Authorization: `Bearer ${token}`
    }
}).promise.then(pdf => {
    pdfDoc = pdf;
    document.getElementById("page-count").textContent = pdf.numPages;
    renderPage(pageNum);
});
