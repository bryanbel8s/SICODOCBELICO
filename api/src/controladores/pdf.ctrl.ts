import { Request, Response } from "express";
import { drive } from "../utils/googleDrive.js";

// Mapa de IDs de documentos
const plantillaMap: Record<string, string> = {
    "2.3.4.1": "1mjWkwzUwN1RFmjaLc4V2AupgF8FzyE3K",
    "1.4.1": "1DTdO290h26KBzQtVoHndXnbyknRemLaN",
    "1.1.5.1": "1FCfV_cXUEfeO2EDYuARgrjwSbWy8ezAa",
    "1.2.1.2": "1FIv__C44OUXNIvEc1vLoItOgvZcUxAy8",
};

// Controlador para obtener PDF desde Google Drive
export async function getPdf(req: Request, res: Response) {
    try {
        const docId = req.params.id;
        const fileId = plantillaMap[docId];

        if (!fileId) {
            return res.status(404).send("ID de documento no encontrado en el mapa del servidor.");
        }

        console.log(`Petición recibida para docId: ${docId}, fileId: ${fileId}`);

        const fileResponse = await drive.files.get(
            { fileId, alt: "media" },
            { responseType: "stream" }
        );

        res.setHeader("Content-Type", "application/pdf");
        fileResponse.data.pipe(res);
    } catch (error) {
        console.error("Error al obtener el archivo de Google Drive:", error);
        res.status(500).send("Error en el servidor al obtener el archivo.");
    }
}
