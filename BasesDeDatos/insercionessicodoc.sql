-- ================================
-- ROLES
-- ================================
INSERT INTO rol (idrol, nombrerol) VALUES
 (1, 'Docente'),
 (2, 'Director'),
 (3, 'Subdirector'),
 (4, 'Jefe de Departamento'),
 (5, 'Secretaria');


-- ===============================================
-- USUARIOS DEL TECNM CULIACÁN QUE SÍ FIRMAN EN SPD
-- Contraseña = 12345678 (bcrypt generado en BD)
-- ===============================================

-- DIRECTORA
INSERT INTO usuario (rfc, nombre, apellido, correo, contrasena_hash, firma_digital, idrol)
VALUES (
 'PINF700101ZZ0',
 'Francisca',
 'Piña Zazueta',
 'dir_culiacan@tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 2
);

-- SUBDIRECTOR DE PLANEACIÓN Y VINCULACIÓN
INSERT INTO usuario VALUES (
 'ALAE750101AA0',
 'Eduardo Antonio',
 'Alonso Astorga',
 'plan_culiacan@tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 3
);

-- JEFE DE DEPARTAMENTO — Planeación
INSERT INTO usuario VALUES (
 'LEOR800101LP0',
 'Roberto',
 'León Piña',
 'pl_culiacan@tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 4
);

-- JEFE DE DEPARTAMENTO — Gestión Tecnológica y Vinculación
INSERT INTO usuario VALUES (
 'AYOF820101RF0',
 'Raúl Alfonso',
 'Ayón Félix',
 'vin_culiacan@tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 4
);

-- JEFA DE DEPARTAMENTO — Comunicación y Difusión
INSERT INTO usuario VALUES (
 'RAEC830101GE0',
 'Cristal Gabriela',
 'Ramírez Escobar',
 'comunicacion@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 4
);

-- JEFA DE DEPARTAMENTO — Servicios Escolares
INSERT INTO usuario VALUES (
 'MEGD840101MG0',
 'Dinorah',
 'Meza García',
 'se_culiacan@tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 4
);

-- JEFE DE DEPARTAMENTO — Actividades Extraescolares
INSERT INTO usuario VALUES (
 'GASJ850101GR0',
 'José Alfredo',
 'Gastélum Ríos',
 'extraescolares@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 4
);

-- JEFE DE DEPARTAMENTO — Centro de Información
INSERT INTO usuario VALUES (
 'FAVJ860101FB0',
 'Jesús Ramón',
 'Favela Bueno',
 'cinformacion@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 4
);

-- SUBDIRECTORA — Servicios Administrativos
INSERT INTO usuario VALUES (
 'VABM870101VB0',
 'Marcela',
 'Valdez Barreras',
 'admon_culiacan@tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 3
);

-- JEFA DE DEPARTAMENTO — Recursos Humanos
INSERT INTO usuario VALUES (
 'BACL880101RB0',
 'Laura Liliana',
 'Barraza Cárdenas',
 'rh_culiacan@tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 4
);

-- JEFA DE DEPARTAMENTO — Recursos Financieros
INSERT INTO usuario VALUES (
 'HABN890101HB0',
 'Nohemí',
 'Hidalgo Beltrán',
 'recursosfinancieros@itculiacan.edu.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 4
);

-- JEFE DE DEPARTAMENTO — Recursos Materiales
INSERT INTO usuario VALUES (
 'PAQJ900101PQ0',
 'Juan Enrique',
 'Palacios Quintero',
 'rm_culiacan@tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 4
);

-- JEFE DE DEPARTAMENTO — Mantenimiento
INSERT INTO usuario VALUES (
 'CAOG910101CO0',
 'José Gabriel',
 'Castro Ochoa',
 'mantenimiento@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 4
);

-- JEFE DE DEPARTAMENTO — Centro de Cómputo
INSERT INTO usuario VALUES (
 'LIBL920101LB0',
 'Luis Ernesto',
 'Lizárraga Bolaños',
 'ccomputo@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 4
);

-- SUBDIRECTORA ACADÉMICA
INSERT INTO usuario VALUES (
 'PAMB930101VA0',
 'Bertha Lucía',
 'Patrón Arellano',
 'acad_culiacan@tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 3
);

-- JEFA DE DEPARTAMENTO — Sistemas y Computación
INSERT INTO usuario VALUES (
 'MAMB940101MB0',
 'Marisol',
 'Manjarrez Beltrán',
 'sistemas@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 4
);

-- JEFA DE DEPARTAMENTO — Desarrollo Académico
INSERT INTO usuario VALUES (
 'SAML950101SL0',
 'María Hidaelia',
 'Sánchez López',
 'desarrolloacademico@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 4
);

-- ===============================================
-- DOCENTES – Contraseña = 12345678 (bcrypt)
-- ===============================================

-- NORMA REBECA GODOY CASTRO
INSERT INTO usuario VALUES (
 'NORE010101GOC',
 'Norma Rebeca',
 'Godoy Castro',
 'norma.gc@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- CATALINA DE LA LUZ SOSA OCHOA
INSERT INTO usuario VALUES (
 'CALA010101SOO',
 'Catalina de la Luz',
 'Sosa Ochoa',
 'catalina.so@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- ARCELIA JUDITH BUSTILLOS MARTÍNEZ
INSERT INTO usuario VALUES (
 'ARJU010101BUM',
 'Arcelia Judith',
 'Bustillos Martínez',
 'arcelia.bm@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- GUALBERTO LEYVA GUTIÉRREZ
INSERT INTO usuario VALUES (
 'GUAL010101LEG',
 'Gualberto',
 'Leyva Gutiérrez',
 'gualberto.lg@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- RICARDO RAFAEL QUINTERO MEZA
INSERT INTO usuario VALUES (
 'RIRA010101QUM',
 'Ricardo Rafael',
 'Quintero Meza',
 'ricardo.qm@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- EDGAR CERVANTES LOPEZ
INSERT INTO usuario VALUES (
 'EDCE010101CEL',
 'Edgar',
 'Cervantes López',
 'edgar.cl@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- MARÍA DEL ROSARIO GONZÁLEZ ÁLVAREZ
INSERT INTO usuario VALUES (
 'MARD010101GOA',
 'María del Rosario',
 'González Álvarez',
 'maria.ga@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- ==========================
-- TU EQUIPO COMPLETO
-- ==========================

-- JOSÉ ERNESTO AYALA RODRÍGUEZ
INSERT INTO usuario VALUES (
 'JOEA010101AYR',
 'José Ernesto',
 'Ayala Rodríguez',
 'jose.ar@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- EDGAR RAMÓN BELTRÁN LÓPEZ
INSERT INTO usuario VALUES (
 'EDRA010101BEL',
 'Edgar Ramón',
 'Beltrán López',
 'edgar.bl@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- JEYLEN ISAI GARCÍA FÉLIX
INSERT INTO usuario VALUES (
 'JEIS010101GAF',
 'Jeylen Isai',
 'García Félix',
 'jeylen.gf@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- BRYAN ALEXIS NÁJERA BELTRÁN
INSERT INTO usuario VALUES (
 'BRAL010101NAB',
 'Bryan Alexis',
 'Nájera Beltrán',
 'bryan.nb@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- HIRAM NORIEGA MELENDRES
INSERT INTO usuario VALUES (
 'HIRA010101NOM',
 'Hiram',
 'Noriega Melendres',
 'hiram.nm@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- JOSÉ LUIS VALENZUELA ARAUJO
INSERT INTO usuario VALUES (
 'JOLU010101VAA',
 'José Luis',
 'Valenzuela Araujo',
 'joseluis.va@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- ==========================
-- MÁS DOCENTES
-- ==========================

-- ELIZABETH CECEÑA NIEBLA
INSERT INTO usuario VALUES (
 'ELCE010101CEN',
 'Elizabeth',
 'Ceceña Niebla',
 'elizabeth.cn@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- LEOPOLDO ZENAIDO ZEPEDA SÁNCHEZ
INSERT INTO usuario VALUES (
 'LEZE010101ZES',
 'Leopoldo Zenaido',
 'Zepeda Sánchez',
 'leopoldo.zs@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- MARTIN LEONARDO NEVAREZ RIVAS
INSERT INTO usuario VALUES (
 'MALE010101NER',
 'Martín Leonardo',
 'Nevarez Rivas',
 'martin.nr@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);

-- DANIEL ESPARZA SOTO
INSERT INTO usuario VALUES (
 'DAES010101ESS',
 'Daniel',
 'Esparza Soto',
 'daniel.es@culiacan.tecnm.mx',
 crypt('12345678', gen_salt('bf')),
 NULL,
 1
);


-- ================================
-- CONVOCATORIAS
-- ================================

-- Convocatoria SPD 2025
INSERT INTO convocatoria (nombre, fechainicioregistro, fechafinregistro, fechainicioevaluacion, fechafinevaluacion, fecha_pub)
VALUES (
 'Convocatoria SPD 2025',
 '2025-05-01', '2025-05-31',
 '2025-06-01', '2025-06-07',
 '2024-11-16'
);

-- Convocatoria SPD 2026
INSERT INTO convocatoria (nombre, fechainicioregistro, fechafinregistro, fechainicioevaluacion, fechafinevaluacion, fecha_pub)
VALUES (
 'Convocatoria SPD 2026',
 '2026-05-01', '2026-05-31',
 '2026-06-01', '2026-06-07',
 '2025-11-17'
);

-- Un expediente por docente para la Convocatoria SPD 2025 (idconvocatoria = 1)
INSERT INTO expediente (estado, rfc_usuario, idconvocatoria)
SELECT
  'En captura' AS estado,
  u.rfc,
  1 AS idconvocatoria       -- Convocatoria SPD 2025
FROM usuario u
JOIN rol r ON r.idrol = u.idrol
WHERE r.nombrerol = 'Docente';

-- Obtenemos el expediente de Norma para la SPD 2025
-- (asumimos que solo tiene uno para esa convocatoria)
WITH exp_norma AS (
  SELECT idexpediente
  FROM expediente
  WHERE rfc_usuario = 'NORE010101GOC'
    AND idconvocatoria = 1
  LIMIT 1
)

INSERT INTO documento (tipo, rfc_usuario, idexpediente, idcomite, id_personal_itc)
SELECT tipo_doc, 'NORE010101GOC', e.idexpediente, NULL, 37
FROM exp_norma e
CROSS JOIN (
  VALUES
    ('1.1.0 - Constancia de Situación Laboral'),
    ('1.1.5.1 - Constancia de Tutorías'),
    ('1.1.6 - Documento de Acreditación CONAIC'),
    ('1.1.7 - Actividades Complementarias'),
    ('1.2.1 - Recurso Educativo Digital'),
    ('1.2.1.3 - Estrategias Didácticas Innovadoras'),
    ('1.3.1 - Exención de Examen Profesional'),
    ('03A - Formato de Horario de Actividades'),
    ('04 - Carta de Exclusividad Laboral'),
    ('06 - Constancia Actualización CVU'),
    ('07 - Constancia de Carga Académica')
) AS t(tipo_doc);
