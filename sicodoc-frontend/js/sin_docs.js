import { obtenerUsuario } from "./auth.js";

document.addEventListener("DOMContentLoaded", () => {
    const usuario = obtenerUsuario();
    document.querySelector(".message strong").textContent = usuario.nombre;
});
