import { Request, Response } from "express";
import { sicodocDB } from "../db";

export async function crearDocumento(req: Request, res: Response) {
    const { tipo, idexpediente } = req.body;
    const usuario = (req as any).usuario;

    if (!tipo || !idexpediente) {
        return res.status(400).json({ error: "Faltan datos (tipo, idexpediente)" });
    }

    try {
        const exp = await sicodocDB.query(
            `SELECT idexpediente
             FROM expediente
             WHERE idexpediente = $1
               AND rfc_usuario = $2`,
            [idexpediente, usuario.rfc]
        );

        if (exp.rowCount === 0) {
            return res.status(404).json({ error: "Expediente no encontrado" });
        }

        const insert = await sicodocDB.query(
            `INSERT INTO documento (tipo, rfc_usuario, idexpediente)
             VALUES ($1, $2, $3)
             RETURNING *`,
            [tipo, usuario.rfc, idexpediente]
        );

        return res.status(201).json(insert.rows[0]);

    } catch (error) {
        console.error("Error crearDocumento:", error);
        return res.status(500).json({ error: "Error al crear documento" });
    }
}

export async function getMisDocumentos(req: Request, res: Response) {
    const usuario = (req as any).usuario;

    try {
        const docs = await sicodocDB.query(
            `SELECT *
             FROM v_documentos_docente
             WHERE rfc_docente = $1
             ORDER BY fechageneracion DESC`,
            [usuario.rfc]
        );

        return res.json(docs.rows);
    } catch (error) {
        console.error("Error getMisDocumentos:", error);
        return res.status(500).json({ error: "Error al obtener documentos" });
    }
}
