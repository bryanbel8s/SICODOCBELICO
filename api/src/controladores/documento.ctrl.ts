// ======================
//  DOCUMENTO.CONTROLADOR
// ======================

import { Request, Response } from "express";
import { sicodocDB } from "../db";
import path from "path";
import fs from "fs";

// Payload del JWT
interface UsuarioJWT {
  rfc: string;
  nombre: string;
  apellido: string;
  rol: string;
  idrol: number;
}

interface UsuarioRequest extends Request {
  usuario?: UsuarioJWT;
}

// ==================================
// 1) Servir un PDF por iddocumento
//    GET /documentos/pdf/:origen/:id
// ==================================
export async function getPDF(req: UsuarioRequest, res: Response) {
  try {
    const id = parseInt(req.params.id, 10);

    if (isNaN(id)) {
      return res.status(400).json({ error: "ID de documento inválido" });
    }

    const result = await sicodocDB.query(
      `SELECT pdf_path FROM documento WHERE iddocumento = $1`,
      [id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: "Documento no encontrado" });
    }

    const pdfPath: string | null = result.rows[0].pdf_path;

    if (!pdfPath) {
      return res
        .status(404)
        .json({ error: "El documento no tiene PDF generado todavía" });
    }

    const rutaAbsoluta = path.isAbsolute(pdfPath)
      ? pdfPath
      : path.join(__dirname, "..", "generadocs", pdfPath);

    if (!fs.existsSync(rutaAbsoluta)) {
      return res.status(404).json({ error: "Archivo PDF no existe en disco" });
    }

    return res.sendFile(rutaAbsoluta);
  } catch (err) {
    console.error("Error getPDF:", err);
    return res.status(500).json({ error: "Error interno al obtener PDF" });
  }
}

// ================================================
// 2) Borrar todos los PDFs del docente al salir
//    POST /docente/limpiar-pdfs
// ================================================
export async function limpiarPdfsDocente(
  req: UsuarioRequest,
  res: Response
) {
  try {
    if (!req.usuario) {
      return res.status(401).json({ error: "No autenticado" });
    }

    const { rfc } = req.usuario;

    // Traemos todas las rutas de PDF de ese docente
    const result = await sicodocDB.query(
      `
      SELECT pdf_path
      FROM documento
      WHERE rfc_usuario = $1
        AND pdf_path IS NOT NULL
      `,
      [rfc]
    );

    let borrados = 0;

    for (const row of result.rows) {
      const pdfPath: string = row.pdf_path;
      const rutaAbsoluta = path.isAbsolute(pdfPath)
        ? pdfPath
        : path.join(__dirname, "..", "generadocs", pdfPath);

      try {
        if (fs.existsSync(rutaAbsoluta)) {
          fs.unlinkSync(rutaAbsoluta);
          borrados++;
        }
      } catch (e) {
        console.warn("No se pudo borrar:", rutaAbsoluta, e);
      }
    }

    // Limpiamos la columna pdf_path para que ya no apunte a nada
    await sicodocDB.query(
      `UPDATE documento SET pdf_path = NULL WHERE rfc_usuario = $1`,
      [rfc]
    );

    return res.json({ ok: true, borrados });
  } catch (err) {
    console.error("Error limpiarPdfsDocente:", err);
    return res
      .status(500)
      .json({ error: "Error interno al limpiar PDFs del docente" });
  }
}
