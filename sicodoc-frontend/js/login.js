document.addEventListener("DOMContentLoaded", () => {
    const form = document.querySelector(".formulario");

    form.addEventListener("submit", async (event) => {
        event.preventDefault();

        const correo = document.getElementById("correo").value;
        const password = document.getElementById("password").value;

        const res = await fetch("http://localhost:3000/api/auth/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ correo, password })
        });

        const data = await res.json();

        if (!res.ok) {
            alert(data.error || "Credenciales incorrectas");
            return;
        }

        localStorage.setItem("token", data.token);
        localStorage.setItem("usuario", JSON.stringify(data.usuario));

        // Redirección por rol
        switch (data.usuario.idrol) {
            case 1: // DOCENTE
                window.location.href = "home.html";
                break;
            case 2: // DIRECTOR
                window.location.href = "ventana_director.html";
                break;
            case 3: // SUBDIRECTOR
                window.location.href = "ventana_director.html";
                break;
            case 4: // JEFE DE DPTO
                window.location.href = "ventana_director.html";
                break;
            default:
                alert("Rol no reconocido");
        }
    });
});
