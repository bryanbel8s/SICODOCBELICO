import { Router } from "express";
import { login } from "../controladores/auth.ctrl";
import { getConvocatoriasActivas } from "../controladores/convocatoria.ctrl";
import { crearExpediente, getMisExpedientes } from "../controladores/expediente.ctrl";
import { crearDocumento, getMisDocumentos } from "../controladores/documento.ctrl";
import { getRevisionesPendientes, actualizarRevision } from "../controladores/revision.ctrl";
import { requireAuth, requireRoles } from "../middlewares/auth.middleware";
import { generarDocumentoPython } from "../controladores/documentoPython.ctrl";
import { getPDF } from "../controladores/documentoPDF.ctrl";




const router = Router();

router.get("/", (req, res) => {
  res.json({ msg: "SICODOC API funcionando 🔥" });
});

// Auth
router.post("/auth/login", login);

// Docente
router.get("/convocatorias/activas", requireAuth, getConvocatoriasActivas);

router.get("/expedientes/mis", requireAuth, getMisExpedientes);
router.post("/expedientes", requireAuth, crearExpediente);

router.get("/documentos/mis", requireAuth, getMisDocumentos);
router.post("/documentos", requireAuth, crearDocumento);

router.post("/documentos/generar", requireAuth, generarDocumentoPython);
router.get("/documentos/pdf/:id", requireAuth, getPDF);

// Directivos: Director / Subdirector / Jefe de Departamento
const ROLES_DIRECTIVOS = ["Director", "Subdirector", "Jefe de Departamento"];

router.get(
  "/revisiones/pendientes",
  requireAuth,
  requireRoles(...ROLES_DIRECTIVOS),
  getRevisionesPendientes
);

router.post(
  "/revisiones/:idrevision",
  requireAuth,
  requireRoles(...ROLES_DIRECTIVOS),
  actualizarRevision
);

export default router;
