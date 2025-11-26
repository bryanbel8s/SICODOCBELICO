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


INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size) VALUES
(1, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nombre'), 0, 320, 304, 7.7),
(1, (SELECT id_campo FROM campos_documento WHERE nombre_campo='filiacion'), 0, 92, 316, 7.7),
(1, (SELECT id_campo FROM campos_documento WHERE nombre_campo='fecha_inicio'), 0, 360, 316, 7.7),
(1, (SELECT id_campo FROM campos_documento WHERE nombre_campo='fecha_dos'), 0, 155, 339, 7.7),
(1, (SELECT id_campo FROM campos_documento WHERE nombre_campo='categoria_anterior'), 0, 345, 339, 7.7),
(1, (SELECT id_campo FROM campos_documento WHERE nombre_campo='horas'), 0, 145, 351, 7.7),
(1, (SELECT id_campo FROM campos_documento WHERE nombre_campo='estatus_completo'), 0, 225, 351, 7.7),
(1, (SELECT id_campo FROM campos_documento WHERE nombre_campo='categoria_actual'), 0, 92, 363, 7.7),
(1, (SELECT id_campo FROM campos_documento WHERE nombre_campo='clave_presupuestal'), 0, 428, 363, 7.7),
(1, (SELECT id_campo FROM campos_documento WHERE nombre_campo='fecha_efectos'), 0, 178, 375, 7.7),
(1, (SELECT id_campo FROM campos_documento WHERE nombre_campo='estatus_actual'), 0, 335, 375, 7.7);

INSERT INTO posiciones_pdf VALUES
(2, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nombre'), 0, 315, 274, 8),
(2, (SELECT id_campo FROM campos_documento WHERE nombre_campo='depto'), 0, 90, 290, 8),
(2, (SELECT id_campo FROM campos_documento WHERE nombre_campo='fecha1'), 0, 100, 340, 9),
(2, (SELECT id_campo FROM campos_documento WHERE nombre_campo='fecha2'), 0, 100, 358, 9),
(2, (SELECT id_campo FROM campos_documento WHERE nombre_campo='tutoria'), 0, 250, 340, 9),
(2, (SELECT id_campo FROM campos_documento WHERE nombre_campo='tutoria2'), 0, 250, 358, 9),
(2, (SELECT id_campo FROM campos_documento WHERE nombre_campo='total'), 0, 250, 375, 9),
(2, (SELECT id_campo FROM campos_documento WHERE nombre_campo='carrera1'), 0, 350, 340, 9),
(2, (SELECT id_campo FROM campos_documento WHERE nombre_campo='carrera2'), 0, 350, 358, 9);

INSERT INTO posiciones_pdf VALUES
(3, (SELECT id_campo FROM campos_documento WHERE nombre_campo='programa'), 0, 190, 427, 20),
(3, (SELECT id_campo FROM campos_documento WHERE nombre_campo='fecha_inicio'), 0, 224, 530, 8),
(3, (SELECT id_campo FROM campos_documento WHERE nombre_campo='fecha_fin'), 0, 331, 530, 8),
(3, (SELECT id_campo FROM campos_documento WHERE nombre_campo='fecha_emision'), 0, 452, 581, 8);

INSERT INTO posiciones_pdf VALUES
(4, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nombre'), 0, 204, 270, 6.6),
(4, (SELECT id_campo FROM campos_documento WHERE nombre_campo='semestre'), 0, 310, 281, 6.8),
(4, (SELECT id_campo FROM campos_documento WHERE nombre_campo='dictamen'), 0, 68, 288, 6.6),
(4, (SELECT id_campo FROM campos_documento WHERE nombre_campo='fecha'), 0, 390, 164, 6.9);

INSERT INTO posiciones_pdf VALUES
(5, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nombre'), 0, 275, 308, 8),
(5, (SELECT id_campo FROM campos_documento WHERE nombre_campo='mes1'), 0, 533, 313, 8),
(5, (SELECT id_campo FROM campos_documento WHERE nombre_campo='mes2'), 0, 65, 319, 8),
(5, (SELECT id_campo FROM campos_documento WHERE nombre_campo='ano'), 0, 122, 319, 8),
(5, (SELECT id_campo FROM campos_documento WHERE nombre_campo='materia'), 0, 423, 324, 9),
(5, (SELECT id_campo FROM campos_documento WHERE nombre_campo='programa'), 0, 183, 333, 9),
(5, (SELECT id_campo FROM campos_documento WHERE nombre_campo='fecha'), 0, 508, 175, 10);

INSERT INTO posiciones_pdf VALUES
(6, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nombre'), 0, 284, 275, 7.7),
(6, (SELECT id_campo FROM campos_documento WHERE nombre_campo='fecha'), 0, 507, 174, 7.7),
(6, (SELECT id_campo FROM campos_documento WHERE nombre_campo='asignatura'), 0, 68, 326, 7.7),
(6, (SELECT id_campo FROM campos_documento WHERE nombre_campo='estrategia'), 0, 216, 330, 7.7),
(6, (SELECT id_campo FROM campos_documento WHERE nombre_campo='programa'), 0, 365, 334, 7.7);

INSERT INTO posiciones_pdf VALUES
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nombre_jurado'), 0, 91, 219, 12),
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='numero_control'), 0, 135, 235, 12),
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='tecnologico'), 0, 90, 255, 12),
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='clave'), 0, 279, 258, 12),
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='carrera'), 0, 89, 274, 12),
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='titulacion'), 0, 88, 331, 12),
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='dia'), 0, 392, 505, 12),
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='mes'), 0, 98, 524, 12),
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='ano'), 0, 227, 525, 12),
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='presidente'), 0, 179, 615, 10),
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='cedula'), 0, 232, 627, 10),
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='secretario'), 0, 75, 711, 10),
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='cedula2'), 0, 133, 724, 10),
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='vocal'), 0, 289, 707, 10),
(7, (SELECT id_campo FROM campos_documento WHERE nombre_campo='cedula3'), 0, 346, 718, 10);

INSERT INTO posiciones_pdf VALUES
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nombre'), 0, 57, 273, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='escolaridad'), 0, 8, 284, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='maestria'), 0, 8, 294, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='titulado'), 0, 300, 284, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='titulado2'), 0, 300, 295, 4),

-- Actividades académicas (asignaturas)
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='asig1'), 0, 8, 330, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='asig2'), 0, 8, 335, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='asig3'), 0, 8, 341, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='asig4'), 0, 8, 347, 4),

-- Grupos
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='grupo1'), 0, 100, 330, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='grupo2'), 0, 100, 335, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='grupo3'), 0, 100, 341, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='grupo4'), 0, 100, 347, 4),

-- Alumnos
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='estudiantes1'), 0, 130, 330, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='estudiantes2'), 0, 130, 335, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='estudiantes3'), 0, 130, 341, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='estudiantes4'), 0, 130, 347, 4),

-- Aulas
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='aula1'), 0, 144, 330, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='aula2'), 0, 144, 335, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='aula3'), 0, 144, 341, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='aula4'), 0, 144, 347, 4),

-- Nivel
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nivel1'), 0, 160, 330, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nivel2'), 0, 160, 335, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nivel3'), 0, 160, 341, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nivel4'), 0, 160, 347, 4),

-- Modalidad
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='modalidad1'), 0, 175, 330, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='modalidad2'), 0, 175, 335, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='modalidad3'), 0, 175, 341, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='modalidad4'), 0, 175, 347, 4),

-- Carrera
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='carrea1'), 0, 210, 330, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='carrea2'), 0, 210, 335, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='carrea3'), 0, 210, 341, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='carrea4'), 0, 210, 347, 4),

-- Horarios lunes-viernes (solo ejemplo 1)
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='lunes1'), 0, 272, 330, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='martes1'), 0, 322, 330, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='miercoles1'), 0, 362, 330, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='jueves1'), 0, 400, 330, 4),
(8, (SELECT id_campo FROM campos_documento WHERE nombre_campo='viernes1'), 0, 434, 330, 4);

INSERT INTO posiciones_pdf VALUES
(9, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nombre'), 0, 217, 197, 11),
(9, (SELECT id_campo FROM campos_documento WHERE nombre_campo='filiacion'), 0, 67, 216, 11),
(9, (SELECT id_campo FROM campos_documento WHERE nombre_campo='clave_presupuestal'), 0, 502, 212, 7.7),
(9, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nombre'), 0, 217, 597, 11);

INSERT INTO posiciones_pdf VALUES
(10, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nombre'), 0, 130, 367, 7.5),
(10, (SELECT id_campo FROM campos_documento WHERE nombre_campo='numoficio'), 0, 451, 228, 9),
(10, (SELECT id_campo FROM campos_documento WHERE nombre_campo='fecha_emision'), 0, 460, 190, 8),
(10, (SELECT id_campo FROM campos_documento WHERE nombre_campo='registro'), 0, 348, 367, 7.5);

INSERT INTO posiciones_pdf VALUES
(11, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nombre'), 0, 40, 304, 7),
(11, (SELECT id_campo FROM campos_documento WHERE nombre_campo='expediente'), 0, 230, 304, 9),

-- Enero-Junio
(11, (SELECT id_campo FROM campos_documento WHERE nombre_campo='periodo1'), 0, 85, 375, 9),
(11, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nivel1'), 0, 156, 375, 9),
(11, (SELECT id_campo FROM campos_documento WHERE nombre_campo='clave1'), 0, 236, 375, 9),
(11, (SELECT id_campo FROM campos_documento WHERE nombre_campo='materia1'), 0, 300, 375, 9),
(11, (SELECT id_campo FROM campos_documento WHERE nombre_campo='alumnos1'), 0, 496, 375, 9),

-- Agosto-Diciembre
(11, (SELECT id_campo FROM campos_documento WHERE nombre_campo='periodo2'), 0, 85, 413, 9),
(11, (SELECT id_campo FROM campos_documento WHERE nombre_campo='nivel2'), 0, 156, 413, 9),
(11, (SELECT id_campo FROM campos_documento WHERE nombre_campo='clave2'), 0, 236, 413, 9),
(11, (SELECT id_campo FROM campos_documento WHERE nombre_campo='materia2'), 0, 300, 413, 9),
(11, (SELECT id_campo FROM campos_documento WHERE nombre_campo='alumnos2'), 0, 496, 413, 9),

-- TOTAL
(11, (SELECT id_campo FROM campos_documento WHERE nombre_campo='total'), 0, 475, 478, 9);

-- Posiciones para el tipo de documento 1 (Constancia de Situación Laboral)
INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size)
SELECT 
    1, c.id_campo, 0, t.x, t.y, t.font
FROM (
    VALUES
        ('nombre',            320, 304, 7.7),
        ('filiacion',         92,  316, 7.7),
        ('fecha_inicio',      360, 316, 7.7),
        ('fecha_dos',         155, 339, 7.7),
        ('categoria_anterior',345, 339, 7.7),
        ('horas',             145, 351, 7.7),
        ('estatus_completo',  225, 351, 7.7),
        ('categoria_actual',  92,  363, 7.7),
        ('clave_presupuestal',428, 363, 7.7),
        ('fecha_efectos',     178, 375, 7.7),
        ('estatus_actual',    335, 375, 7.7)
) AS t(nombre_campo, x, y, font)
JOIN itculiacan_fdw.campos_documento c
  ON c.id_tipo_doc = 1 
 AND c.nombre_campo = t.nombre_campo;

-- Posiciones para el tipo de documento 2 (Constancia de Tutorías)
INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size)
SELECT 2, c.id_campo, 0, t.x, t.y, t.font
FROM (
    VALUES
        ('nombre', 315, 274, 8),
        ('depto',  90,  290, 8),
        ('fecha1', 100, 340, 9),
        ('fecha2', 100, 358, 9),
        ('tutoria', 250, 340, 9),
        ('tutoria2',250, 358, 9),
        ('total',  250, 375, 9),
        ('carrera1',350, 340, 9),
        ('carrera2',350, 358, 9)
) AS t(nombre_campo, x, y, font)
JOIN itculiacan_fdw.campos_documento c 
  ON c.id_tipo_doc = 2 
 AND c.nombre_campo = t.nombre_campo;

-- Posiciones para el tipo de documento 3 (Documento de Acreditación CONAIC)
INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size)
SELECT 3, c.id_campo, 0, t.x, t.y, t.font
FROM (
    VALUES
        ('programa',      190, 427, 20),
        ('fecha_inicio',  224, 530, 8),
        ('fecha_fin',     331, 530, 8),
        ('fecha_emision', 452, 581, 8)
) AS t(nombre_campo, x, y, font)
JOIN itculiacan_fdw.campos_documento c
  ON c.id_tipo_doc = 3 
 AND c.nombre_campo = t.nombre_campo;

-- Posiciones para el tipo de documento 4 (Actividades Complementarias)
INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size)
SELECT 4, c.id_campo, 0, t.x, t.y, t.font
FROM (
    VALUES
        ('nombre',   204, 270, 6.6),
        ('semestre', 310, 281, 6.8),
        ('dictamen', 68,  288, 6.6),
        ('fecha',    390, 164, 6.9)
) AS t(nombre_campo, x, y, font)
JOIN itculiacan_fdw.campos_documento c 
  ON c.id_tipo_doc = 4
 AND c.nombre_campo = t.nombre_campo;

-- Posiciones para el tipo de documento 5 (Recurso Educativo Digital)
INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size)
SELECT 5, c.id_campo, 0, t.x, t.y, t.font
FROM (
    VALUES
        ('nombre', 275, 308, 8),
        ('mes1',   533, 313, 8),
        ('mes2',   65,  319, 8),
        ('ano',    122, 319, 8),
        ('materia',423, 324, 9),
        ('programa',183,333, 9),
        ('fecha',  508, 175, 10)
) AS t(nombre_campo, x, y, font)
JOIN itculiacan_fdw.campos_documento c
  ON c.id_tipo_doc = 5 
 AND c.nombre_campo = t.nombre_campo;

-- Posiciones para el tipo de documento 6 (Estrategias Didácticas Innovadoras)
INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size)
SELECT 6, c.id_campo, 0, t.x, t.y, t.font
FROM (
    VALUES
        ('nombre',284,275, 7.7),
        ('fecha', 507,174, 7.7),
        ('asignatura',68,326,7.7),
        ('estrategia',216,330,7.7),
        ('programa',365,334,7.7)
) AS t(nombre_campo, x, y, font)
JOIN itculiacan_fdw.campos_documento c
  ON c.id_tipo_doc = 6 
 AND c.nombre_campo = t.nombre_campo;

-- Posiciones para el tipo de documento 7 (Exención de Examen Profesional)
INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size)
SELECT 7, c.id_campo, 0, t.x, t.y, t.font
FROM (
    VALUES
        ('nombre_jurado', 91, 219,12),
        ('numero_control',135,235,12),
        ('tecnologico',   90, 255,12),
        ('clave',         279,258,12),
        ('carrera',       89, 274,12),
        ('titulacion',    88, 331,12),
        ('dia',           392,505,12),
        ('mes',           98, 524,12),
        ('ano',           227,525,12),
        ('presidente',    179,615,10),
        ('cedula',        232,627,10),
        ('secretario',    75, 711,10),
        ('cedula2',       133,724,10),
        ('vocal',         289,707,10),
        ('cedula3',       346,718,10)
) AS t(nombre_campo, x, y, font)
JOIN itculiacan_fdw.campos_documento c
  ON c.id_tipo_doc = 7 
 AND c.nombre_campo = t.nombre_campo;

-- Posiciones para el tipo de documento 8 (Formato de Horario de Actividades)
INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size)
SELECT 8, c.id_campo, 0, t.x, t.y, t.font
FROM (
    VALUES
        ('nombre', 57, 273, 4),
        ('escolaridad', 8, 284, 4),
        ('clave_plaza', 322, 278, 4),
        ('periodo_escolar', 474, 257, 9),

        -- Asignatura 1
        ('asig1', 8, 330, 4),
        ('grupo1', 100, 330, 4),
        ('aula1', 144, 330, 4),
        ('modalidad1', 160, 330, 4),
        ('lunes1', 272, 330, 4),
        ('martes1', 322, 330, 4),
        ('miercoles1', 362, 330, 4),
        ('jueves1', 400, 330, 4),
        ('viernes1', 434, 330, 4),

        -- Asignatura 2
        ('asig2', 8, 335, 4),
        ('grupo2', 100, 335, 4),
        ('aula2', 144, 335, 4),
        ('modalidad2', 160, 335, 4),
        ('lunes2', 272, 335, 4),
        ('martes2', 322, 335, 4),
        ('miercoles2', 362, 335, 4),
        ('jueves2', 400, 335, 4),
        ('viernes2', 434, 335, 4),

        -- Asignatura 3
        ('asig3', 8, 341, 4),
        ('grupo3', 100, 341, 4),
        ('aula3', 144, 341, 4),
        ('modalidad3', 160, 341, 4),
        ('lunes3', 272, 341, 4),
        ('martes3', 322, 341, 4),
        ('miercoles3', 362, 341, 4),
        ('jueves3', 400, 341, 4),
        ('viernes3', 434, 341, 4),

        -- Actividades de apoyo
        ('act1', 6, 411, 4),
        ('horario_act1', 272, 411, 4),

        ('act2', 6, 416, 4),
        ('horario_act2', 272, 416, 4),

        ('act3', 6, 421, 4),
        ('horario_act3', 272, 421, 4),

        ('total_horas', 518, 330, 4),
        ('fecha_emision', 474, 257, 9)

) AS t(nombre_campo, x, y, font)
JOIN itculiacan_fdw.campos_documento c
  ON c.id_tipo_doc = 8
 AND c.nombre_campo = t.nombre_campo;

-- Posiciones para el tipo de documento 9 (Carta de Exclusividad Laboral)
INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size)
SELECT 9, c.id_campo, 0, t.x, t.y, t.font
FROM (
    VALUES
        ('nombre',            217, 197, 11),
        ('filiacion',          67, 216, 11),
        ('clave_presupuestal',502, 212, 7.7)
) AS t(nombre_campo, x, y, font)
JOIN itculiacan_fdw.campos_documento c
  ON c.id_tipo_doc = 9
 AND c.nombre_campo = t.nombre_campo;

-- Posiciones para el tipo de documento 10 (Constancia Actualización CVU)
INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size)
SELECT 10, c.id_campo, 0, t.x, t.y, t.font
FROM (
    VALUES
        ('nombre',        130, 367, 7.5),
        ('fecha_emision', 460, 190, 8),
        ('registro',      348, 367, 7.5)
) AS t(nombre_campo, x, y, font)
JOIN itculiacan_fdw.campos_documento c
  ON c.id_tipo_doc = 10
 AND c.nombre_campo = t.nombre_campo;

-- Posiciones para el tipo de documento 11 (Constancia de Carga Académica)
INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size)
SELECT 11, c.id_campo, 0, t.x, t.y, t.font
FROM (
    VALUES ('nombre',40,304,7), ('expediente',230,304,9)
) AS t(nombre_campo, x, y, font)
JOIN itculiacan_fdw.campos_documento c 
  ON c.id_tipo_doc = 11 
 AND c.nombre_campo = t.nombre_campo;

INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size)
SELECT 11, c.id_campo, 0, t.x, t.y, 9
FROM (
    VALUES
        ('periodo1',85,375), ('nivel1',156,375), ('clave1',236,375), ('materia1',300,375), ('alumnos1',496,375),
        ('periodo2',85,387), ('nivel2',156,387), ('clave2',236,387), ('materia2',300,387), ('alumnos2',496,387),
        ('periodo3',85,399), ('nivel3',156,399), ('clave3',236,399), ('materia3',300,399), ('alumnos3',496,399)
) AS t(nombre_campo, x, y)
JOIN itculiacan_fdw.campos_documento c
  ON c.id_tipo_doc = 11
 AND c.nombre_campo = t.nombre_campo;

INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size)
SELECT 11, c.id_campo, 0, t.x, t.y, 9
FROM (
    VALUES
        ('periodo4',85,413), ('nivel4',156,413), ('clave4',236,413), ('materia4',300,413), ('alumnos4',496,413),
        ('periodo5',85,425), ('nivel5',156,425), ('clave5',236,425), ('materia5',300,425), ('alumnos5',496,425),
        ('periodo6',85,437), ('nivel6',156,437), ('clave6',236,437), ('materia6',300,437), ('alumnos6',496,437)
) AS t(nombre_campo, x, y)
JOIN itculiacan_fdw.campos_documento c
  ON c.id_tipo_doc = 11
 AND c.nombre_campo = t.nombre_campo;

INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size)
SELECT 11, id_campo, 0, 475, 478, 9
FROM itculiacan_fdw.campos_documento
WHERE id_tipo_doc = 11
  AND nombre_campo = 'total';


-- ===============================
-- Posición del QR en TODAS las plantillas
-- ===============================
INSERT INTO posiciones_pdf (id_tipo_doc, id_campo, pagina, x, y, font_size) VALUES
  (1,  (SELECT id_campo FROM itculiacan_fdw.campos_documento WHERE id_tipo_doc=1 AND nombre_campo='qr_firma'), 0, 400, 350, 0),
  (2,  (SELECT id_campo FROM itculiacan_fdw.campos_documento WHERE id_tipo_doc=2 AND nombre_campo='qr_firma'), 0, 400, 350, 0),
  (3,  (SELECT id_campo FROM itculiacan_fdw.campos_documento WHERE id_tipo_doc=3 AND nombre_campo='qr_firma'), 0, 400, 350, 0),
  (4,  (SELECT id_campo FROM itculiacan_fdw.campos_documento WHERE id_tipo_doc=4 AND nombre_campo='qr_firma'), 0, 400, 350, 0),
  (5,  (SELECT id_campo FROM itculiacan_fdw.campos_documento WHERE id_tipo_doc=5 AND nombre_campo='qr_firma'), 0, 400, 350, 0),
  (6,  (SELECT id_campo FROM itculiacan_fdw.campos_documento WHERE id_tipo_doc=6 AND nombre_campo='qr_firma'), 0, 400, 350, 0),
  (7,  (SELECT id_campo FROM itculiacan_fdw.campos_documento WHERE id_tipo_doc=7 AND nombre_campo='qr_firma'), 0, 400, 350, 0),
  (8,  (SELECT id_campo FROM itculiacan_fdw.campos_documento WHERE id_tipo_doc=8 AND nombre_campo='qr_firma'), 0, 400, 350, 0),
  (9,  (SELECT id_campo FROM itculiacan_fdw.campos_documento WHERE id_tipo_doc=9 AND nombre_campo='qr_firma'), 0, 400, 350, 0),
  (10, (SELECT id_campo FROM itculiacan_fdw.campos_documento WHERE id_tipo_doc=10 AND nombre_campo='qr_firma'), 0, 400, 350, 0),
  (11, (SELECT id_campo FROM itculiacan_fdw.campos_documento WHERE id_tipo_doc=11 AND nombre_campo='qr_firma'), 0, 400, 350, 0);
