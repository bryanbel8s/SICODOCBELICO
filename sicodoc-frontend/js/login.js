import { API_URL } from "./config.js";
import { guardarToken } from "./auth.js";

document.addEventListener("DOMContentLoaded", () => {
    const form = document.querySelector(".formulario");

    form.addEventListener("submit", async (event) => {
        event.preventDefault();

        const correo = document.getElementById("correo").value.trim();
        const password = document.getElementById("password").value.trim();

        const res = await fetch(`${API_URL}/auth/login`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ correo, password })
        });

        const data = await res.json();

        if (!res.ok) {
            alert(data.error || "Credenciales incorrectas");
            return;
        }

        guardarToken(data.token, data.usuario);

        switch (data.usuario.idrol) {
            case 1: window.location.href = "home.html"; break;  // Docente
            case 2:
            case 3:
            case 4:
                window.location.href = "ventana_director.html"; break;
            default:
                alert("Rol no reconocido");
        }
    });
});
