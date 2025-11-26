import { obtenerToken } from "./auth.js";

if (!obtenerToken()) {
    window.location.href = "login.html";
}
