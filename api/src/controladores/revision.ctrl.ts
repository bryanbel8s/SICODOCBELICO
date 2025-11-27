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

// ==============================
// 1) Lista de revisiones pendientes
//    GET /revisiones/pendientes
// ==============================
export async function getRevisionesPendientes(
  req: UsuarioRequest,
  res: Response
) {
  try {
    if (!req.usuario) {
      return res.status(401).json({ error: "No autenticado" });
    }

    const rfcDirector = req.usuario.rfc;

    const result = await sicodocDB.query(
      `
      SELECT
        r.idrevision,
        r.iddocumento,
        d.tipo,
        d.fechageneracion,
        r.estado,
        r.comentarios,
        (u.nombre || ' ' || u.apellido) AS docente
      FROM revision_documento r
      JOIN documento d ON d.iddocumento = r.iddocumento
      JOIN usuario u   ON u.rfc = d.rfc_usuario
      WHERE r.rfc_director = $1
        AND r.estado = 'En revisión'
      ORDER BY d.fechageneracion DESC
      `,
      [rfcDirector]
    );

    return res.json(result.rows);
  } catch (err) {
    console.error("Error getRevisionesPendientes:", err);
    return res
      .status(500)
      .json({ error: "Error interno al obtener revisiones pendientes" });
  }
}

// ==============================
// 2) Detalle de una revisión
//    GET /revisiones/detalle/:id
// ==============================
export async function getDetalleRevision(
  req: UsuarioRequest,
  res: Response
) {
  try {
    if (!req.usuario) {
      return res.status(401).json({ error: "No autenticado" });
    }

    const rfcDirector = req.usuario.rfc;
    const idrevision = parseInt(req.params.id, 10);

    if (isNaN(idrevision)) {
      return res.status(400).json({ error: "ID de revisión inválido" });
    }

    const result = await sicodocDB.query(
      `
      SELECT
        r.idrevision,
        r.iddocumento,
        d.tipo,
        d.fechageneracion,
        r.estado,
        r.comentarios,
        (u.nombre || ' ' || u.apellido) AS docente
      FROM revision_documento r
      JOIN documento d ON d.iddocumento = r.iddocumento
      JOIN usuario u   ON u.rfc = d.rfc_usuario
      WHERE r.idrevision = $1
        AND r.rfc_director = $2
      `,
      [idrevision, rfcDirector]
    );

    if (!result.rowCount) {
      return res.status(404).json({ error: "Revisión no encontrada" });
    }

    const row = result.rows[0];
    return res.json({
      ...row,
      docName: row.tipo,
      origen: "sicodoc", // para usar con /documentos/pdf/sicodoc/:id
    });
  } catch (err) {
    console.error("Error getDetalleRevision:", err);
    return res
      .status(500)
      .json({ error: "Error interno al obtener detalle de revisión" });
  }
}

// ==============================
// 3) Decidir sobre la revisión
//    POST /revisiones/:id
//    body: { estado: 'Aprobado' | 'Rechazado', comentarios? }
// ==============================
export async function decidirRevision(
  req: UsuarioRequest,
  res: Response
) {
  const client = await sicodocDB.connect();

  try {
    if (!req.usuario) {
      client.release();
      return res.status(401).json({ error: "No autenticado" });
    }

    const rfcDirector = req.usuario.rfc;
    const idrevision = parseInt(req.params.id, 10);
    const { estado, comentarios } = req.body as {
      estado?: string;
      comentarios?: string;
    };

    if (isNaN(idrevision)) {
      client.release();
      return res.status(400).json({ error: "ID de revisión inválido" });
    }

    if (!estado || !["Aprobado", "Rechazado"].includes(estado)) {
      client.release();
      return res
        .status(400)
        .json({ error: "Estado debe ser 'Aprobado' o 'Rechazado'" });
    }

    await client.query("BEGIN");

    const revRes = await client.query(
      `
      SELECT idrevision, iddocumento, rfc_director, estado
      FROM revision_documento
      WHERE idrevision = $1
      FOR UPDATE
      `,
      [idrevision]
    );

    if (!revRes.rowCount) {
      await client.query("ROLLBACK");
      client.release();
      return res.status(404).json({ error: "Revisión no encontrada" });
    }

    const rev = revRes.rows[0];

    if (rev.rfc_director !== rfcDirector) {
      await client.query("ROLLBACK");
      client.release();
      return res
        .status(403)
        .json({ error: "No puedes modificar revisiones de otro director" });
    }

    // Actualizamos la revisión
    await client.query(
      `
      UPDATE revision_documento
      SET estado = $1,
          comentarios = $2,
          fecha_revision = NOW()
      WHERE idrevision = $3
      `,
      [estado, comentarios || null, idrevision]
    );

    let ruta_pdf: string | null = null;

    if (estado === "Aprobado") {
      const idDocSicodoc: number = rev.iddocumento;

      // Llamamos al microservicio Python para re-generar el PDF (ya con QR, firmas, etc.)
      const resp = await fetch("http://localhost:5001/generar-pdf", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ id_doc_sicodoc: idDocSicodoc }),
      });

      const data = (await resp.json()) as any;

      if (!resp.ok || !data.ok) {
        console.error("Error Python al firmar:", data);
        await client.query("ROLLBACK");
        client.release();
        return res
          .status(500)
          .json({ error: data.error || "No se pudo regenerar el PDF" });
      }

      ruta_pdf = data.ruta_pdf;

      // Guardamos nueva ruta en documento
      await client.query(
        `
        UPDATE documento
        SET pdf_path = $1
        WHERE iddocumento = $2
        `,
        [ruta_pdf, idDocSicodoc]
      );
    }

    await client.query("COMMIT");
    client.release();

    return res.json({
      ok: true,
      estado,
      ruta_pdf,
    });
  } catch (err) {
    console.error("Error decidirRevision:", err);
    try {
      await client.query("ROLLBACK");
    } catch {}
    client.release();
    return res
      .status(500)
      .json({ error: "Error interno al decidir sobre la revisión" });
  }
}
