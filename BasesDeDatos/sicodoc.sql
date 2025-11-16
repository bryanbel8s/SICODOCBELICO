CREATE EXTENSION IF NOT EXISTS pgcrypto;

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
