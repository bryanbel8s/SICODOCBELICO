import { Request, Response } from "express";
import { sicodocDB } from "../db";

export async function crearExpediente(req: Request, res: Response) {
    const { idconvocatoria } = req.body;
    const usuario = (req as any).usuario;

    if (!idconvocatoria) {
        return res.status(400).json({ error: "Falta idconvocatoria" });
    }

    try {
        const existente = await sicodocDB.query(
            `SELECT idexpediente
             FROM expediente
             WHERE rfc_usuario = $1
               AND idconvocatoria = $2`,
            [usuario.rfc, idconvocatoria]
        );

        if (existente.rowCount > 0) {
            return res.status(200).json({
                yaExistia: true,
                expediente: existente.rows[0]
            });
        }

        const insert = await sicodocDB.query(
            `INSERT INTO expediente (estado, rfc_usuario, idconvocatoria)
             VALUES ('En captura', $1, $2)
             RETURNING *`,
            [usuario.rfc, idconvocatoria]
        );

        return res.status(201).json(insert.rows[0]);

    } catch (error) {
        console.error("Error crearExpediente:", error);
        return res.status(500).json({ error: "Error al crear expediente" });
    }
}

export async function getMisExpedientes(req: Request, res: Response) {
    const usuario = (req as any).usuario;

    try {
        const consulta = await sicodocDB.query(
            `SELECT 
                e.*,
                c.nombre AS nombre_convocatoria
             FROM expediente e
             JOIN convocatoria c ON c.idconvocatoria = e.idconvocatoria
             WHERE e.rfc_usuario = $1
             ORDER BY e.fechacreacion DESC`,
            [usuario.rfc]
        );

        return res.json(consulta.rows);
    } catch (error) {
        console.error("Error getMisExpedientes:", error);
        return res.status(500).json({ error: "Error al obtener expedientes" });
    }
}
