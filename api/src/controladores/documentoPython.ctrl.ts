import { Request, Response } from "express";
import { sicodocDB } from "../db";
import fetch from "node-fetch";

export async function generarDocumentoPython(req: Request, res: Response) {
    try {
        const { tipo, idexpediente, rfc } = req.body;

        // 1. Mandar datos al servidor Python
        const resp = await fetch("http://localhost:5000/generar-documento", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ tipo, rfc })
        });

        const pdfBuffer = Buffer.from(await resp.arrayBuffer());

        // 2. Guardar documento en BD
        const insert = await sicodocDB.query(
            `INSERT INTO documento (tipo, pdf, idexpediente, rfc_usuario)
             VALUES ($1, $2, $3, $4)
             RETURNING iddocumento`,
            [tipo, pdfBuffer, idexpediente, rfc]
        );

        res.json({ ok: true, iddocumento: insert.rows[0].iddocumento });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Error generando documento" });
    }
}
