-- =========================================
-- AREAS
-- =========================================
INSERT INTO areas (id_area, nombre, tipo_area, id_superior) VALUES
  (1,  'Dirección',                                   'Dirección',   NULL),
  (2,  'Subdirección Académica',                     'Subdirección', 1),
  (3,  'Subdirección de Planeación y Vinculación',   'Subdirección', 1),
  (4,  'Subdirección de Servicios Administrativos',  'Subdirección', 1),

  -- Departamentos académicos
  (10, 'Departamento de Ingeniería en Sistemas Computacionales', 'Departamento', 2),
  (11, 'Departamento de Ingeniería Industrial',                  'Departamento', 2),
  (12, 'Departamento de Ingeniería Mecánica',                    'Departamento', 2),
  (13, 'Departamento de Ingeniería Eléctrica',                   'Departamento', 2),
  (14, 'Departamento de Ingeniería Electrónica',                 'Departamento', 2),
  (15, 'Departamento de Ingeniería Bioquímica',                  'Departamento', 2),
  (16, 'Departamento de Ingeniería en Energías Renovables',      'Departamento', 2),
  (17, 'Departamento de Ingeniería en Gestión Empresarial',      'Departamento', 2),
  (18, 'Departamento de Ingeniería en Innovación Agrícola Sustentable', 'Departamento', 2),
  (19, 'Departamento de Ingeniería Mecatrónica',                 'Departamento', 2),
  (20, 'Departamento de Ingeniería Ambiental',                   'Departamento', 2),

  -- Oficinas y servicios administrativos
  (30, 'Oficina de Servicios Escolares',         'Oficina', 4),
  (31, 'Oficina de Recursos Humanos',            'Oficina', 4),
  (32, 'Centro de Cómputo',                      'Centro',  4),
  (33, 'Oficina de Tesorería',                   'Oficina', 4),
  (34, 'Oficina de Recursos Financieros',        'Oficina', 4),
  (35, 'Oficina de Recursos Materiales y Servicios', 'Oficina', 4),
  (36, 'Oficina de Mantenimiento y Equipo',      'Oficina', 4),
  (37, 'Centro de Información',                  'Centro',  4),
  (38, 'Departamento de Comunicación y Difusión','Departamento', 3),
  (39, 'División de Estudios Profesionales',     'Departamento', 2),
  (40, 'Desarrollo Académico',                   'Departamento', 2),
  (41, 'División de Estudios de Posgrado e Investigación', 'Departamento', 2),
  (42, 'Área de Calidad',                        'Oficina', 1);

-- Ajustar secuencia por si luego insertas sin id_area
SELECT setval('areas_id_area_seq', (SELECT MAX(id_area) FROM areas));

-- =========================================
-- CARGOS
-- =========================================
INSERT INTO cargos (id_cargo, nombre, nivel_jerarquico) VALUES
  (1, 'Director',             1),
  (2, 'Subdirector',          2),
  (3, 'Jefe de Departamento', 3),
  (4, 'Coordinador',          4),
  (5, 'Docente',              5),
  (6, 'Auxiliar Administrativo', 6);

SELECT setval('cargos_id_cargo_seq', (SELECT MAX(id_cargo) FROM cargos));

-- =========================================
-- PERSONAL (DIRECTORA, SUBS, JEFES, COORDS, DOCENTES, TU EQUIPO)
-- =========================================
INSERT INTO personal
(id_personal, nombres, apellidopat, apellidomat, email, telefono,
 tipo_personal, grado_estudios, estatus, id_area, id_cargo)
VALUES
-- 1  Directora
(1, 'Francisca', 'Piña', 'Zazueta',
 'dir_culiacan@tecnm.mx', '6671000001',
 'Administrativo', 'Maestría', 'VIGENTE', 1, 1),

-- 2  Subdirector de Planeación y Vinculación
(2, 'Eduardo Antonio', 'Alonso', 'Astorga',
 'plan_culiacan@tecnm.mx', '6671000002',
 'Administrativo', 'Maestría', 'VIGENTE', 3, 2),

-- 3  Subdirectora de Servicios Administrativos
(3, 'Marcela', 'Valdez', 'Barreras',
 'admon_culiacan@tecnm.mx', '6671000003',
 'Administrativo', 'Maestría', 'VIGENTE', 4, 2),

-- 4  Subdirectora Académica
(4, 'Bertha Lucía', 'Patrón', 'Arellano',
 'acad_culiacan@tecnm.mx', '6671000004',
 'Administrativo', 'Maestría', 'VIGENTE', 2, 2),

-- 5  Jefa de Planeación, Programación y Presupuestación
(5, 'Roberto', 'León', 'Piña',
 'pl_culiacan@tecnm.mx', '6671000005',
 'Administrativo', 'Maestría', 'VIGENTE', 3, 3),

-- 6  Jefe de Gestión Tecnológica y Vinculación
(6, 'Raúl Alfonso', 'Ayón', 'Félix',
 'vin_culiacan@tecnm.mx', '6671000006',
 'Administrativo', 'Maestría', 'VIGENTE', 3, 3),

-- 7  Jefa de Comunicación y Difusión
(7, 'Cristal Gabriela', 'Ramírez', 'Escobar',
 'comunicacion@culiacan.tecnm.mx', '6671000007',
 'Administrativo', 'Licenciatura', 'VIGENTE', 38, 3),

-- 8  Jefa de Servicios Escolares
(8, 'Dinorah', 'Meza', 'García',
 'se_culiacan@tecnm.mx', '6671000008',
 'Administrativo', 'Licenciatura', 'VIGENTE', 30, 3),

-- 9  Jefe de Actividades Extraescolares
(9, 'José Alfredo', 'Gastélum', 'Ríos',
 'extraescolares@culiacan.tecnm.mx', '6671000009',
 'Administrativo', 'Licenciatura', 'VIGENTE', 30, 3),

-- 10 Jefe de Centro de Información
(10, 'Jesús Ramón', 'Favela', 'Bueno',
 'cinformacion@culiacan.tecnm.mx', '6671000010',
 'Administrativo', 'Licenciatura', 'VIGENTE', 37, 3),

-- 11 Jefa de Recursos Humanos
(11, 'Laura Liliana', 'Barraza', 'Cárdenas',
 'rh_culiacan@tecnm.mx', '6671000011',
 'Administrativo', 'Licenciatura', 'VIGENTE', 31, 3),

-- 12 Jefa de Recursos Financieros
(12, 'Nohemí', 'Hidalgo', 'Beltrán',
 'recursosfinancieros@itculiacan.edu.mx', '6671000012',
 'Administrativo', 'Licenciatura', 'VIGENTE', 34, 3),

-- 13 Jefe de Recursos Materiales y Servicios
(13, 'Juan Enrique', 'Palacios', 'Quintero',
 'rm_culiacan@tecnm.mx', '6671000013',
 'Administrativo', 'Licenciatura', 'VIGENTE', 35, 3),

-- 14 Jefe de Mantenimiento y Equipo
(14, 'José Gabriel', 'Castro', 'Ochoa',
 'mantenimiento@culiacan.tecnm.mx', '6671000014',
 'Administrativo', 'Licenciatura', 'VIGENTE', 36, 3),

-- 15 Jefe de Centro de Cómputo
(15, 'Luis Ernesto', 'Lizárraga', 'Bolaños',
 'ccomputo@culiacan.tecnm.mx', '6671000015',
 'Administrativo', 'Licenciatura', 'VIGENTE', 32, 3),

-- 16 Jefa de Desarrollo Académico
(16, 'María Hidaelia', 'Sánchez', 'López',
 'desarrolloacademico@culiacan.tecnm.mx', '6671000016',
 'Administrativo', 'Maestría', 'VIGENTE', 40, 3),

-- 17 Jefa de División de Estudios Profesionales
(17, 'Concepción', 'Mendoza', 'Rosales',
 'divestudios@itculiacan.edu.mx', '6671000017',
 'Administrativo', 'Maestría', 'VIGENTE', 39, 3),

-- 18 Jefe de División de Posgrado e Investigación
(18, 'Emigdio Alberto', 'Burgueño', 'Rendón',
 'posgrado@culiacan.tecnm.mx', '6671000018',
 'Administrativo', 'Doctorado', 'VIGENTE', 41, 3),

-- 19 Representante de Dirección del Área de Calidad
(19, 'Itzel Guadalupe', 'Urías', 'Ramírez',
 'rd@itculiacan.edu.mx', '6671000019',
 'Administrativo', 'Maestría', 'VIGENTE', 42, 3),

-- 20 Jefa de Sistemas y Computación
(20, 'Marisol', 'Manjarrez', 'Beltrán',
 'sistemas@culiacan.tecnm.mx', '6671000020',
 'Administrativo', 'Maestría', 'VIGENTE', 10, 3),

-- 21 Jefa de Ingeniería Química-Bioquímica (la mapeamos a Bioquímica)
(21, 'Brenda Libertad', 'Díaz', 'López',
 'bioquimica@culiacan.tecnm.mx', '6671000021',
 'Administrativo', 'Maestría', 'VIGENTE', 15, 3),

-- 22 Jefa de Ingeniería Industrial
(22, 'Dora Esthela', 'García', 'Velarde',
 'industrial@culiacan.tecnm.mx', '6671000022',
 'Administrativo', 'Maestría', 'VIGENTE', 11, 3),

-- 23 Jefe de Metal-Mecánica (lo mapeamos a Mecánica)
(23, 'José Ángel', 'Alcaraz', 'Vega',
 'mecanica@culiacan.tecnm.mx', '6671000023',
 'Administrativo', 'Maestría', 'VIGENTE', 12, 3),

-- 24 Jefe de Ingeniería Eléctrica-Electrónica (mapeado a Eléctrica)
(24, 'Luis Alberto', 'Domínguez', 'Inzunza',
 'electricaelectronica@culiacan.tecnm.mx', '6671000024',
 'Administrativo', 'Maestría', 'VIGENTE', 13, 3),

-- 25 Jefe de Ciencias Económico-Administrativas (mapeado a Gestión)
(25, 'Armando', 'Salazar', 'López',
 'ecoadministrativas@culiacan.tecnm.mx', '6671000025',
 'Administrativo', 'Maestría', 'VIGENTE', 17, 3),

-- 26 Jefe de Ciencias Básicas (lo mapeamos a Ambiental solo para tener área)
(26, 'Carlos Rafael', 'Lizárraga', 'Arreola',
 'cienciasbasicas@culiacan.tecnm.mx', '6671000026',
 'Administrativo', 'Maestría', 'VIGENTE', 20, 3),

-- 27 Coordinador Ing. Ambiental y Bioquímica (área Ambiental)
(27, 'Elthon', 'Vega', 'Álvarez',
 'coordbioquimica@itculiacan.edu.mx', '6671000027',
 'Administrativo', 'Maestría', 'VIGENTE', 20, 4),

-- 28 Coordinador Ing. Eléctrica/Electrónica/Energías Renovables
(28, 'Eliseo', 'Juárez', 'López',
 'coordinacion.ieer@culiacan.tecnm.mx', '6671000028',
 'Administrativo', 'Maestría', 'VIGENTE', 13, 4),

-- 29 Coordinador Ing. en Gestión Empresarial
(29, 'Guillermo', 'Beltrán', 'Morales',
 'coordinadorige@itculiacan.edu.mx', '6671000029',
 'Administrativo', 'Maestría', 'VIGENTE', 17, 4),

-- 30 Coordinador Ing. Industrial
(30, 'Samael', 'Mendívil', 'Méndez',
 'coorindustrial@itculiacan.edu.mx', '6671000030',
 'Administrativo', 'Maestría', 'VIGENTE', 11, 4),

-- 31 Coordinador Ing. Mecánica
(31, 'Segundo', 'Castañeda', 'Gallo',
 'coormecanica@itculiacan.edu.mx', '6671000031',
 'Administrativo', 'Maestría', 'VIGENTE', 12, 4),

-- 32 Coordinador Ing. Mecatrónica
(32, 'Everd Luis', 'Cázares', 'Domínguez',
 'coormecatronica@itculiacan.edu.mx', '6671000032',
 'Administrativo', 'Maestría', 'VIGENTE', 19, 4),

-- 33 Coordinadora ISC/TIC
(33, 'Edna Rocío', 'Barajas', 'Olivas',
 'coorsistemas@itculiacan.edu.mx', '6671000033',
 'Administrativo', 'Maestría', 'VIGENTE', 10, 4),

-- 34 Coord. Maestría en Ciencias de la Computación
(34, 'Víctor Manuel', 'Bátiz', 'Beltrán',
 'coordinadormcc@culiacan.tecnm.mx', '6671000034',
 'Administrativo', 'Doctorado', 'VIGENTE', 41, 4),

-- 35 Coord. Maestría en Ciencias de la Ingeniería
(35, 'María Guadalupe', 'Alarcón', 'Inzunza',
 'coordinadormci@culiacan.tecnm.mx', '6671000035',
 'Administrativo', 'Doctorado', 'VIGENTE', 41, 4),

-- 36 Coord. Doctorado en Ciencias de la Ingeniería
(36, 'Rosa Icela', 'Amador', 'Cázarez',
 'coordinadordci@itculiacan.edu.mx', '6671000036',
 'Administrativo', 'Doctorado', 'VIGENTE', 41, 4),

----------------------------------------------------
-- DOCENTES DE SISTEMAS (ISC / TIC)
----------------------------------------------------
-- 37 Norma Rebeca Godoy Castro
(37, 'Norma Rebeca', 'Godoy', 'Castro',
 'norma.gc@culiacan.tecnm.mx', '6672000001',
 'Docente', 'Maestría', 'VIGENTE', 10, 5),

-- 38 Catalina de la Luz Sosa Ochoa
(38, 'Catalina de la Luz', 'Sosa', 'Ochoa',
 'catalina.so@culiacan.tecnm.mx', '6672000002',
 'Docente', 'Maestría', 'VIGENTE', 10, 5),

-- 39 Arcelia Judith Bustillos Martínez
(39, 'Arcelia Judith', 'Bustillos', 'Martínez',
 'arcelia.bm@culiacan.tecnm.mx', '6672000003',
 'Docente', 'Maestría', 'VIGENTE', 10, 5),

-- 40 Gualberto Leyva Gutiérrez
(40, 'Gualberto', 'Leyva', 'Gutiérrez',
 'gualberto.lg@culiacan.tecnm.mx', '6672000004',
 'Docente', 'Maestría', 'VIGENTE', 10, 5),

-- 41 Ricardo Rafael Quintero Meza
(41, 'Ricardo Rafael', 'Quintero', 'Meza',
 'ricardo.qm@culiacan.tecnm.mx', '6672000005',
 'Docente', 'Maestría', 'VIGENTE', 10, 5),

-- 42 Edgar Cervantes López
(42, 'Edgar', 'Cervantes', 'López',
 'edgar.cl@culiacan.tecnm.mx', '6672000006',
 'Docente', 'Maestría', 'VIGENTE', 10, 5),

-- 43 María del Rosario González Álvarez
(43, 'María del Rosario', 'González', 'Álvarez',
 'maria.ga@culiacan.tecnm.mx', '6672000007',
 'Docente', 'Maestría', 'VIGENTE', 10, 5),

-- 44 Elizabeth Ceceña Niebla
(44, 'Elizabeth', 'Ceceña', 'Niebla',
 'elizabeth.cn@culiacan.tecnm.mx', '6672000008',
 'Docente', 'Maestría', 'VIGENTE', 10, 5),

-- 45 Leopoldo Zenaido Zepeda Sánchez
(45, 'Leopoldo Zenaido', 'Zepeda', 'Sánchez',
 'leopoldo.zs@culiacan.tecnm.mx', '6672000009',
 'Docente', 'Maestría', 'VIGENTE', 10, 5),

-- 46 Martín Leonardo Nevárez Rivas
(46, 'Martín Leonardo', 'Nevárez', 'Rivas',
 'martin.nr@culiacan.tecnm.mx', '6672000010',
 'Docente', 'Maestría', 'VIGENTE', 10, 5),

-- 47 Daniel Esparza Soto
(47, 'Daniel', 'Esparza', 'Soto',
 'daniel.es@culiacan.tecnm.mx', '6672000011',
 'Docente', 'Maestría', 'VIGENTE', 10, 5),

----------------------------------------------------
-- TU EQUIPO COMO DOCENTES DE ISC
----------------------------------------------------
-- 48 José Ernesto Ayala Rodríguez
(48, 'José Ernesto', 'Ayala', 'Rodríguez',
 'jose.ar@culiacan.tecnm.mx', '6673000001',
 'Docente', 'Licenciatura', 'VIGENTE', 10, 5),

-- 49 Edgar Ramón Beltrán López
(49, 'Edgar Ramón', 'Beltrán', 'López',
 'edgar.bl@culiacan.tecnm.mx', '6673000002',
 'Docente', 'Licenciatura', 'VIGENTE', 10, 5),

-- 50 Jeylen Isaí García Félix
(50, 'Jeylen Isaí', 'García', 'Félix',
 'jeylen.gf@culiacan.tecnm.mx', '6673000003',
 'Docente', 'Licenciatura', 'VIGENTE', 10, 5),

-- 51 Bryan Alexis Nájera Beltrán
(51, 'Bryan Alexis', 'Nájera', 'Beltrán',
 'bryan.nb@culiacan.tecnm.mx', '6673000004',
 'Docente', 'Licenciatura', 'VIGENTE', 10, 5),

-- 52 Hiram Noriega Melendres
(52, 'Hiram', 'Noriega', 'Melendres',
 'hiram.nm@culiacan.tecnm.mx', '6673000005',
 'Docente', 'Licenciatura', 'VIGENTE', 10, 5),

-- 53 José Luis Valenzuela Araujo
(53, 'José Luis', 'Valenzuela', 'Araujo',
 'joseluis.va@culiacan.tecnm.mx', '6673000006',
 'Docente', 'Licenciatura', 'VIGENTE', 10, 5);

SELECT setval('personal_id_personal_seq', (SELECT MAX(id_personal) FROM personal));

-- =========================================
-- CARRERAS
-- =========================================
INSERT INTO carreras (id_carrera, nombre, clave, nivel, id_departamento) VALUES
 (1,  'Ingeniería Ambiental',  'ING-AMBI', 'Licenciatura', 20),
 (2,  'Ingeniería Bioquímica', 'ING-BIOQ', 'Licenciatura', 15),
 (3,  'Ingeniería Eléctrica',  'ING-ELEC', 'Licenciatura', 13),
 (4,  'Ingeniería Electrónica','ING-ELNA', 'Licenciatura', 14),
 (5,  'Ingeniería en Energías Renovables','ING-RENR','Licenciatura',16),
 (6,  'Ingeniería en Gestión Empresarial','ING-GEMP','Licenciatura',17),
 (7,  'Ingeniería Industrial', 'ING-IND',  'Licenciatura', 11),
 (8,  'Ingeniería en Innovación Agrícola Sustentable','ING-AGR','Licenciatura',18),
 (9,  'Ingeniería Mecánica',   'ING-MEC',  'Licenciatura', 12),
 (10, 'Ingeniería Mecatrónica','ING-MECT', 'Licenciatura', 19),
 (11, 'Ingeniería en Sistemas Computacionales','ING-SIST','Licenciatura',10),
 (12, 'Ingeniería en Tecnologías de la Información y Comunicaciones','ING-TIC','Licenciatura',10);

SELECT setval('carreras_id_carrera_seq', (SELECT MAX(id_carrera) FROM carreras));

-- =========================================
-- MATERIAS (6 POR CARRERA)
-- =========================================
INSERT INTO materias (nombre, clave, creditos, horas_semana, id_carrera)
VALUES
-- 1) Ambiental
('Química Ambiental','AMB101',6,4,1),
('Gestión Ambiental','AMB102',5,3,1),
('Hidrología','AMB103',5,3,1),
('Procesos de Tratamiento','AMB104',6,4,1),
('Manejo de Residuos','AMB105',4,3,1),
('Normatividad Ambiental','AMB106',3,2,1),

-- 2) Bioquímica
('Bioquímica General','BIOQ101',6,4,2),
('Microbiología','BIOQ102',5,3,2),
('Procesos Bioquímicos','BIOQ103',6,4,2),
('Ingeniería de Bioprocesos','BIOQ104',5,3,2),
('Enzimología','BIOQ105',4,2,2),
('Control de Calidad','BIOQ106',3,2,2),

-- 3) Eléctrica
('Circuitos Eléctricos','ELEC101',6,4,3),
('Máquinas Eléctricas','ELEC102',5,3,3),
('Sistemas de Potencia','ELEC103',6,4,3),
('Instalaciones Eléctricas','ELEC104',4,2,3),
('Control de Motores','ELEC105',4,2,3),
('Electrónica de Potencia','ELEC106',3,2,3),

-- 4) Electrónica
('Electrónica Analógica','ELNA101',6,4,4),
('Sistemas Embebidos','ELNA102',5,3,4),
('Comunicaciones','ELNA103',6,4,4),
('Control','ELNA104',4,2,4),
('Diseño Digital','ELNA105',4,2,4),
('Instrumentación','ELNA106',3,2,4),

-- 5) Energías Renovables
('Energías Renovables','REN101',6,4,5),
('Fuentes Solares','REN102',5,3,5),
('Sistemas Eólicos','REN103',5,3,5),
('Almacenamiento Energético','REN104',4,2,5),
('Análisis de Proyectos','REN105',4,2,5),
('Normatividad Energética','REN106',3,2,5),

-- 6) Gestión Empresarial
('Administración','GEMP101',6,4,6),
('Contabilidad','GEMP102',5,3,6),
('Gestión de Recursos','GEMP103',5,3,6),
('Marketing','GEMP104',4,2,6),
('Emprendimiento','GEMP105',4,2,6),
('Finanzas','GEMP106',3,2,6),

-- 7) Industrial
('Gestión de Producción','IND101',6,4,7),
('Taller de Manufactura','IND102',5,3,7),
('Ingeniería de Métodos','IND103',5,3,7),
('Logística','IND104',4,2,7),
('Seguridad Industrial','IND105',4,2,7),
('Planeación','IND106',3,2,7),

-- 8) Innovación Agrícola
('Agronomía Básica','AGR101',6,4,8),
('Suelos','AGR102',5,3,8),
('Manejo de Cultivos','AGR103',5,3,8),
('Irrigación','AGR104',4,2,8),
('Biotecnología Agrícola','AGR105',4,2,8),
('Economía Agrícola','AGR106',3,2,8),

-- 9) Mecánica
('Termodinámica','MEC101',6,4,9),
('Mecánica de Fluidos','MEC102',5,3,9),
('Diseño Mecánico','MEC103',6,4,9),
('Materiales','MEC104',4,2,9),
('Taller de Máquinas','MEC105',4,2,9),
('Dinámica','MEC106',3,2,9),

-- 10) Mecatrónica
('Robótica','MECT101',6,4,10),
('Control y Automatización','MECT102',5,3,10),
('Electrónica para Mecatrónica','MECT103',5,3,10),
('Sistemas Neumáticos','MECT104',4,2,10),
('Actuadores y Sensores','MECT105',4,2,10),
('Diseño de Máquinas','MECT106',3,2,10),

-- 11) Sistemas Computacionales
('Programación I','SIST101',6,4,11),
('Estructuras de Datos','SIST102',6,4,11),
('Sistemas Operativos','SIST103',5,3,11),
('Bases de Datos','SIST104',5,3,11),
('Programación II','SIST105',4,2,11),
('Redes de Computadoras','SIST106',4,2,11),

-- 12) TIC
('Introducción a TIC','TIC101',6,4,12),
('Redes y Comunicaciones','TIC102',6,4,12),
('Seguridad Informática','TIC103',5,3,12),
('Servicios en la Nube','TIC104',5,3,12),
('Desarrollo Web','TIC105',4,2,12),
('Administración de Sistemas','TIC106',4,2,12);

SELECT setval('materias_id_materia_seq', (SELECT MAX(id_materia) FROM materias));

-- =========================================
-- ESTUDIANTES (10 POR CARRERA, 12 CARRERAS = 120)
-- =========================================
DO $$
DECLARE
  c INT;
  i INT;
  year2 TEXT;
  nc TEXT;
  random4 TEXT;
BEGIN
  FOR c IN 1..12 LOOP
    FOR i IN 1..10 LOOP
      year2 := LPAD((21 + FLOOR(random()*5))::INT::TEXT, 2, '0');  -- 21..25
      random4 := LPAD(FLOOR(random()*10000)::INT::TEXT, 4, '0');
      nc := year2 || '17' || random4;

      INSERT INTO estudiantes
      (numerocontrol, nombres, apellidopat, apellidomat,
       correo_institucional, semestre, id_carrera, estatus)
      VALUES (
        nc,
        'Alumno' || c::TEXT || '-' || i::TEXT,
        'ApellidoP' || c::TEXT,
        'ApellidoM' || i::TEXT,
        LOWER('a' || c::TEXT || i::TEXT || '@alumno.itculiacan.edu.mx'),
        1,
        c,
        'VIGENTE'
      );
    END LOOP;
  END LOOP;
END $$;

-- =========================================
-- GRUPOS (1 POR MATERIA, DOCENTE ROTADO ENTRE IDS 37..53)
-- =========================================
INSERT INTO grupos (clave_grupo, periodo, id_materia, id_docente)
SELECT
  'G-' || m.id_materia::TEXT AS clave_grupo,
  '2025-1' AS periodo,
  m.id_materia,
  36 + ((m.id_materia - 1) % 17) + 1   -- rota entre 37 y 53
FROM materias m;

SELECT setval('grupos_id_grupo_seq', (SELECT MAX(id_grupo) FROM grupos));

-- =========================================
-- CALIFICACIONES (EJEMPLO, 80 REGISTROS RANDOM)
-- =========================================
INSERT INTO calificaciones (numerocontrol, id_grupo, calificacion, observaciones)
SELECT
  e.numerocontrol,
  g.id_grupo,
  60 + FLOOR(random()*41)::INT,  -- 60..100
  NULL::TEXT
FROM estudiantes e
JOIN grupos g
  ON g.id_materia IN (
       SELECT MIN(id_materia) FROM materias GROUP BY id_carrera
     )
ORDER BY random()
LIMIT 80;

SELECT setval('calificaciones_id_calificacion_seq', (SELECT MAX(id_calificacion) FROM calificaciones));

-- =========================================
-- ROLES (itculiacan)
-- =========================================
INSERT INTO roles (id_rol, nombre) VALUES
 (1, 'Administrador'),
 (2, 'Subdirector'),
 (3, 'Jefe de Departamento'),
 (4, 'Coordinador'),
 (5, 'Docente'),
 (6, 'Servicios Escolares');

SELECT setval('roles_id_rol_seq', (SELECT MAX(id_rol) FROM roles));

-- =========================================
-- USUARIOS (ligados a personal)
-- contrasena en texto plano por ahora (puedes luego cambiar a hash)
-- =========================================
INSERT INTO usuarios (username, contrasena, id_personal, id_rol, activo) VALUES
('dir_culiacan',   '12345678', 1, 1, TRUE),
('sub_academica',  '12345678', 4, 2, TRUE),
('sub_admin',      '12345678', 3, 2, TRUE),
('jefe_sistemas',  '12345678', 20, 3, TRUE),
('coord_isc_tic',  '12345678', 33, 4, TRUE),
('norma_gc',       '12345678', 37, 5, TRUE),
('se_escolares',   '12345678', 8, 6, TRUE);

SELECT setval('usuarios_id_usuario_seq', (SELECT MAX(id_usuario) FROM usuarios));

-- =========================================
-- RECURSOS HUMANOS (TODOS BASE)
-- =========================================
INSERT INTO recursos_humanos
(id_personal, tipo_contrato, por_horas, fecha_ingreso, fecha_salida, salario, rfc, curp, nss, observaciones)
VALUES
(1, 'Base', 40, '2010-01-10', NULL, 52000.00, 'FIPZ700101ABC', 'FIPZ700101HCLRZN01', '01234567891', NULL),
(2, 'Base', 40, '2012-03-15', NULL, 48000.00, 'EAAM800201BCD', 'EAAM800201HCLLNS02', '01234567892', NULL),
(3, 'Base', 40, '2013-05-20', NULL, 38000.00, 'RLPM750101CDE', 'RLPM750101HCLPNR03', '01234567893', NULL),
(4, 'Base', 40, '2014-08-10', NULL, 36000.00, 'RAAF820101DEF', 'RAAF820101HCLLPN04', '01234567894', NULL),
(5, 'Base', 40, '2015-09-12', NULL, 35000.00, 'RAAF830101EFG', 'RAAF830101HCLLPN05', '01234567895', NULL),
(6, 'Base', 40, '2016-02-11', NULL, 34000.00, 'CRRE900101FGH', 'CRRE900101HCLMSN06', '01234567896', NULL),
(7, 'Base', 40, '2014-06-01', NULL, 32500.00, 'DMGA850101GHI', 'DMGA850101HCLZNM07', '01234567897', NULL),
(8, 'Base', 40, '2011-07-18', NULL, 33000.00, 'JAGR910101HIJ', 'JAGR910101HCLLRV08', '01234567898', NULL),
(9, 'Base', 40, '2015-11-06', NULL, 31000.00, 'JRFB900101IJK', 'JRFB900101HCLVNL09', '01234567899', NULL),
(10, 'Base', 40, '2017-05-23', NULL, 32000.00, 'JGBR760101JKL', 'JGBR760101HCLGNS10', '01234567900', NULL),
(11, 'Base', 40, '2018-04-10', NULL, 34000.00, 'JGBM740101KLM', 'JGBM740101HCLNSL11', '01234567901', NULL),
(12, 'Base', 40, '2016-09-09', NULL, 30000.00, 'DMSC770101LMN', 'DMSC770101HCLRZN12', '01234567902', NULL),
(13, 'Base', 40, '2019-01-04', NULL, 29500.00, 'ECLL860101MNO', 'ECLL860101HCLGTD13', '01234567903', NULL),
(14, 'Base', 40, '2018-08-12', NULL, 29000.00, 'MGRL780101NOP', 'MGRL780101HCLGZN14', '01234567904', NULL),
(15, 'Base', 40, '2020-03-05', NULL, 28000.00, 'JAGF760101OPQ', 'JAGF760101HCLLRS15', '01234567905', NULL),
(16, 'Base', 40, '2019-05-20', NULL, 35000.00, 'JRFB750101PQR', 'JRFB750101HCLMRA16', '01234567906', NULL),
(17, 'Base', 40, '2017-09-15', NULL, 34500.00, 'JRAL720101QRS', 'JRAL720101HCLBVG17', '01234567907', NULL),
(18, 'Base', 40, '2016-10-01', NULL, 34000.00, 'NEHB690101RST', 'NEHB690101HCLDPN18', '01234567908', NULL),
(19, 'Base', 40, '2017-01-10', NULL, 33500.00, 'MVDB850101STU', 'MVDB850101HCLGPN19', '01234567909', NULL),
(20, 'Base', 40, '2021-01-15', NULL, 30000.00, 'JALV990101TUV', 'JALV990101HCLTRG20', '01234567910', NULL),
(21, 'Base', 40, '2021-01-15', NULL, 30000.00, 'DMSO750101UVW', 'DMSO750101HCLTRN21', '01234567911', NULL),
(22, 'Base', 40, '2020-07-18', NULL, 30000.00, 'LZZS650101VWX', 'LZZS650101HCLPMR22', '01234567912', NULL),
(23, 'Base', 40, '2019-08-10', NULL, 30500.00, 'MLNR800101WXY', 'MLNR800101HCLTRS23', '01234567913', NULL),
(24, 'Base', 40, '2018-03-21', NULL, 31000.00, 'DESO850101XYZ', 'DESO850101HCLPNR24', '01234567914', NULL),
(25, 'Base', 40, '2022-02-14', NULL, 29000.00, 'AYAR020101AAA', 'AYAR020101HCLJRN25', '01234567915', NULL),
(26, 'Base', 40, '2022-02-14', NULL, 29500.00, 'ERBL020101AAB', 'ERBL020101HCLJRN26', '01234567916', NULL),
(27, 'Base', 40, '2022-02-14', NULL, 29500.00, 'JFGL020101AAC', 'JFGL020101HCLJRN27', '01234567917', NULL),
(28, 'Base', 40, '2022-02-14', NULL, 29500.00, 'BNBL020101AAD', 'BNBL020101HCLJRN28', '01234567918', NULL),
(29, 'Base', 40, '2022-02-14', NULL, 29500.00, 'HNMN020101AAE', 'HNMN020101HCLJRN29', '01234567919', NULL),
(30, 'Base', 40, '2022-02-14', NULL, 29500.00, 'JLVA020101AAF', 'JLVA020101HCLJRN30', '01234567920', NULL),
(31, 'Base', 40, '2020-06-01', NULL, 28000.00, 'ECNN750101AAG', 'ECNN750101HCLZRN31', '01234567921', NULL),
(32, 'Base', 40, '2019-11-10', NULL, 28500.00, 'LZSS770101AAH', 'LZSS770101HCLMRN32', '01234567922', NULL),
(33, 'Base', 40, '2018-10-05', NULL, 28000.00, 'MLNR800101AAI', 'MLNR800101HCLVSN33', '01234567923', NULL),
(34, 'Base', 40, '2020-08-14', NULL, 28500.00, 'DESO850101AAJ', 'DESO850101HCLBTR34', '01234567924', NULL),
(35, 'Base', 40, '2021-03-10', NULL, 29000.00, 'ECNN750101AAK', 'ECNN750101HCLBSN35', '01234567925', NULL),
(36, 'Base', 40, '2021-05-16', NULL, 30500.00, 'LZSS770101AAL', 'LZSS770101HCLOPN36', '01234567926', NULL),
(37, 'Base', 40, '2022-01-01', NULL, 29500.00, 'RIAL860101AAM', 'RIAL860101HCLOPN37', '01234567927', NULL),
(38, 'Base', 40, '2020-04-11', NULL, 31000.00, 'IGUR870101AAN', 'IGUR870101HCLOPN38', '01234567928', NULL);
