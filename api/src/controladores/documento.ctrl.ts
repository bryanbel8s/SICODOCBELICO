import { Request, Response } from "express";
import { sicodocDB, itculiacanDB } from "../db";
import fetch from "node-fetch";

// ======================================================
// 1) LISTAR TODOS LOS DOCUMENTOS DEL DOCENTE
// ======================================================
export async function getMisDocumentos(req: Request, res: Response) {
    try {
        const rfc = (req as any).user?.rfc;

        if (!rfc)
            return res.status(401).json({ error: "Token inválido" });

        // 1) DOCUMENTOS GENERADOS EN SICODOC (PDF guardado directamente)
        const docsSicodoc = await sicodocDB.query(
            `SELECT 
                iddocumento AS id,
                tipo,
                fechageneracion AS fecha,
                estado,
                'sicodoc' AS origen
            FROM documento 
            WHERE rfc_usuario = $1
            ORDER BY fechageneracion DESC`,
            [rfc]
        );

        // 2) DOCUMENTOS YA EXISTENTES EN ITCULIACAN
        const docsItc = await itculiacanDB.query(
            `SELECT 
                id_documento AS id,
                id_tipo_doc AS tipo,
                fecha_creacion AS fecha,
                estado,
                'itculiacan' AS origen
             FROM documentos_generados
             WHERE id_docente = (
                SELECT id_personal 
                FROM recursos_humanos 
                WHERE rfc = $1
             )
             ORDER BY fecha_creacion DESC`,
            [rfc]
        );

        // Unir los dos resultados
        const total = [...docsSicodoc.rows, ...docsItc.rows];

        return res.json(total);

    } catch (error) {
        console.log(error);
        return res.status(500).json({ error: "Error obteniendo documentos" });
    }
}

// ======================================================
// 2) GENERAR DOCUMENTO (PDF desde Python)
// ======================================================
export async function generarDocumento(req: Request, res: Response) {
    try {
        const { tipo, idexpediente, rfc } = req.body;

        const usuario = await sicodocDB.query(
            `SELECT nombre, apellido FROM usuario WHERE rfc=$1`,
            [rfc]
        );

        if (usuario.rowCount === 0)
            return res.status(404).json({ error: "Docente no encontrado" });

        const docente = usuario.rows[0];

        const respuesta = await fetch("http://127.0.0.1:5000/generar-documento", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                tipo,
                rfc,
                nombre: docente.nombre,
                apellido: docente.apellido
            })
        });

        if (!respuesta.ok) {
            console.log(await respuesta.text());
            return res.status(500).json({ error: "Error generando PDF en Python" });
        }

        const pdfBuffer = Buffer.from(await respuesta.arrayBuffer());

        // Guardar en BD del SICODOC
        const insert = await sicodocDB.query(
            `INSERT INTO documento (tipo, pdf, idexpediente, rfc_usuario, fechageneracion, estado)
             VALUES ($1,$2,$3,$4,NOW(),'En revisión')
             RETURNING iddocumento`,
            [tipo, pdfBuffer, idexpediente, rfc]
        );

        return res.json({
            ok: true,
            iddocumento: insert.rows[0].iddocumento
        });

    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: "Error generando documento" });
    }
}

// ======================================================
// 3) DESCARGAR PDF (FUNCIONA PARA SICODOC + ITC)
// ======================================================
export async function getPDF(req: Request, res: Response) {
    try {
        const { origen, id } = req.params;

        // ------------------------------------
        // 1) ORIGEN: SICODOC
        // ------------------------------------
        if (origen === "sicodoc") {
            const result = await sicodocDB.query(
                `SELECT pdf FROM documento WHERE iddocumento=$1`,
                [id]
            );

            if (result.rowCount === 0)
                return res.status(404).end();

            res.setHeader("Content-Type", "application/pdf");
            return res.send(result.rows[0].pdf);
        }

        // ------------------------------------
        // 2) ORIGEN: ITCULIACAN
        // ------------------------------------
        if (origen === "itculiacan") {
            const result = await itculiacanDB.query(
                `SELECT archivo_final FROM documentos_generados WHERE id_documento=$1`,
                [id]
            );

            if (result.rowCount === 0)
                return res.status(404).end();

            const ruta = result.rows[0].archivo_final;

            res.setHeader("Content-Type", "application/pdf");
            return res.sendFile(ruta);
        }

        return res.status(400).json({ error: "Origen inválido" });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ error: "Error obteniendo PDF" });
    }
}
