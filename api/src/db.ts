import { Pool } from "pg";
import dotenv from "dotenv";
dotenv.config();

// Función segura para obtener host (fix ENOTFOUND)
function safeHost(envValue: string | undefined, fallback: string) {
  if (!envValue || envValue.trim() === "" || envValue.includes("-db")) {
    return fallback; // localhost si no existe host real
  }
  return envValue;
}

// Conexión SICODOC
export const sicodocDB = new Pool({
  host: safeHost(process.env.PG1_HOST, "localhost"),
  port: Number(process.env.PG1_PORT) || 5432,
  user: process.env.PG1_USER,
  password: process.env.PG1_PASS,
  database: process.env.PG1_DB,
});

// Conexión ITC
export const itcDB = new Pool({
  host: safeHost(process.env.PG2_HOST, "localhost"),
  port: Number(process.env.PG2_PORT) || 5432,
  user: process.env.PG2_USER,
  password: process.env.PG2_PASS,
  database: process.env.PG2_DB,
});

// Test SICODOC
sicodocDB.connect()
  .then(() => console.log("🔥 BD SICODOC conectada"))
  .catch(err => {
    console.error("❌ Error SICODOC:");
    console.error("Host:", safeHost(process.env.PG1_HOST, "localhost"));
    console.error(err.message);
  });

// Test ITC
itcDB.connect()
  .then(() => console.log("🔥 BD ITC conectada"))
  .catch(err => {
    console.error("❌ Error ITC:");
    console.error("Host:", safeHost(process.env.PG2_HOST, "localhost"));
    console.error(err.message);
  });
