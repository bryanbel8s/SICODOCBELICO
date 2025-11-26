import { Request, Response, NextFunction } from "express";
import { verificarToken } from "../servicios/jwt";

export function requireAuth(req: Request, res: Response, next: NextFunction) {
    const header = req.headers["authorization"];

    if (!header || !header.startsWith("Bearer ")) {
        return res.status(401).json({ error: "Token no enviado" });
    }

    const token = header.substring(7);

    try {
        const decoded = verificarToken(token);
        (req as any).usuario = decoded;
        next();
    } catch (error) {
        console.error("Error verificando token:", error);
        return res.status(401).json({ error: "Token inválido o expirado" });
    }
}

export function requireRoles(...rolesPermitidos: string[]) {
    return (req: Request, res: Response, next: NextFunction) => {
        const usuario = (req as any).usuario;

        if (!usuario) {
            return res.status(401).json({ error: "No autenticado" });
        }

        if (!rolesPermitidos.includes(usuario.rol)) {
            return res.status(403).json({ error: "No tienes permiso para esta acción" });
        }

        next();
    };
}
