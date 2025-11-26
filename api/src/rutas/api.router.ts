import { Router } from "express";
import { login } from "../controladores/auth.ctrl";
import { getConvocatoriasActivas } from "../controladores/convocatoria.ctrl";
import { crearExpediente, getMisExpedientes } from "../controladores/expediente.ctrl";
import { 
    documentoExiste,
    generarDocumento,
    getPDF,
    getMisDocumentos
} from "../controladores/documento.ctrl";
import { getRevisionesPendientes, actualizarRevision } from "../controladores/revision.ctrl";
import { requireAuth, requireRoles } from "../middlewares/auth.middleware";

const router = Router();

router.get("/", (req, res) => res.json({ msg: "SICODOC API funcionando 🔥" }));

// Auth
router.post("/auth/login", login);

// Convocatorias
router.get("/convocatorias/activas", requireAuth, getConvocatoriasActivas);

// Expedientes
router.get("/expedientes/mis", requireAuth, getMisExpedientes);
router.post("/expedientes", requireAuth, crearExpediente);

// Documentos
router.get("/documentos/mis", requireAuth, getMisDocumentos);
router.get("/documentos/existe", requireAuth, documentoExiste);
router.post("/documentos/generar", requireAuth, generarDocumento);

// Nueva ruta correcta para PDF
router.get("/documentos/pdf/:origen/:id", requireAuth, getPDF);

// Directivos
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
