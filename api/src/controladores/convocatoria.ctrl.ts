import { Request, Response } from "express";
import { sicodocDB } from "../db";

export async function getConvocatoriasActivas(req: Request, res: Response) {
    try {
        const result = await sicodocDB.query(
            `SELECT 
                idconvocatoria,
                nombre,
                fechainicioregistro,
                fechafinregistro,
                fechainicioevaluacion,
                fechafinevaluacion,
                fecha_pub
             FROM convocatoria
             WHERE fechainicioregistro <= CURRENT_DATE
               AND fechafinregistro >= CURRENT_DATE
             ORDER BY fechainicioregistro DESC`
        );

        return res.json(result.rows);
    } catch (error) {
        console.error("Error getConvocatoriasActivas:", error);
        return res.status(500).json({ error: "Error al obtener convocatorias" });
    }
}
