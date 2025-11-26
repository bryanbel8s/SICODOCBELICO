import { Request, Response } from "express";
import bcrypt from "bcryptjs";
import { sicodocDB } from "../db";
import { crearToken } from "../servicios/jwt";

export async function login(req: Request, res: Response) {
    const { correo, password } = req.body;

    if (!correo || !password) {
        return res.status(400).json({ error: "Faltan datos" });
    }

    try {
        const result = await sicodocDB.query(
            `SELECT 
                u.rfc,
                u.nombre,
                u.apellido,
                u.correo,
                u.contrasena_hash,
                u.idrol,
                r.nombrerol
            FROM usuario u
            JOIN rol r ON r.idrol = u.idrol
            WHERE u.correo = $1`,
            [correo]
        );

        if (result.rowCount === 0) {
            return res.status(404).json({ error: "Correo no encontrado" });
        }

        const user = result.rows[0];

        const passwordOk = await bcrypt.compare(password, user.contrasena_hash);
        if (!passwordOk) {
            return res.status(401).json({ error: "Contraseña incorrecta" });
        }

        const payload = {
            rfc: user.rfc,
            nombre: user.nombre,
            apellido: user.apellido,
            correo: user.correo,
            idrol: user.idrol,
            rol: user.nombrerol  // 'Docente', 'Director', etc.
        };

        const token = crearToken(payload);

        return res.json({
            ok: true,
            token,
            usuario: payload
        });

    } catch (error) {
        console.error("Error login:", error);
        return res.status(500).json({ error: "Error interno del servidor" });
    }
}
