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

export function cerrarSesion() {
    localStorage.clear();
    window.location.href = "login.html";
}
