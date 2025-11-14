import { Router } from "express";
import { login } from "../controladores/auth.ctrl.js";

const router = Router();

router.post("/login", login);

export default router;
