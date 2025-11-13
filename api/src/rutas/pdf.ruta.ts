import express from "express";
import { getPdf } from "../controladores/pdf.ctrl.js";

const router = express.Router();

// Ruta para obtener el PDF por ID
router.get("/get-pdf/:id", getPdf);

export default router;
