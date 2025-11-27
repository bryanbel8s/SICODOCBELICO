import { Pool } from "pg";
import dotenv from "dotenv";
dotenv.config();

console.log("🛠 Configuración cargada:");
console.log({
  PG1_HOST: process.env.PG1_HOST,
  PG1_PORT: process.env.PG1_PORT,
  PG1_DB: process.env.PG1_DB,
  PG2_HOST: process.env.PG2_HOST,
  PG2_PORT: process.env.PG2_PORT,
  PG2_DB: process.env.PG2_DB,
});

// Conexión SICODOC
export const sicodocDB = new Pool({
  host: process.env.PG1_HOST,
  port: Number(process.env.PG1_PORT),
  user: process.env.PG1_USER,
  password: process.env.PG1_PASS,
  database: process.env.PG1_DB,
});

// Conexión ITC
export const itcDB = new Pool({
  host: process.env.PG2_HOST,
  port: Number(process.env.PG2_PORT),
  user: process.env.PG2_USER,
  password: process.env.PG2_PASS,
  database: process.env.PG2_DB,
});

// ---- TEST CONEXIONES ----

sicodocDB.connect()
  .then(() => console.log("🔥 BD SICODOC conectada"))
  .catch(err => console.error("❌ Error SICODOC:", err.message));

itcDB.connect()
  .then(() => console.log("🔥 BD ITC conectada"))
  .catch(err => console.error("❌ Error ITC:", err.message));
