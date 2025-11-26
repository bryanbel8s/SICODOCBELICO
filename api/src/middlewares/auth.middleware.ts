import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET || "SICODOC_SUPER_SECRET_2025";

export function requireAuth(req: Request, res: Response, next: NextFunction) {
    const header = req.headers.authorization;

    if (!header)
        return res.status(401).json({ error: "Token requerido" });

    const token = header.split(" ")[1];

    try {
        const decoded = jwt.verify(token, JWT_SECRET) as any;

        // ESTO HACE QUE req.user SE VEA EN TODAS PARTES
        (req as any).user = decoded;

        next();
    } catch (err) {
        return res.status(401).json({ error: "Token inválido" });
    }
}

export function requireRoles(...rolesPermitidos: string[]) {
    return (req: Request, res: Response, next: NextFunction) => {
        if (!(req as any).user) {
            return res.status(401).json({ error: "No autenticado" });
        }

        if (!rolesPermitidos.includes((req as any).user.rol
        )) {
            return res.status(403).json({ error: "Permiso denegado" });
        }

        next();
    };
}
