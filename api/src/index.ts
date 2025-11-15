import express from "express";
import morgan from "morgan";
import cors from "cors";
import dotenv from "dotenv";
import rutas from "./rutas/api.router";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());
app.use(morgan("dev"));

app.use("/api", rutas);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 SICODOC API corriendo en puerto ${PORT}`);
});
