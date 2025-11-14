import express from "express";
import cors from "cors";

import pdfRouter from "./rutas/pdf.ruta.js";
import authRouter from "./rutas/auth.ruta.js";

const app = express();

app.use(cors());
app.use(express.json());

// rutas
app.use("/api/pdf", pdfRouter);
app.use("/api/auth", authRouter);

const PORT = 3000;
app.listen(PORT, () => console.log("API en puerto", PORT));
