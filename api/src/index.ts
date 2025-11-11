import express from 'express';
import cors from 'cors';
import path from 'path';
import { google } from 'googleapis';
// (Si estás usando ES Modules nativo, necesitarás __dirname)
import { fileURLToPath } from 'url';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// --- Configuración Inicial ---
const app = express();
const PORT = 3000;
const CREDENTIALS_PATH = path.join(__dirname, '..', 'credentials.json');

// 1. Habilitar CORS
app.use(cors()); // Permite que http://127.0.0.1:5500 hable con http://localhost:3000

// 2. Mapa de Plantillas
// ▼▼▼ CORRECCIÓN 1: Añadimos un tipo explícito al mapa ▼▼▼
// Le decimos a TypeScript que este objeto será indexado por CUALQUIER string
// y que el valor también será un string. Esto soluciona el error TS7053.
const plantillaMap: { [key: string]: string } = {
    // ¡Aquí pones los IDs reales de tus archivos en Google Drive!
    "2.3.4.1": "1mjWkwzUwN1RFmjaLc4V2AupgF8FzyE3K",
    "1.4.1":   "1DTdO290h26KBzQtVoHndXnbyknRemLaN",
    "1.1.5.1": "1FCfV_cXUEfeO2EDYuARgrjwSbWy8ezAa",
    "1.2.1.2": "1FIv__C44OUXNIvEc1vLoItOgvZcUxAy8"
};

// 3. Autenticación de Google Drive
const auth = new google.auth.GoogleAuth({
    keyFile: CREDENTIALS_PATH,
    scopes: ['https://www.googleapis.com/auth/drive.readonly'],
});

const drive = google.drive({ version: 'v3', auth });

// 4. El Endpoint de la API
app.get('/api/get-pdf/:id', async (req, res) => {
    try {
        const docId = req.params.id;
        
        // (La línea 38 ahora funciona gracias a la Corrección 1)
        const fileId = plantillaMap[docId]; // Busca el ID de GDrive en el mapa

        if (!fileId) {
            return res.status(404).send('ID de documento no encontrado en el mapa del servidor.');
        }

        console.log(`Petición recibida para docId: ${docId}, GDrive fileId: ${fileId}`);

        // 5. Pide el archivo a Google Drive
        const fileResponse = await drive.files.get(
            { fileId: fileId, alt: 'media' },
            { responseType: 'stream' }
        );

        // 6. Envía el archivo PDF de regreso al frontend
        res.setHeader('Content-Type', 'application/pdf');
        fileResponse.data.pipe(res);

    } catch (error) {
        // ▼▼▼ CORRECCIÓN 2: Comprobamos el tipo de 'error' ▼▼▼
        // TypeScript no sabe si 'error' es un objeto Error o un simple string.
        // Hacemos una comprobación para que sepa que '.message' existe.
        // Esto soluciona el error TS18046.
        if (error instanceof Error) {
            console.error("Error al obtener el archivo de Google Drive:", error.message);
        } else {
            console.error("Error desconocido en GDrive:", error);
        }
        res.status(500).send('Error en el servidor al obtener el archivo.');
    }
});

// 7. Inicia el servidor
app.listen(PORT, () => {
    console.log(`Backend de SICODOC iniciado en http://localhost:${PORT}`);
});