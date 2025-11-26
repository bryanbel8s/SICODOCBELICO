CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Conéctate a la BD sicodoc

-- 1. Extensión FDW
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- 2. SERVER que apunta a la BD itculiacan
DROP SERVER IF EXISTS itculiacan_server CASCADE;

CREATE SERVER itculiacan_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (
  host 'localhost',      -- cambia si tu server no es local
  dbname 'itculiacan',   -- NOMBRE EXACTO de la BD que mostraste en la foto
  port '5432'
);

-- 3. USER MAPPING (ajusta user/password)
CREATE USER MAPPING IF NOT EXISTS FOR sicodoc_user
SERVER itculiacan_server
OPTIONS (
  user 'sicodoc_user',       -- usuario que tiene acceso a itculiacan
  password 'SicodocPass123'
);

-- 4. Schema para las foreign tables
CREATE SCHEMA IF NOT EXISTS itculiacan_fdw;

-- 5. Importar las tablas necesarias desde itculiacan
IMPORT FOREIGN SCHEMA public
LIMIT TO (
  personal,
  recursos_humanos,
  categorias_edd,
  tipos_documento,
  campos_documento,
  documentos_generados,
  valores_documento
)
FROM SERVER itculiacan_server
INTO itculiacan_fdw;


-- ==========================================
--               TABLA ROL
-- ==========================================
CREATE TABLE rol (
  idrol SERIAL PRIMARY KEY,
  nombrerol VARCHAR(100) NOT NULL UNIQUE
);

-- ==========================================
--               TABLA USUARIO
-- ==========================================
CREATE TABLE usuario (
  rfc VARCHAR(13) PRIMARY KEY
      CHECK (LENGTH(rfc) = 13 AND rfc ~ '^[A-Z0-9]+$'),
  nombre VARCHAR(255) NOT NULL,
  apellido VARCHAR(255) NOT NULL,
  correo VARCHAR(255) NOT NULL UNIQUE
      CHECK (correo LIKE '%@%.%'),
  contrasena_hash TEXT NOT NULL,
  firma_digital BYTEA,
  idrol INT NOT NULL,
  FOREIGN KEY (idrol) REFERENCES rol(idrol)
);

-- ==========================================
--               TABLA CONVOCATORIA
-- ==========================================
CREATE TABLE convocatoria (
  idconvocatoria SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  fechainicioregistro DATE NOT NULL,
  fechafinregistro DATE NOT NULL,
  fechainicioevaluacion DATE NOT NULL,
  fechafinevaluacion DATE NOT NULL,
  fecha_pub DATE NOT NULL
);

-- ==========================================
--               TABLA EXPEDIENTE
-- ==========================================
CREATE TABLE expediente (
  idexpediente SERIAL PRIMARY KEY,
  estado VARCHAR(100) NOT NULL,
  rfc_usuario VARCHAR(13) NOT NULL,
  idconvocatoria INT NOT NULL,
  fechacreacion TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY (rfc_usuario) REFERENCES usuario(rfc),
  FOREIGN KEY (idconvocatoria) REFERENCES convocatoria(idconvocatoria)
);

-- ==========================================
--               TABLA DOCUMENTO
-- ==========================================
CREATE TABLE documento (
  iddocumento SERIAL PRIMARY KEY,
  tipo VARCHAR(100) NOT NULL,
  fechageneracion TIMESTAMP DEFAULT NOW(),
  rfc_usuario VARCHAR(13) NOT NULL,
  idexpediente INT NOT NULL,
  idcomite INT,
  id_personal_itc INT,
  FOREIGN KEY (rfc_usuario) REFERENCES usuario(rfc),
  FOREIGN KEY (idexpediente) REFERENCES expediente(idexpediente)
);

-- ==========================================
--          TABLA REVISION_DOCUMENTO
-- ==========================================
CREATE TABLE revision_documento (
  idrevision SERIAL PRIMARY KEY,
  iddocumento INT NOT NULL,
  rfc_director VARCHAR(13) NOT NULL,
  estado VARCHAR(50) DEFAULT 'En revisión'
      CHECK (estado IN ('En revisión', 'Aprobado', 'Rechazado')),
  comentarios TEXT,
  fecha_revision TIMESTAMP DEFAULT NOW(),
  firma_digital BYTEA,
  FOREIGN KEY (iddocumento) REFERENCES documento(iddocumento),
  FOREIGN KEY (rfc_director) REFERENCES usuario(rfc)
);

-- ==========================================
--             POSICIONES DEL PDF
-- ==========================================
CREATE TABLE posiciones_pdf (
    id_posicion SERIAL PRIMARY KEY,
    id_tipo_doc INT NOT NULL,
    id_campo INT NOT NULL,
    pagina INT DEFAULT 0,
    x NUMERIC(10,2) NOT NULL,
    y NUMERIC(10,2) NOT NULL,
    font_size NUMERIC(5,2) DEFAULT 8
);


ALTER TABLE documento
ADD COLUMN IF NOT EXISTS pdf BYTEA;

ALTER TABLE documento
ADD COLUMN IF NOT EXISTS estado VARCHAR(20) DEFAULT 'En captura';


-- ==========================================
--            VISTA DOCENTES
-- ==========================================
CREATE VIEW v_documentos_docente AS
SELECT 
  d.iddocumento,
  d.tipo,
  d.fechageneracion,
  d.rfc_usuario AS rfc_docente,
  (u.nombre || ' ' || u.apellido) AS nombre_docente,
  COALESCE(r.estado, 'En proceso') AS estado_revision,
  r.rfc_director,
  r.fecha_revision
FROM documento d
LEFT JOIN revision_documento r
  ON r.iddocumento = d.iddocumento
JOIN usuario u
  ON u.rfc = d.rfc_usuario;

-- ==========================================
--            VISTA DIRECTORES
-- ==========================================
CREATE VIEW v_revision_pendiente_director AS
SELECT
  r.idrevision,
  d.iddocumento,
  d.tipo,
  (u.nombre || ' ' || u.apellido) AS docente,
  d.fechageneracion,
  r.estado,
  r.comentarios
FROM revision_documento r
JOIN documento d ON d.iddocumento = r.iddocumento
JOIN usuario u ON u.rfc = d.rfc_usuario
WHERE r.estado = 'En revisión';

-- ==========================================
--              ÍNDICES USUARIO
-- ==========================================
CREATE INDEX ix_usuario_nombre ON usuario(nombre);
CREATE INDEX ix_usuario_rol ON usuario(idrol);
CREATE INDEX ix_usuario_correo ON usuario(correo);

-- ==========================================
--              ÍNDICES CONVOCATORIA
-- ==========================================
CREATE INDEX ix_convocatoria_fechas
  ON convocatoria(fechainicioregistro, fechafinregistro);

CREATE INDEX ix_convocatoria_nombre
  ON convocatoria(nombre);

-- ==========================================
--              ÍNDICES EXPEDIENTE
-- ==========================================
CREATE INDEX ix_expediente_usuario ON expediente(rfc_usuario);
CREATE INDEX ix_expediente_convocatoria ON expediente(idconvocatoria);
CREATE INDEX ix_expediente_estado ON expediente(estado);

-- ==========================================
--              ÍNDICES DOCUMENTO
-- ==========================================
CREATE INDEX ix_documento_tipo ON documento(tipo);
CREATE INDEX ix_documento_expediente ON documento(idexpediente);
CREATE INDEX ix_documento_usuario ON documento(rfc_usuario);
CREATE INDEX ix_documento_estado ON documento(idexpediente, tipo, fechageneracion);

-- ==========================================
--          ÍNDICES REVISION_DOCUMENTO
-- ==========================================
CREATE INDEX ix_revision_doc ON revision_documento(iddocumento);
CREATE INDEX ix_revision_director ON revision_documento(rfc_director);
CREATE INDEX ix_revision_estado ON revision_documento(estado, fecha_revision);

-- vista para obtener los tipos de documento desde itculiacan
CREATE OR REPLACE VIEW v_spd_tipos_documento AS
SELECT
  td.id_tipo_doc,
  td.nombre_doc,
  td.descripcion,
  td.plantilla_archivo,
  td.requiere_firmas,
  td.num_firmas
FROM itculiacan_fdw.tipos_documento td
WHERE td.id_tipo_doc BETWEEN 1 AND 11
ORDER BY td.id_tipo_doc;

-- vista para obtener los docentes desde itculiacan
CREATE OR REPLACE VIEW v_spd_docentes_itc AS
SELECT
  u.rfc              AS rfc_spd,
  u.nombre           AS nombre_spd,
  u.apellido         AS apellido_spd,
  u.correo           AS correo_spd,
  p.id_personal,
  p.nombres,
  p.apellidopat,
  p.apellidomat,
  p.tipo_personal,
  p.id_area,
  p.id_cargo
FROM usuario u
JOIN rol r        ON r.idrol = u.idrol
LEFT JOIN itculiacan_fdw.personal p
       ON lower(p.email) = lower(u.correo)
WHERE r.nombrerol = 'Docente';

-- vista para unir documentos entre sicodoc e itculiacan
CREATE OR REPLACE VIEW v_spd_documentos_itc AS
SELECT
  d.iddocumento                  AS id_doc_sicodoc,
  d.tipo                         AS tipo_sicodoc,       -- texto (1.1.0 - ...)
  d.fechageneracion,
  d.rfc_usuario                  AS rfc_docente_spd,
  u.nombre || ' ' || u.apellido  AS docente_spd,

  p.id_personal,
  p.nombres || ' ' || p.apellidopat || ' ' || p.apellidomat AS docente_itc,

  dg.id_documento                AS id_doc_itc,
  dg.id_tipo_doc,
  td.nombre_doc,
  td.plantilla_archivo,
  dg.fecha_creacion,
  dg.estado                      AS estado_itc,
  dg.archivo_final,
  dg.qr_text
FROM documento d
JOIN expediente e
  ON e.idexpediente = d.idexpediente
JOIN usuario u
  ON u.rfc = d.rfc_usuario
JOIN v_spd_docentes_itc di
  ON di.rfc_spd = u.rfc
JOIN itculiacan_fdw.personal p
  ON p.id_personal = di.id_personal
JOIN itculiacan_fdw.documentos_generados dg
  ON dg.id_docente = p.id_personal
JOIN itculiacan_fdw.tipos_documento td
  ON td.id_tipo_doc = dg.id_tipo_doc
 AND td.nombre_doc = d.tipo;   -- el texto coincide con lo que ya insertaste

--vista para obtener los campos y valores de los documentos generados en itculiacan
CREATE OR REPLACE VIEW v_spd_campos_valores AS
SELECT
  dg.id_documento           AS id_doc_itc,
  td.id_tipo_doc,
  td.nombre_doc,
  cd.id_campo,
  cd.nombre_campo,
  vd.valor
FROM itculiacan_fdw.documentos_generados dg
JOIN itculiacan_fdw.tipos_documento td
  ON td.id_tipo_doc = dg.id_tipo_doc
JOIN itculiacan_fdw.valores_documento vd
  ON vd.id_documento = dg.id_documento
JOIN itculiacan_fdw.campos_documento cd
  ON cd.id_campo = vd.id_campo;

-- vista para unir documentos con sus campos y valores
CREATE OR REPLACE VIEW v_spd_documentos_detalle AS
SELECT
  vsi.id_doc_sicodoc,
  vsi.id_doc_itc,
  vsi.rfc_docente_spd,
  vsi.docente_spd,
  vsi.nombre_doc,
  cv.nombre_campo,
  cv.valor
FROM v_spd_documentos_itc vsi
JOIN v_spd_campos_valores cv
  ON cv.id_doc_itc = vsi.id_doc_itc;

-- trigger y función para validar tipo de documento y campo al insertar en posiciones_pdf
CREATE OR REPLACE FUNCTION validar_posiciones_pdf()
RETURNS trigger AS $$
DECLARE
    existe_tipo INT;
    existe_campo INT;
BEGIN
    -- Validar tipo de documento
    SELECT id_tipo_doc INTO existe_tipo
    FROM itculiacan_fdw.tipos_documento
    WHERE id_tipo_doc = NEW.id_tipo_doc;

    IF existe_tipo IS NULL THEN
        RAISE EXCEPTION 'El id_tipo_doc % no existe en itculiacan', NEW.id_tipo_doc;
    END IF;

    -- Validar campo
    SELECT id_campo INTO existe_campo
    FROM itculiacan_fdw.campos_documento
    WHERE id_campo = NEW.id_campo;

    IF existe_campo IS NULL THEN
        RAISE EXCEPTION 'El id_campo % no existe en itculiacan', NEW.id_campo;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tg_validar_posiciones_pdf
BEFORE INSERT OR UPDATE ON posiciones_pdf
FOR EACH ROW
EXECUTE FUNCTION validar_posiciones_pdf();

