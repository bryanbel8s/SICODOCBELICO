import { API_URL } from "./config.js";

export function guardarToken(token, usuario) {
    localStorage.setItem("token", token);
    localStorage.setItem("usuario", JSON.stringify(usuario));
}

export function obtenerToken() {
    return localStorage.getItem("token");
}

export function obtenerUsuario() {
    const raw = localStorage.getItem("usuario");
    return raw ? JSON.parse(raw) : null;
}

export async function cerrarSesion() {
    const token = obtenerToken();
    const usuario = obtenerUsuario();

    try {
        // Sólo limpiamos PDFs cuando el que sale es Docente
        if (token && usuario && usuario.rol === "Docente") {
            await fetch(`${API_URL}/docente/limpiar-pdfs`, {
                method: "POST",
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
        }
    } catch (e) {
        console.error("Error limpiando PDFs del docente:", e);
    }

    localStorage.clear();
    window.location.href = "login.html";
}
