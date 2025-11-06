const url = "../CASO DE USO FULL Y BREVE.pdf";
let pdfDoc = null,
    pageNum = 1,
    scale = 1.2,
    rotation = 0,
    canvas = document.getElementById("pdf-render"),
    ctx = canvas.getContext("2d");

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
document.getElementById("download").onclick = () => {
    const a = document.createElement("a");
    a.href = url;
    a.download = url.split("/").pop();
    a.click();
};
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
