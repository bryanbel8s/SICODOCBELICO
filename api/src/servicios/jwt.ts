import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET || "SICODOC_SUPER_SECRET_2025";

export function crearToken(usuario) {
    const payload = {
        rfc: usuario.rfc,
        nombre: usuario.nombre,
        apellido: usuario.apellido,
        rol: usuario.rol,
        idrol: usuario.idrol
    };

    return jwt.sign(payload, JWT_SECRET, { expiresIn: "8h" });
}
