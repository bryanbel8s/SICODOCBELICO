import { Request, Response } from "express";
import { sicodocDB } from "../db";

export async function getRevisionesPendientes(req: Request, res: Response) {
    const usuario = (req as any).usuario;

    try {
        const result = await sicodocDB.query(
            `SELECT
                r.idrevision,
                r.iddocumento,
                d.tipo,
                (u.nombre || ' ' || u.apellido) AS docente,
                d.fechageneracion,
                r.estado,
                r.comentarios
             FROM revision_documento r
             JOIN documento d ON d.iddocumento = r.iddocumento
             JOIN usuario u ON u.rfc = d.rfc_usuario
             WHERE r.estado = 'En revisión'
               AND r.rfc_director = $1
             ORDER BY d.fechageneracion DESC`,
            [usuario.rfc]
        );

        return res.json(result.rows);
    } catch (error) {
        console.error("Error getRevisionesPendientes:", error);
        return res.status(500).json({ error: "Error al obtener revisiones" });
    }
}

export async function actualizarRevision(req: Request, res: Response) {
    const usuario = (req as any).usuario;
    const { idrevision } = req.params;
    const { estado, comentarios } = req.body;

    if (!estado || !["Aprobado", "Rechazado"].includes(estado)) {
        return res.status(400).json({ error: "Estado inválido" });
    }

    try {
        const upd = await sicodocDB.query(
            `UPDATE revision_documento
             SET estado = $1,
                 comentarios = $2,
                 fecha_revision = NOW()
             WHERE idrevision = $3
               AND rfc_director = $4
             RETURNING *`,
            [estado, comentarios || null, idrevision, usuario.rfc]
        );

        if (upd.rowCount === 0) {
            return res.status(404).json({ error: "Revisión no encontrada" });
        }

        return res.json(upd.rows[0]);
    } catch (error) {
        console.error("Error actualizarRevision:", error);
        return res.status(500).json({ error: "Error al actualizar revisión" });
    }
}
