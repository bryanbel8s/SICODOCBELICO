import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET || "SICODOC_SUPER_SECRET_2025";

interface UsuarioJWT {
  rfc: string;
  nombre: string;
  apellido: string;
  rol: string;
  idrol: number;
}

export function requireAuth(req: Request, res: Response, next: NextFunction) {
  const header = req.headers.authorization;

  if (!header) {
    return res.status(401).json({ error: "Token requerido" });
  }

  const token = header.split(" ")[1];

  try {
    const decoded = jwt.verify(token, JWT_SECRET) as UsuarioJWT;

    (req as any).usuario = decoded;
    (req as any).user = decoded; // compatibilidad con código viejo

    next();
  } catch (error) {
    console.error("Error verificando JWT:", error);
    return res.status(401).json({ error: "Token inválido o expirado" });
  }
}

export function requireRoles(...rolesPermitidos: string[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    const usuario = (req as any).usuario as UsuarioJWT | undefined;

    if (!usuario) {
      return res.status(401).json({ error: "No autenticado" });
    }

    if (!rolesPermitidos.includes(usuario.rol)) {
      return res.status(403).json({ error: "Permiso denegado" });
    }

    next();
  };
}
