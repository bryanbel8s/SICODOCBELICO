import { Request, Response } from "express";
import { sicodocDB } from "../db";
import fetch from "node-fetch";

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

// Helper para obtener o crear expediente del docente
async function obtenerOCrearExpediente(rfc: string) {
  // 1) Buscamos el expediente más reciente del docente
  const existente = await sicodocDB.query(
    `
    SELECT 
      e.idexpediente,
      e.estado,
      e.fechacreacion,
      c.idconvocatoria,
      c.nombre AS nombre_convocatoria,
      c.fecha_pub
    FROM expediente e
    JOIN convocatoria c ON c.idconvocatoria = e.idconvocatoria
    WHERE e.rfc_usuario = $1
    ORDER BY c.fecha_pub DESC, e.fechacreacion DESC
    LIMIT 1
    `,
    [rfc]
  );

  if (existente.rowCount > 0) {
    return existente.rows[0];
  }

  // 2) Si no hay expediente, creamos uno con la última convocatoria
  const conv = await sicodocDB.query(
    `
    SELECT idconvocatoria, nombre, fecha_pub
    FROM convocatoria
    ORDER BY fecha_pub DESC
    LIMIT 1
    `
  );

  if (!conv.rowCount) {
    throw new Error("No hay convocatorias en la BD");
  }

  const c = conv.rows[0];

  const nuevoExp = await sicodocDB.query(
    `
    INSERT INTO expediente (estado, rfc_usuario, idconvocatoria)
    VALUES ('En captura', $1, $2)
    RETURNING idexpediente, estado, fechacreacion
    `,
    [rfc, c.idconvocatoria]
  );

  return {
    ...nuevoExp.rows[0],
    idconvocatoria: c.idconvocatoria,
    nombre_convocatoria: c.nombre,
    fecha_pub: c.fecha_pub,
  };
}

// =======================
// 1) GET /docente/dashboard
// =======================
export async function getDashboardDocente(
  req: UsuarioRequest,
  res: Response
) {
  try {
    if (!req.usuario) {
      return res.status(401).json({ error: "No autenticado" });
    }

    const { rfc, nombre, apellido, rol, idrol } = req.usuario;

    // Expediente
    const expediente = await obtenerOCrearExpediente(rfc);

    // Tipos de documento SPD + si cumple (tiene evidencia en v_spd_documentos_itc)
    const docs = await sicodocDB.query(
      `
      SELECT
        td.id_tipo_doc,
        td.nombre_doc,
        td.descripcion,
        td.plantilla_archivo,
        td.requiere_firmas,
        td.num_firmas,
        EXISTS (
          SELECT 1
          FROM v_spd_documentos_itc v
          WHERE v.rfc_docente_spd = $1
            AND v.id_tipo_doc = td.id_tipo_doc
        ) AS cumple
      FROM v_spd_tipos_documento td
      ORDER BY td.id_tipo_doc
      `,
      [rfc]
    );

    return res.json({
      ok: true,
      docente: { rfc, nombre, apellido, rol, idrol },
      expediente,
      documentos: docs.rows,
    });
  } catch (err: any) {
    console.error("Error getDashboardDocente:", err);
    return res.status(500).json({ error: "Error interno al obtener dashboard" });
  }
}

// =======================
// 2) POST /docente/documentos/:id/generar
// =======================
export async function generarPdfDocente(
  req: UsuarioRequest,
  res: Response
) {
  try {
    if (!req.usuario) {
      return res.status(401).json({ error: "No autenticado" });
    }

    const { rfc } = req.usuario;
    const idTipoDoc = parseInt(req.params.id, 10);

    if (isNaN(idTipoDoc)) {
      return res.status(400).json({ error: "id de tipo de documento inválido" });
    }

    // Verificamos que el tipo de documento exista en v_spd_tipos_documento
    const tipoRes = await sicodocDB.query(
      `
      SELECT id_tipo_doc, nombre_doc
      FROM v_spd_tipos_documento
      WHERE id_tipo_doc = $1
      `,
      [idTipoDoc]
    );

    if (!tipoRes.rowCount) {
      return res.status(404).json({ error: "Tipo de documento SPD no encontrado" });
    }

    const tipoDoc = tipoRes.rows[0] as {
      id_tipo_doc: number;
      nombre_doc: string;
    };

    // Obtenemos / creamos expediente
    const expediente = await obtenerOCrearExpediente(rfc);

    // 1) Insertamos registro en documento (SICODOC)
    const insDoc = await sicodocDB.query(
      `
      INSERT INTO documento (tipo, rfc_usuario, idexpediente, estado)
      VALUES ($1, $2, $3, 'En captura')
      RETURNING iddocumento
      `,
      [tipoDoc.nombre_doc, rfc, expediente.idexpediente]
    );

    const idDocSicodoc: number = insDoc.rows[0].iddocumento;

    // 2) Creamos el documento en ITC vía función FDW
    const crearRes = await sicodocDB.query(
      `SELECT f_crear_doc_itc_desde_sicodoc($1) AS id_doc_itc`,
      [idDocSicodoc]
    );

    const idDocItc: number | null = crearRes.rows[0]?.id_doc_itc ?? null;

    // 3) Si es 1.1.0 - Constancia de Situación Laboral, llenamos campos automáticamente
    if (tipoDoc.nombre_doc.startsWith("1.1.0")) {
      try {
        await sicodocDB.query(
          `SELECT f_llenar_constancia_laboral($1)`,
          [idDocItc]
        );
      } catch (err) {
        console.warn("Advertencia llenando constancia laboral:", err);
      }
    }

    // 4) Llamamos al microservicio de Python para generar el PDF
    const resp = await fetch("http://localhost:5001/generar-pdf", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ id_doc_sicodoc: idDocSicodoc }),
    });

    const data = await resp.json() as any;

    if (!resp.ok || !data.ok) {
      console.error("Python respondió error:", data);
      return res
        .status(500)
        .json({ error: data.error || "No se pudo generar el PDF" });
    }

    const rutaPdfFS: string = data.ruta_pdf;

    // 5) Guardamos la ruta en documento.pdf_path
    await sicodocDB.query(
      `
      UPDATE documento
      SET pdf_path = $1,
          estado = 'Generado'
      WHERE iddocumento = $2
      `,
      [rutaPdfFS, idDocSicodoc]
    );

    // 6) Devolvemos el id para que el front use /documentos/pdf/sicodoc/:id
    return res.json({
      ok: true,
      iddocumento: idDocSicodoc,
    });
  } catch (err: any) {
    console.error("Error generarPdfDocente:", err);
    return res.status(500).json({ error: "Error interno al generar PDF" });
  }
}
