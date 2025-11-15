import { Request, Response } from "express";
import bcrypt from "bcryptjs";
import { pool } from "../db";
import { crearToken } from "../servicios/jwt";

export async function login(req: Request, res: Response) {
    const { correo, password } = req.body;

    if (!correo || !password) {
        return res.status(400).json({ error: "Faltan datos" });
    }

    try {
        // ============================
        // CONSULTA EN POSTGRESQL
        // ============================
        const query = `
            SELECT 
                u.rfc,
                u.nombre,
                u.apellido,
                u.correo,
                u.contrasena_hash,
                u.idrol,
                r.nombrerol
            FROM usuario u
            JOIN rol r ON r.idrol = u.idrol
            WHERE u.correo = $1
            LIMIT 1
        `;

        const result = await pool.query(query, [correo]);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: "Correo no encontrado" });
        }

        const user = result.rows[0];

        // ============================
        // VALIDACIÓN DE CONTRASEÑA
        // ============================
        const storedHash = user.contrasena_hash;

        const valid = await bcrypt.compare(password, storedHash);

        if (!valid) {
            return res.status(401).json({ error: "Contraseña incorrecta" });
        }

        // ============================
        // CREACIÓN DEL TOKEN
        // ============================
        const token = crearToken({
            rfc: user.rfc,
            nombre: user.nombre,
            apellido: user.apellido,
            correo: user.correo,
            idrol: user.idrol,
            rol: user.nombrerol
        });

        return res.json({
            message: "Login exitoso",
            token,
            usuario: {
                rfc: user.rfc,
                nombre: user.nombre,
                apellido: user.apellido,
                correo: user.correo,
                rol: user.nombrerol,
                idrol: user.idrol
            }
        });

    } catch (error: any) {
        console.error("Error login:", error);
        return res.status(500).json({ error: "Error interno del servidor" });
    }
}
