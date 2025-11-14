import jwt from "jsonwebtoken";

const SECRET = "SICODOC_SUPER_SECRETO_2025";

export function crearToken(payload: any) {
    return jwt.sign(payload, SECRET, { expiresIn: "4h" });
}

export function verificarToken(token: string) {
    return jwt.verify(token, SECRET);
}
