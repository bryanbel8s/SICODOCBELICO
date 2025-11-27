import { Router } from "express";
import { login } from "../controladores/auth.ctrl";
import {
  getPDF,
  limpiarPdfsDocente,
} from "../controladores/documento.ctrl";
import {
  getDashboardDocente,
  generarPdfDocente,
} from "../controladores/docente.ctrl";
import {
  getRevisionesPendientes,
  getDetalleRevision,
  decidirRevision,
} from "../controladores/revision.ctrl";
import { requireAuth, requireRoles } from "../middlewares/auth.middleware";

const router = Router();

router.get("/", (_req, res) =>
  res.json({ msg: "SICODOC API funcionando 🔥" })
);

// =============
// AUTH
// =============
router.post("/auth/login", login);

// =============
// DOCENTE
// =============
router.get(
  "/docente/dashboard",
  requireAuth,
  requireRoles("Docente"),
  getDashboardDocente
);

router.post(
  "/docente/documentos/:id/generar",
  requireAuth,
  requireRoles("Docente"),
  generarPdfDocente
);

// Borrar PDFs temporales al cerrar sesión
router.post(
  "/docente/limpiar-pdfs",
  requireAuth,
  requireRoles("Docente"),
  limpiarPdfsDocente
);

// =============
// DIRECTOR (REVISIÓN)
// =============
router.get(
  "/revisiones/pendientes",
  requireAuth,
  requireRoles("Director"),
  getRevisionesPendientes
);

router.get(
  "/revisiones/detalle/:id",
  requireAuth,
  requireRoles("Director"),
  getDetalleRevision
);

router.post(
  "/revisiones/:id",
  requireAuth,
  requireRoles("Director"),
  decidirRevision
);

// =============
// PDF
// =============
router.get(
  "/documentos/pdf/:origen/:id",
  requireAuth,
  getPDF
);

export default router;
