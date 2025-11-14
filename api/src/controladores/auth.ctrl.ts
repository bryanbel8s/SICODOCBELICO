import { Request, Response } from "express";
import bcrypt from "bcryptjs";
import { pool, poolConnect } from "../servicios/db.js";
import { crearToken } from "../servicios/jwt.js";

export async function login(req: Request, res: Response) {
    const { correo, password } = req.body;

    if (!correo || !password)
        return res.status(400).json({ error: "Faltan datos" });

    try {
        await poolConnect;
        const request = pool.request();

        const query = `
            SELECT 
                u.RFC, u.NOMBRE, u.APELLIDO, u.CORREO,
                u.CONTRASENA_HASH, u.IDROL,
                r.NOMBREROL
            FROM USUARIO u
            JOIN ROL r ON r.IDROL = u.IDROL
            WHERE u.CORREO = @correo
        `;

        request.input("correo", correo);

        const result = await request.query(query);

        if (result.recordset.length === 0)
            return res.status(404).json({ error: "Correo no encontrado" });

        const user = result.recordset[0];

        const storedHash = user.CONTRASENA_HASH.toString("utf8");

        const valid = bcrypt.compareSync(password, storedHash);
        if (!valid)
            return res.status(401).json({ error: "Contraseña incorrecta" });

        const token = crearToken({
            rfc: user.RFC,
            nombre: user.NOMBRE,
            apellido: user.APELLIDO,
            correo: user.CORREO,
            idrol: user.IDROL,
            rol: user.NOMBREROL,
        });

        return res.json({
            message: "Login exitoso",
            token,
            usuario: {
                rfc: user.RFC,
                nombre: user.NOMBRE,
                apellido: user.APELLIDO,
                correo: user.CORREO,
                rol: user.NOMBREROL,
                idrol: user.IDROL
            }
        });

    } catch (error) {
        console.error("Error login:", error);
        return res.status(500).json({ error: "Error interno del servidor" });
    }
}
