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
  tutorias,
  actividades_complementarias,
  aulas,
  sinodales,
  carreras,
  materias,
  grupos,
  estudiantes,
  calificaciones
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

-- En BD sicodoc
CREATE OR REPLACE FUNCTION f_anio_evidencias(p_idexpediente INT)
RETURNS INT AS $$
DECLARE
    v_anio INT;
BEGIN
    SELECT EXTRACT(YEAR FROM c.fecha_pub)::INT
    INTO v_anio
    FROM expediente e
    JOIN convocatoria c ON c.idconvocatoria = e.idconvocatoria
    WHERE e.idexpediente = p_idexpediente;

    RETURN v_anio;
END;
$$ LANGUAGE plpgsql;

-- En BD sicodoc, usando FDW para insertar en itculiacan
CREATE OR REPLACE FUNCTION f_crear_doc_itc_desde_sicodoc(p_iddocumento INT)
RETURNS INT AS $$
DECLARE
    v_tipo_sico    TEXT;
    v_rfc          VARCHAR(13);
    v_idexpediente INT;
    v_idconvocatoria INT;
    v_anio_evid INT;
    v_id_personal_itc INT;
    v_id_tipo_doc INT;
    v_id_doc_itc INT;
BEGIN
    -- Obtenemos datos del documento en SICODOC
    SELECT d.tipo, d.rfc_usuario, d.idexpediente, e.idconvocatoria
    INTO   v_tipo_sico, v_rfc, v_idexpediente, v_idconvocatoria
    FROM documento d
    JOIN expediente e ON e.idexpediente = d.idexpediente
    WHERE d.iddocumento = p_iddocumento;

    -- Año de evidencias
    v_anio_evid := f_anio_evidencias(v_idexpediente);

    -- Obtenemos el id_personal de ITC a partir del RFC de SPD
    SELECT di.id_personal
    INTO v_id_personal_itc
    FROM v_spd_docentes_itc di
    WHERE di.rfc_spd = v_rfc;

    -- Obtenemos el tipo de documento en ITC por el nombre
    SELECT td.id_tipo_doc
    INTO v_id_tipo_doc
    FROM itculiacan_fdw.tipos_documento td
    WHERE td.nombre_doc = v_tipo_sico;

    -- Creamos registro en itculiacan.documentos_generados
    INSERT INTO itculiacan_fdw.documentos_generados(
        id_tipo_doc, id_docente, fecha_creacion, estado, anio_convocatoria
    ) VALUES (
        v_id_tipo_doc, v_id_personal_itc, NOW()::DATE, 'En proceso', v_anio_evid
    )
    RETURNING id_documento INTO v_id_doc_itc;

    RETURN v_id_doc_itc;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION f_llenar_constancia_laboral(p_id_doc_itc INT)
RETURNS VOID AS $$
DECLARE
    v_id_docente INT;
    v_id_tipo_doc INT;
    v_id_personal INT;
    v_anio INT;
BEGIN
    SELECT id_docente, id_tipo_doc, anio_convocatoria
    INTO v_id_docente, v_id_tipo_doc, v_anio
    FROM itculiacan_fdw.documentos_generados
    WHERE id_documento = p_id_doc_itc;

    v_id_personal := v_id_docente;

    -- Obtenemos datos laborales
    INSERT INTO itculiacan_fdw.valores_documento(id_documento, id_campo, valor)
    SELECT
        p_id_doc_itc,
        c.id_campo,
        CASE c.nombre_campo
            WHEN 'nombre' THEN vda.nombres || ' ' || vda.apellidopat || ' ' || COALESCE(vda.apellidomat, '')
            WHEN 'filiacion' THEN vda.area
            WHEN 'fecha_inicio' THEN COALESCE(vda.fecha_ingreso::TEXT, '')
            WHEN 'fecha_dos' THEN v_anio::TEXT
            WHEN 'categoria_anterior' THEN COALESCE(vda.cargo, '')
            WHEN 'horas' THEN COALESCE(vda.por_horas::TEXT, '')
            WHEN 'estatus_completo' THEN vda.tipo_contrato || ' ' || vda.estatus
            WHEN 'categoria_actual' THEN COALESCE(vda.cargo, '')
            WHEN 'clave_presupuestal' THEN COALESCE(vda.rfc, '')
            WHEN 'fecha_efectos' THEN COALESCE(vda.fecha_ingreso::TEXT, '')
            WHEN 'estatus_actual' THEN vda.estatus
            ELSE ''
        END AS valor
    FROM itculiacan_fdw.campos_documento c
    CROSS JOIN v_datos_laborales_actual vda
    WHERE c.id_tipo_doc = v_id_tipo_doc
      AND vda.id_personal = v_id_personal
      AND c.nombre_campo IN (
        'nombre','filiacion','fecha_inicio','fecha_dos','categoria_anterior',
        'horas','estatus_completo','categoria_actual','clave_presupuestal',
        'fecha_efectos','estatus_actual'
      );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION f_llenar_constancia_tutorias(p_id_doc_itc INT)
RETURNS VOID AS $$
DECLARE
    v_id_docente INT;
    v_id_tipo_doc INT;
    v_anio INT;
    v_nombre_docente TEXT;
    v_depto TEXT;
    v_fecha1 DATE;
    v_fecha2 DATE;
    v_total INT;
BEGIN
    SELECT dg.id_docente, dg.id_tipo_doc, dg.anio_convocatoria
    INTO v_id_docente, v_id_tipo_doc, v_anio
    FROM itculiacan_fdw.documentos_generados dg
    WHERE dg.id_documento = p_id_doc_itc;

    -- Nombre y depto desde v_datos_laborales_actual
    SELECT 
        vda.nombres || ' ' || vda.apellidopat || ' ' || COALESCE(vda.apellidomat, ''),
        vda.area
    INTO v_nombre_docente, v_depto
    FROM v_datos_laborales_actual vda
    WHERE vda.id_personal = v_id_docente;

    -- Fechas y total desde tutorias (ejemplo sencillo)
    SELECT MIN(fecha) FILTER (WHERE periodo LIKE 'ENE-JUN%'),
           MAX(fecha) FILTER (WHERE periodo LIKE 'ENE-JUN%'),
           COALESCE(SUM(num_tutorados),0)
    INTO v_fecha1, v_fecha2, v_total
    FROM tutorias
    WHERE id_docente = v_id_docente
      AND periodo LIKE ('%' || v_anio::TEXT);

    -- Insertamos valores
    INSERT INTO itculiacan_fdw.valores_documento(id_documento, id_campo, valor)
    SELECT
        p_id_doc_itc,
        c.id_campo,
        CASE c.nombre_campo
            WHEN 'nombre' THEN v_nombre_docente
            WHEN 'depto' THEN v_depto
            WHEN 'fecha1' THEN COALESCE(v_fecha1::TEXT,'')
            WHEN 'fecha2' THEN COALESCE(v_fecha2::TEXT,'')
            WHEN 'tutoria' THEN 'Tutorías académicas'
            WHEN 'tutoria2' THEN 'Tutorías académicas'
            WHEN 'total' THEN v_total::TEXT
            WHEN 'carrera1' THEN 'Ingeniería en Sistemas Computacionales'
            WHEN 'carrera2' THEN 'Ingeniería en Sistemas Computacionales'
            ELSE ''
        END
    FROM itculiacan_fdw.campos_documento c
    WHERE c.id_tipo_doc = v_id_tipo_doc
      AND c.nombre_campo IN ('nombre','depto','fecha1','fecha2',
                             'tutoria','tutoria2','total',
                             'carrera1','carrera2');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION f_llenar_carga_academica(p_id_doc_itc INT)
RETURNS VOID AS $$
DECLARE
    v_id_docente INT;
    v_id_tipo_doc INT;
    v_anio INT;
    v_nombre_docente TEXT;
    v_expediente TEXT := 'SPD-' || p_id_doc_itc::TEXT;
BEGIN
    SELECT dg.id_docente, dg.id_tipo_doc, dg.anio_convocatoria
    INTO v_id_docente, v_id_tipo_doc, v_anio
    FROM itculiacan_fdw.documentos_generados dg
    WHERE dg.id_documento = p_id_doc_itc;

    SELECT vda.nombres || ' ' || vda.apellidopat || ' ' || COALESCE(vda.apellidomat,'')
    INTO v_nombre_docente
    FROM v_datos_laborales_actual vda
    WHERE vda.id_personal = v_id_docente;

    -- Nombre y expediente
    INSERT INTO itculiacan_fdw.valores_documento(id_documento, id_campo, valor)
    SELECT p_id_doc_itc, c.id_campo,
           CASE c.nombre_campo
                WHEN 'nombre' THEN v_nombre_docente
                WHEN 'expediente' THEN v_expediente
                ELSE ''
           END
    FROM itculiacan_fdw.campos_documento c
    WHERE c.id_tipo_doc = v_id_tipo_doc
      AND c.nombre_campo IN ('nombre','expediente');

    -- Ahora llenamos filas de enero-junio / agosto-diciembre
    -- Esta es una idea básica: toma hasta 6 grupos por año
    WITH grupos_doc AS (
        SELECT g.*, m.nombre AS materia, c.nombre AS carrera_name,
               ROW_NUMBER() OVER (
                   PARTITION BY (CASE 
                                    WHEN g.periodo ILIKE 'ENE-JUN%' THEN 1 
                                    WHEN g.periodo ILIKE 'AGO-DIC%' THEN 2 
                                END)
                   ORDER BY g.clave_grupo
               ) AS rn,
               CASE 
                    WHEN g.periodo ILIKE 'ENE-JUN%' THEN 1
                    WHEN g.periodo ILIKE 'AGO-DIC%' THEN 4
               END AS bloque_inicio
        FROM grupos g
        JOIN materias m ON m.id_materia = g.id_materia
        JOIN carreras c ON c.id_carrera = m.id_carrera
        WHERE g.id_docente = v_id_docente
          AND g.periodo LIKE '%' || v_anio::TEXT
    ), filas AS (
        SELECT 
            (bloque_inicio + rn - 1) AS fila,
            g.*
        FROM grupos_doc g
        WHERE rn <= 3 -- máximo 3 por bloque (1-3 ene-jun, 4-6 ago-dic)
    )
    INSERT INTO itculiacan_fdw.valores_documento(id_documento, id_campo, valor)
    SELECT
        p_id_doc_itc,
        c.id_campo,
        CASE c.nombre_campo
            WHEN 'periodo' || fila::TEXT THEN g.periodo
            WHEN 'nivel'   || fila::TEXT THEN 'Licenciatura'
            WHEN 'clave'   || fila::TEXT THEN m.clave
            WHEN 'materia' || fila::TEXT THEN m.nombre
            WHEN 'alumnos' || fila::TEXT THEN COUNT(cal.numerocontrol)::TEXT
            ELSE ''
        END
    FROM filas g
    JOIN materias m ON m.id_materia = g.id_materia
    LEFT JOIN calificaciones cal ON cal.id_grupo = g.id_grupo
    JOIN itculiacan_fdw.campos_documento c
      ON c.id_tipo_doc = v_id_tipo_doc
     AND c.nombre_campo IN (
        'periodo1','nivel1','clave1','materia1','alumnos1',
        'periodo2','nivel2','clave2','materia2','alumnos2',
        'periodo3','nivel3','clave3','materia3','alumnos3',
        'periodo4','nivel4','clave4','materia4','alumnos4',
        'periodo5','nivel5','clave5','materia5','alumnos5',
        'periodo6','nivel6','clave6','materia6','alumnos6'
     )
    GROUP BY p_id_doc_itc, c.id_campo, c.nombre_campo, g.fila, g.periodo, m.clave, m.nombre;

    -- Total alumnos
    INSERT INTO itculiacan_fdw.valores_documento(id_documento, id_campo, valor)
    SELECT p_id_doc_itc, c.id_campo, COUNT(cal.numerocontrol)::TEXT
    FROM itculiacan_fdw.campos_documento c
    LEFT JOIN grupos g ON g.id_docente = v_id_docente
    LEFT JOIN calificaciones cal ON cal.id_grupo = g.id_grupo
    WHERE c.id_tipo_doc = v_id_tipo_doc
      AND c.nombre_campo = 'total'
    GROUP BY c.id_campo;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION f_preparar_documento_itc(p_iddocumento_sico INT)
RETURNS INT AS $$
DECLARE
    v_id_doc_itc INT;
    v_tipo TEXT;
    v_id_tipo_doc INT;
BEGIN
    -- Crear o recuperar doc en itculiacan
    v_id_doc_itc := f_crear_doc_itc_desde_sicodoc(p_iddocumento_sico);

    SELECT tipo INTO v_tipo FROM documento WHERE iddocumento = p_iddocumento_sico;

    SELECT id_tipo_doc INTO v_id_tipo_doc
    FROM itculiacan_fdw.tipos_documento
    WHERE nombre_doc = v_tipo;

    -- Llenar según el tipo
    IF v_id_tipo_doc = 1 THEN
        PERFORM f_llenar_constancia_laboral(v_id_doc_itc);
    ELSIF v_id_tipo_doc = 2 THEN
        PERFORM f_llenar_constancia_tutorias(v_id_doc_itc);
    ELSIF v_id_tipo_doc = 11 THEN
        PERFORM f_llenar_carga_academica(v_id_doc_itc);
    -- aquí agregas los demás tipos (3,4,5,6,7,8,9,10) con sus funciones
    END IF;

    RETURN v_id_doc_itc;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_o_crear_expediente(
    p_rfc_usuario VARCHAR(13),
    p_nombre_convocatoria VARCHAR
)
RETURNS INT AS $$
DECLARE
    v_idconv INT;
    v_idexpediente INT;
BEGIN
    SELECT idconvocatoria
    INTO v_idconv
    FROM convocatoria
    WHERE nombre = p_nombre_convocatoria
    ORDER BY idconvocatoria DESC
    LIMIT 1;

    IF v_idconv IS NULL THEN
        RAISE EXCEPTION 'No existe la convocatoria %', p_nombre_convocatoria;
    END IF;

    SELECT idexpediente
    INTO v_idexpediente
    FROM expediente
    WHERE rfc_usuario = p_rfc_usuario
      AND idconvocatoria = v_idconv
    LIMIT 1;

    IF v_idexpediente IS NULL THEN
        INSERT INTO expediente (estado, rfc_usuario, idconvocatoria)
        VALUES ('En captura', p_rfc_usuario, v_idconv)
        RETURNING idexpediente INTO v_idexpediente;
    END IF;

    RETURN v_idexpediente;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW v_spd_documentos_por_docente AS
SELECT
  vsi.id_doc_sicodoc,
  vsi.id_doc_itc,
  vsi.rfc_docente_spd AS rfc_docente,
  vsi.docente_spd     AS nombre_docente,
  vsi.id_tipo_doc,
  vsi.nombre_doc,
  vsi.plantilla_archivo,
  vsi.estado_itc,
  vsi.archivo_final,
  vsi.qr_text
FROM v_spd_documentos_itc vsi;


ALTER TABLE documento
ADD COLUMN id_documento_itc INT;

UPDATE documento d
SET id_documento_itc = dg.id_documento
FROM expediente e,
     usuario u,
     itculiacan_fdw.recursos_humanos rh,
     itculiacan_fdw.documentos_generados dg,
     itculiacan_fdw.tipos_documento td
WHERE d.id_documento_itc IS NULL
  AND e.idexpediente = d.idexpediente
  AND u.rfc = d.rfc_usuario
  AND rh.rfc = u.rfc
  AND dg.id_docente = rh.id_personal
  AND td.id_tipo_doc = dg.id_tipo_doc
  AND td.nombre_doc = d.tipo;


ALTER TABLE documento
    ADD COLUMN pdf_path TEXT,
    DROP COLUMN pdf;
