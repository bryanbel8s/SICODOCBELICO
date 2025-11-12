import express from "express";
import cors from "cors";
import pdfRoutes from "./rutas/pdf.ruta";

const app = express();
const PORT = 3000;

// Middlewares
app.use(cors());
app.use(express.json());

// Rutas principales
app.use("/api", pdfRoutes);

// Servidor
app.listen(PORT, () => {
    console.log(`✅ Backend de SICODOC ejecutándose en http://localhost:${PORT}`);
});
