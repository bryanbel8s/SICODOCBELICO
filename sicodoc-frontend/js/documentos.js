// sicodoc-frontend/js/documentos.js

const API_BASE = "/api";

async function cargarDashboardDocente() {
  const resp = await fetch(`${API_BASE}/docente/dashboard`, {
    credentials: "include"
  });
  const data = await resp.json();

  // data.convocatoria
  // data.idexpediente
  // data.documentos = [{ id_doc_sicodoc, nombre_doc, estado_itc, archivo_final, qr_text }]

  const tabla = document.getElementById("tabla-documentos");
  tabla.innerHTML = "";

  data.documentos.forEach(doc => {
    const tr = document.createElement("tr");

    const tdNombre = document.createElement("td");
    tdNombre.textContent = doc.nombre_doc;

    const tdEstado = document.createElement("td");
    tdEstado.textContent = doc.estado_itc || "En proceso";

    const tdAcciones = document.createElement("td");
    const btn = document.createElement("button");
    btn.textContent = "Generar PDF";
    btn.onclick = () => generarPdf(doc.id_doc_sicodoc);

    tdAcciones.appendChild(btn);

    tr.appendChild(tdNombre);
    tr.appendChild(tdEstado);
    tr.appendChild(tdAcciones);

    tabla.appendChild(tr);
  });
}

async function generarPdf(idDocSicodoc) {
  try {
    const resp = await fetch(`${API_BASE}/docente/documentos/${idDocSicodoc}/generar`, {
      method: "POST",
      credentials: "include"
    });

    const data = await resp.json();

    if (!resp.ok || !data.ok) {
      alert(data.error || "No se pudo generar el PDF");
      return;
    }

    // Abrir PDF en nueva pestaña
    window.open(data.ruta_pdf, "_blank");
  } catch (err) {
    console.error(err);
    alert("Error al generar PDF");
  }
}

// Llamar al cargar la página
document.addEventListener("DOMContentLoaded", cargarDashboardDocente);
