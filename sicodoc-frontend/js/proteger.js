import { obtenerToken } from "./auth.js";

const paginasSinAutenticacion = [
    "login.html"
];

const actual = window.location.pathname.split("/").pop();

if (!obtenerToken() && !paginasSinAutenticacion.includes(actual)) {
    window.location.href = "login.html";
}
