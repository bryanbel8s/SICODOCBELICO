import { Router } from "express";
import { getPdf } from "../controladores/pdf.ctrl";
import { login } from "../controladores/auth.ctrl";

const router = Router();

router.get("/", (req, res) => {
  res.json({ msg: "SICODOC API funcionando 🔥" });
});

router.post("/login", login);

// Ruta para obtener el PDF por ID
router.get("/get-pdf/:id", getPdf);

export default router;
