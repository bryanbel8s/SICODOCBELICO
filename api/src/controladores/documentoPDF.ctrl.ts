export async function getPDF(req, res) {
    try {
        const { id } = req.params;

        const pdf = await sicodocDB.query(
            `SELECT pdf FROM documento WHERE iddocumento = $1`,
            [id]
        );

        if (pdf.rowCount === 0) return res.status(404).end();

        res.setHeader("Content-Type", "application/pdf");
        res.send(pdf.rows[0].pdf);

    } catch (e) {
        res.status(500).json({ error: "Error obteniendo PDF" });
    }
}
