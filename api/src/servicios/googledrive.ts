import path from "path";
import { google } from "googleapis";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Ruta a las credenciales de Google
const CREDENTIALS_PATH = path.join(__dirname, "..", "credentials.json");

const auth = new google.auth.GoogleAuth({
    keyFile: CREDENTIALS_PATH,
    scopes: ["https://www.googleapis.com/auth/drive.readonly"],
});

export const drive = google.drive({ version: "v3", auth });
