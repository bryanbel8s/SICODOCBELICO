CREATE DATABASE itculiacan
GO

USE itculiacan
GO

CREATE TABLE areas (
  id_area INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(150) NOT NULL,
  tipo_area NVARCHAR(50) CHECK (tipo_area IN (
    'Dirección', 'Subdirección', 'Departamento', 'División', 'Centro', 'Oficina', 'Comité'
  )),
  id_superior INT NULL,
  FOREIGN KEY (id_superior) REFERENCES areas(id_area)
)
GO

CREATE TABLE cargos (
  id_cargo INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(100) NOT NULL,
  nivel_jerarquico INT DEFAULT 1
)
GO

CREATE TABLE personal (
  id_personal INT IDENTITY(1,1) PRIMARY KEY,
  nombres NVARCHAR(50) NOT NULL,
  apellidopat NVARCHAR(30) NOT NULL,
  apellidomat NVARCHAR(30) NULL,
  email NVARCHAR(100) NULL,
  telefono NVARCHAR(10) NULL,
  tipo_personal NVARCHAR(50) CHECK (tipo_personal IN ('Docente', 'Administrativo', 'Directivo', 'Apoyo')),
  grado_estudios NVARCHAR(100),
  estatus NVARCHAR(30) DEFAULT 'VIGENTE',
  id_area INT NOT NULL,
  id_cargo INT NOT NULL,
  CONSTRAINT CK_Tel CHECK (telefono IS NULL OR (telefono NOT LIKE '%[^0-9]%' AND LEN(telefono) = 10)),
  CONSTRAINT CK_Email CHECK (
        email IS NULL OR (
            email NOT LIKE '% %' AND
            email LIKE '%@%._%' AND
            email NOT LIKE '%@%@%' AND
            email NOT LIKE '@%' AND
            email NOT LIKE '%@.%' AND
            email NOT LIKE '%.@%'
        )
  ),
  FOREIGN KEY (id_area) REFERENCES areas(id_area),
  FOREIGN KEY (id_cargo) REFERENCES cargos(id_cargo)
)
GO

CREATE TABLE Recursos_Humanos (
    id_rh INT IDENTITY(1,1) PRIMARY KEY,
    id_personal INT NOT NULL,
    tipo_contrato NVARCHAR(50) CHECK (tipo_contrato IN ('Base', 'Interino', 'Honorarios', 'Tiempo Completo', 'Tiempo Parcial')),
    fecha_ingreso DATE,
    fecha_salida DATE NULL,
    salario DECIMAL(10,2),
    tipo_nomina NVARCHAR(50),
    rfc NVARCHAR(20) NOT NULL UNIQUE,
    curp NVARCHAR(20),
    nss NVARCHAR(20),
    observaciones NVARCHAR(MAX),
    FOREIGN KEY (id_personal) REFERENCES personal(id_personal)
)
GO

CREATE TABLE carreras (
  id_carrera INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(150) NOT NULL,
  clave NVARCHAR(20) UNIQUE NOT NULL,
  nivel NVARCHAR(50) CHECK (nivel IN ('Licenciatura', 'Maestría', 'Doctorado')),
  id_departamento INT NOT NULL,
  FOREIGN KEY (id_departamento) REFERENCES areas(id_area)
)
GO

CREATE TABLE materias (
  id_materia INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(150) NOT NULL,
  clave NVARCHAR(20) UNIQUE,
  creditos INT NOT NULL,
  horas_semana INT NOT NULL,
  id_carrera INT NOT NULL,
  FOREIGN KEY (id_carrera) REFERENCES carreras(id_carrera)
)
GO

CREATE TABLE estudiantes (
  numerocontrol NVARCHAR(18) PRIMARY KEY,
  nombres NVARCHAR(50) NOT NULL,
  apellidopat NVARCHAR(30) NOT NULL,
  apellidomat NVARCHAR(30) NULL,
  correo_institucional NVARCHAR(120),
  semestre INT NOT NULL,
  id_carrera INT NOT NULL,
  estatus NVARCHAR(20) DEFAULT 'VIGENTE',
  FOREIGN KEY (id_carrera) REFERENCES carreras(id_carrera)
)
GO

CREATE TABLE grupos (
  id_grupo INT IDENTITY(1,1) PRIMARY KEY,
  clave_grupo NVARCHAR(20) NOT NULL,
  periodo NVARCHAR(20),
  id_materia INT NOT NULL,
  id_docente INT NOT NULL,
  FOREIGN KEY (id_materia) REFERENCES materias(id_materia),
  FOREIGN KEY (id_docente) REFERENCES personal(id_personal)
)
GO

CREATE TABLE calificaciones (
  id_calificacion INT IDENTITY(1,1) PRIMARY KEY,
  numerocontrol NVARCHAR(18) NOT NULL,
  id_grupo INT NOT NULL,
  calificacion INT NOT NULL,
  observaciones NVARCHAR(MAX),
  FOREIGN KEY (numerocontrol) REFERENCES estudiantes(numerocontrol),
  FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo)
)
GO

CREATE TABLE roles (
  id_rol INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE usuarios (
  id_usuario INT IDENTITY(1,1) PRIMARY KEY,
  username NVARCHAR(50) UNIQUE NOT NULL,
  contrasena NVARCHAR(200) NOT NULL,
  id_personal INT NOT NULL,
  id_rol INT NOT NULL,
  activo BIT DEFAULT 1,
  FOREIGN KEY (id_personal) REFERENCES personal(id_personal),
  FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
)
GO

CREATE TABLE categorias_edd (
  id_categoria INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(200) NOT NULL,
  descripcion NVARCHAR(MAX) NULL
)
GO

CREATE TABLE tipos_documento (
  id_tipo_doc INT IDENTITY(1,1) PRIMARY KEY,
  id_categoria INT NULL,
  nombre_doc NVARCHAR(100) NOT NULL,
  descripcion NVARCHAR(MAX),
  plantilla_archivo NVARCHAR(255),
  requiere_firmas BIT DEFAULT 0,
  num_firmas INT DEFAULT 0,
  FOREIGN KEY (id_categoria) REFERENCES categorias_edd(id_categoria)
)
GO

CREATE TABLE documentos_generados (
  id_documento INT IDENTITY(1,1) PRIMARY KEY,
  id_tipo_doc INT NOT NULL,
  id_docente INT NULL,
  fecha_creacion DATE DEFAULT GETDATE(),
  estado NVARCHAR(20) DEFAULT 'En proceso',
  archivo_final NVARCHAR(255),
  FOREIGN KEY (id_tipo_doc) REFERENCES tipos_documento(id_tipo_doc),
  FOREIGN KEY (id_docente) REFERENCES personal(id_personal)
)
GO

CREATE TABLE campos_documento (
  id_campo INT IDENTITY(1,1) PRIMARY KEY,
  id_tipo_doc INT NOT NULL,
  nombre_campo NVARCHAR(100) NOT NULL,
  tipo_dato NVARCHAR(50) DEFAULT 'Texto',
  obligatorio BIT DEFAULT 0,
  FOREIGN KEY (id_tipo_doc) REFERENCES tipos_documento(id_tipo_doc)
)
GO

CREATE TABLE valores_documento (
  id_valor INT IDENTITY(1,1) PRIMARY KEY,
  id_documento INT NOT NULL,
  id_campo INT NOT NULL,
  valor NVARCHAR(MAX),
  FOREIGN KEY (id_documento) REFERENCES documentos_generados(id_documento),
  FOREIGN KEY (id_campo) REFERENCES campos_documento(id_campo)
)
GO

CREATE TABLE firmas_documento (
  id_firma_doc INT IDENTITY(1,1) PRIMARY KEY,
  id_documento INT NOT NULL,
  id_firma INT NOT NULL,
  orden INT NOT NULL,
  firmo BIT DEFAULT 0,
  fecha_firma DATE,
  FOREIGN KEY (id_documento) REFERENCES documentos_generados(id_documento),
  FOREIGN KEY (id_firma) REFERENCES personal(id_personal)
)
GO

--NUEVA TABLA 
CREATE TABLE datos_laborales (
    id_laboral INT IDENTITY(1,1) PRIMARY KEY,
    id_personal INT NOT NULL,

    categoria_actual NVARCHAR(200),
    horas_actual INT,
    estatus_actual NVARCHAR(50),

    categoria_anterior NVARCHAR(200),
    horas_anterior INT,
    estatus_anterior NVARCHAR(50),

    clave_presupuestal NVARCHAR(100),
    fecha_efectos DATE,

    porcentaje_asistencia INT,

    fecha_actualizacion DATE DEFAULT GETDATE(),

    FOREIGN KEY (id_personal) REFERENCES personal(id_personal)
)
GO


-- ==============================
-- 🔹 Índices para AREAS
-- ==============================
-- Búsqueda rápida por nombre o jerarquía
CREATE INDEX IX_AREAS_NOMBRE ON areas(nombre)
CREATE INDEX IX_AREAS_SUPERIOR ON areas(id_superior)

-- ==============================
-- 🔹 Índices para PERSONAL
-- ==============================
-- Búsquedas frecuentes por área y tipo de personal
CREATE INDEX IX_PERSONAL_AREA ON personal(id_area)
CREATE INDEX IX_PERSONAL_CARGO ON personal(id_cargo)
CREATE INDEX IX_PERSONAL_TIPO ON personal(tipo_personal)
CREATE INDEX IX_PERSONAL_EMAIL ON personal(email)

-- ==============================
-- 🔹 Índices para RECURSOS HUMANOS
-- ==============================
-- Búsquedas por RFC y tipo de contrato
CREATE UNIQUE INDEX IX_RH_RFC ON Recursos_Humanos(rfc)
CREATE INDEX IX_RH_TIPO_CONTRATO ON Recursos_Humanos(tipo_contrato)
CREATE INDEX IX_RH_FECHA_INGRESO ON Recursos_Humanos(fecha_ingreso)

-- ==============================
-- 🔹 Índices para CARRERAS y MATERIAS
-- ==============================
CREATE INDEX IX_CARRERAS_NOMBRE ON carreras(nombre)
CREATE INDEX IX_MATERIAS_CARRERA ON materias(id_carrera)
CREATE INDEX IX_MATERIAS_CLAVE ON materias(clave)

-- ==============================
-- 🔹 Índices para ESTUDIANTES
-- ==============================
CREATE INDEX IX_ESTUDIANTES_CARRERA ON estudiantes(id_carrera)
CREATE INDEX IX_ESTUDIANTES_SEMESTRE ON estudiantes(semestre)
CREATE INDEX IX_ESTUDIANTES_CORREO ON estudiantes(correo_institucional)

-- ==============================
-- 🔹 Índices para GRUPOS
-- ==============================
CREATE INDEX IX_GRUPOS_DOCENTE ON grupos(id_docente)
CREATE INDEX IX_GRUPOS_MATERIA ON grupos(id_materia)
CREATE INDEX IX_GRUPOS_PERIODO ON grupos(periodo)

-- ==============================
-- 🔹 Índices para CALIFICACIONES
-- ==============================
CREATE INDEX IX_CALIF_ESTUDIANTE ON calificaciones(numerocontrol)
CREATE INDEX IX_CALIF_GRUPO ON calificaciones(id_grupo)
CREATE INDEX IX_CALIF_CALIFICACION ON calificaciones(calificacion)

-- ==============================
-- 🔹 Índices para USUARIOS y ROLES
-- ==============================
CREATE INDEX IX_USUARIOS_PERSONAL ON usuarios(id_personal)
CREATE INDEX IX_USUARIOS_ROL ON usuarios(id_rol)
CREATE INDEX IX_ROLES_NOMBRE ON roles(nombre)

-- ==============================
-- 🔹 Índices para DOCUMENTOS
-- ==============================
CREATE INDEX IX_DOCS_TIPO ON tipos_documento(nombre_doc)
CREATE INDEX IX_DOCS_CAT ON tipos_documento(id_categoria)
CREATE INDEX IX_DOCS_DOCENTE ON documentos_generados(id_docente)
CREATE INDEX IX_DOCS_ESTADO ON documentos_generados(estado)
CREATE INDEX IX_VALORES_DOC ON valores_documento(id_documento)
CREATE INDEX IX_VALORES_CAMPO ON valores_documento(id_campo)
GO


-- ----- ÁREAS (IDs controlados para referencias fáciles) -----
SET IDENTITY_INSERT areas ON 
INSERT INTO areas(id_area, nombre, tipo_area, id_superior) VALUES
 (1, 'Dirección', 'Dirección', NULL),
 (2, 'Subdirección Académica', 'Subdirección', 1),
 (3, 'Subdirección de Planeación y Vinculación', 'Subdirección', 1),
 (4, 'Subdirección de Servicios Administrativos', 'Subdirección', 1),

 -- Departamentos dependientes de Subdirección Académica
 (10, 'Departamento de Ingeniería en Sistemas Computacionales', 'Departamento', 2),
 (11, 'Departamento de Ingeniería Industrial', 'Departamento', 2),
 (12, 'Departamento de Ingeniería Mecánica', 'Departamento', 2),
 (13, 'Departamento de Ingeniería Eléctrica', 'Departamento', 2),
 (14, 'Departamento de Ingeniería Electrónica', 'Departamento', 2),
 (15, 'Departamento de Ingeniería Bioquímica', 'Departamento', 2),
 (16, 'Departamento de Ingeniería en Energías Renovables', 'Departamento', 2),
 (17, 'Departamento de Gestión Empresarial', 'Departamento', 2),
 (18, 'Departamento de Ingeniería en Innovación Agrícola Sustentable', 'Departamento', 2),
 (19, 'Departamento de Ingeniería Mecatrónica', 'Departamento', 2),
 (20, 'Departamento de Ingeniería Ambiental', 'Departamento', 2),

 -- Oficinas y servicios bajo Servicios Administrativos
 (30, 'Oficina de Servicios Escolares', 'Oficina', 4),
 (31, 'Oficina de Recursos Humanos', 'Oficina', 4),
 (32, 'Centro de Cómputo', 'Centro', 4),
 (33, 'Oficina de Tesorería', 'Oficina', 4) 
SET IDENTITY_INSERT areas OFF 
GO

-- ----- CARGOS -----
SET IDENTITY_INSERT cargos ON 
INSERT INTO cargos(id_cargo, nombre, nivel_jerarquico) VALUES
 (1, 'Director', 1),
 (2, 'Subdirector', 2),
 (3, 'Jefe de Departamento', 3),
 (4, 'Coordinador', 4),
 (5, 'Docente', 5),
 (6, 'Auxiliar Administrativo', 6) 
SET IDENTITY_INSERT cargos OFF 
GO

-- ----- PERSONAL (nombres genéricos + estilo institucional) -----
INSERT INTO personal (nombres, apellidopat, apellidomat, email, telefono, tipo_personal, grado_estudios, estatus, id_area, id_cargo)
VALUES
('Juan', 'Pérez', 'González', 'juan.perez@itculiacan.edu.mx', '6671234567', 'Directivo', 'Maestría', 'VIGENTE', 1, 1),
('María', 'López', 'Ramírez', 'maria.lopez@itculiacan.edu.mx', '6672345678', 'Directivo', 'Maestría', 'VIGENTE', 2, 2),
('Carlos', 'Sánchez', 'Torres', 'carlos.sanchez@itculiacan.edu.mx', '6673456789', 'Docente', 'Doctorado', 'VIGENTE', 10, 5),
('Ana', 'García', 'Muñoz', 'ana.garcia@itculiacan.edu.mx', '6674567890', 'Docente', 'Maestría', 'VIGENTE', 11, 5),
('Luis', 'Ramírez', 'Flores', 'luis.ramirez@itculiacan.edu.mx', '6675678901', 'Docente', 'Maestría', 'VIGENTE', 12, 5),
('Mariana', 'Hernández', 'Soto', 'mariana.hernandez@itculiacan.edu.mx', '6676789012', 'Docente', 'Maestría', 'VIGENTE', 13, 5),
('José', 'Martínez', 'Ortiz', 'jose.martinez@itculiacan.edu.mx', '6677890123', 'Docente', 'Maestría', 'VIGENTE', 14, 5),
('Lucía', 'Torres', 'Vega', 'lucia.torres@itculiacan.edu.mx', '6678901234', 'Docente', 'Maestría', 'VIGENTE', 15, 5),
('Pedro', 'Núñez', 'Lara', 'pedro.nunez@itculiacan.edu.mx', '6679012345', 'Docente', 'Maestría', 'VIGENTE', 16, 5),
('Verónica', 'Cruz', 'Delgado', 'veronica.cruz@itculiacan.edu.mx', '6670123456', 'Docente', 'Maestría', 'VIGENTE', 17, 5),
('Miguel', 'Vargas', 'Ríos', 'miguel.vargas@itculiacan.edu.mx', '6671122334', 'Administrativo', 'Licenciatura', 'VIGENTE', 31, 6),
('Sofía', 'Ramírez', 'Paredes', 'sofia.ramirez@itculiacan.edu.mx', '6672233445', 'Administrativo', 'Licenciatura', 'VIGENTE', 30, 6),
('Eduardo', 'Molina', 'Sánchez', 'eduardo.molina@itculiacan.edu.mx', '6673344556', 'Apoyo', 'Licenciatura', 'VIGENTE', 32, 6),
('Patricia', 'Vega', 'Castro', 'patricia.vega@itculiacan.edu.mx', '6674455667', 'Docente', 'Maestría', 'VIGENTE', 19, 5),
('Héctor', 'Salas', 'Cárdenas', 'hector.salas@itculiacan.edu.mx', '6675566778', 'Docente', 'Doctorado', 'VIGENTE', 20, 5) 
GO

-- ----- RECURSOS_HUMANOS (RFCs realistas, CURP y NSS) -----
INSERT INTO Recursos_Humanos (id_personal, tipo_contrato, fecha_ingreso, salario, tipo_nomina, rfc, curp, nss, observaciones)
VALUES
(1, 'Base', '2010-08-01', 45000.00, 'Mensual',   'PEGJ750101A01', 'PEGJ750101HSLRNJ01', '08712345001', 'Director activo'),
(2, 'Base', '2012-01-15', 38000.00, 'Mensual',   'LORM780223A02', 'LORM780223MCLPNR02', '08723456002', 'Subdirectora'),
(3, 'Base', '2015-07-01', 22000.00, 'Quincenal', 'SATO820315A03', 'SATO820315HCLRRN03', '08734567003', ''),
(4, 'Tiempo Completo', '2018-09-05', 20000.00, 'Quincenal', 'GAMU850412A04', 'GAMU850412MCLSNV04', '08745678004', ''),
(5, 'Tiempo Completo', '2017-02-20', 20000.00, 'Quincenal', 'RAFL900519A05', 'RAFL900519HSLRDS05', '08756789005', ''),
(6, 'Honorarios', '2019-03-10', 18000.00, 'Honorarios', 'HESM910617A06', 'HESM910617MCLRRN06', '08767890006', ''),
(7, 'Base', '2016-05-12', 19500.00, 'Quincenal', 'MAOJ920824A07', 'MAOJ920824HCLRTN07', '08778901007', ''),
(8, 'Base', '2014-11-01', 21000.00, 'Quincenal', 'TOVE931002A08', 'TOVE931002MCLSRN08', '08789012008', ''),
(9, 'Interino', '2020-01-10', 19000.00, 'Quincenal', 'NULA950115A09', 'NULA950115HCLRTG09', '08790123009', ''),
(10, 'Base', '2013-06-15', 20500.00, 'Quincenal', 'CRDV970220A10', 'CRDV970220MCLLRN10', '08701234010', ''),
(11, 'Interino', '2021-08-01', 12000.00, 'Quincenal', 'VARM980504A11', 'VARM980504HSLRRN11', '08711223011', ''),
(12, 'Interino', '2022-03-05', 12000.00, 'Quincenal', 'RAPA990710A12', 'RAPA990710MCLPNR12', '08722334012', ''),
(13, 'Tiempo Parcial', '2023-04-10', 10000.00, 'Quincenal', 'MOSN000823A13', 'MOSN000823HSLRRN13', '08733445013', ''),
(14, 'Base', '2011-09-01', 19800.00, 'Quincenal', 'VECP010930A14', 'VECP010930MCLLRN14', '08744556014', ''),
(15, 'Base', '2010-12-10', 21500.00, 'Quincenal', 'SACH021115A15', 'SACH021115HSLRRN15', '08755667015', '') 
GO

-- ----- CARRERAS (12) -----
SET IDENTITY_INSERT carreras ON 
INSERT INTO carreras(id_carrera, nombre, clave, nivel, id_departamento) VALUES
 (1,  'Ingeniería Ambiental', 'ING-AMBI', 'Licenciatura', 20),
 (2,  'Ingeniería Bioquímica', 'ING-BIOQ', 'Licenciatura', 15),
 (3,  'Ingeniería Eléctrica', 'ING-ELEC', 'Licenciatura', 13),
 (4,  'Ingeniería Electrónica', 'ING-ELNA', 'Licenciatura', 14),
 (5,  'Ingeniería en Energías Renovables', 'ING-RENR', 'Licenciatura', 16),
 (6,  'Ingeniería en Gestión Empresarial', 'ING-GEMP', 'Licenciatura', 17),
 (7,  'Ingeniería Industrial', 'ING-IND', 'Licenciatura', 11),
 (8,  'Ingeniería en Innovación Agrícola Sustentable', 'ING-AGR', 'Licenciatura', 18),
 (9,  'Ingeniería Mecánica', 'ING-MEC', 'Licenciatura', 12),
 (10, 'Ingeniería Mecatrónica', 'ING-MECT', 'Licenciatura', 19),
 (11, 'Ingeniería en Sistemas Computacionales', 'ING-SIST', 'Licenciatura', 10),
 (12, 'Ingeniería en Tecnologías de la Información y Comunicaciones', 'ING-TIC', 'Licenciatura', 10) 
SET IDENTITY_INSERT carreras OFF 
GO

-- ----- MATERIAS (6 por cada carrera = 72) -----
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
('Administración de Sistemas','TIC106',4,2,12) 
GO

-- ----- ESTUDIANTES (10 por carrera, numerocontrol AA + 17 + ####  AA en 21..25 aleatorio) -----
DECLARE @c INT = 1, @i INT, @carrera INT 
DECLARE @year2 CHAR(2), @nc VARCHAR(18), @random4 VARCHAR(4) 
WHILE @c <= 12
BEGIN
  SET @carrera = @c 
  SET @i = 1 
  WHILE @i <= 10
  BEGIN
    -- año aleatorio entre 2021 y 2025 -> '21'..'25'
    SET @year2 = RIGHT(CAST((21 + (ABS(CHECKSUM(NEWID())) % 5)) AS VARCHAR(2)), 2) 
    SET @random4 = RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS VARCHAR(4)), 4) 
    SET @nc = @year2 + '17' + @random4 

    INSERT INTO estudiantes (numerocontrol, nombres, apellidopat, apellidomat, correo_institucional, semestre, id_carrera, estatus)
    VALUES (
      @nc,
      'Alumno' + CAST(@c AS VARCHAR(2)) + '-' + CAST(@i AS VARCHAR(2)),
      'ApellidoP' + CAST(@c AS VARCHAR(2)),
      'ApellidoM' + CAST(@i AS VARCHAR(2)),
      LOWER('a' + CAST(@c AS VARCHAR(2)) + CAST(@i AS VARCHAR(2)) + '@alumno.itculiacan.edu.mx'),
      1, @carrera, 'VIGENTE'
    ) 

    SET @i = @i + 1 
  END
  SET @c = @c + 1 
END
GO

-- ----- GRUPOS (1 por materia, docente rotado) -----
INSERT INTO grupos (clave_grupo, periodo, id_materia, id_docente)
SELECT 'G-' + CAST(m.id_materia AS VARCHAR(6)) AS clave_grupo,
       '2025-1' AS periodo,
       m.id_materia,
       ((m.id_materia % 13) + 3)  -- docentes en personal id 3..15
FROM materias m 
GO

-- ----- CALIFICACIONES (ejemplo: 60 filas aleatorias sobre la 1ª materia de cada carrera) -----
INSERT INTO calificaciones (numerocontrol, id_grupo, calificacion, observaciones)
SELECT TOP (60)
       e.numerocontrol,
       g.id_grupo,
       70 + (ABS(CHECKSUM(NEWID())) % 31),
       NULL
FROM estudiantes e
JOIN grupos g ON g.id_materia IN (SELECT MIN(id_materia) FROM materias GROUP BY id_carrera) 
GO

-- ----- CAT/ TIPOS/ DOCUMENTOS GENERADOS (en itculiacan) -----
INSERT INTO categorias_edd (nombre, descripcion)
VALUES ('Constancias', 'Constancias y reconocimientos') 

INSERT INTO tipos_documento (id_categoria, nombre_doc, descripcion, plantilla_archivo, requiere_firmas, num_firmas)
VALUES (1, 'Constancia de Participación', 'Constancia para docentes participantes', NULL, 1, 2),
       (1, 'Carta Compromiso', 'Carta compromiso para actividades', NULL, 1, 1),
       (1, 'Informe de Actividades', 'Informe resumido de actividades', NULL, 0, 0) 
GO

-- Documento generado para un docente (usamos id_personal 3..)
INSERT INTO documentos_generados (id_tipo_doc, id_docente, fecha_creacion, estado, archivo_final)
VALUES (1, 3, GETDATE(), 'En proceso', NULL),
       (2, 4, GETDATE(), 'En proceso', NULL),
       (3, 5, GETDATE(), 'En proceso', NULL) 
GO

INSERT INTO campos_documento (id_tipo_doc, nombre_campo, tipo_dato, obligatorio)
VALUES (1, 'Nombre del Docente', 'Texto', 1),
       (1, 'Actividad', 'Texto', 1),
       (1, 'Fecha', 'Fecha', 1) 
GO

INSERT INTO valores_documento (id_documento, id_campo, valor) VALUES
 (1, 1, 'Carlos Sánchez'),
 (1, 2, 'Taller de Innovación'),
 (1, 3, CONVERT(NVARCHAR(30), GETDATE(), 23)) 
GO

INSERT INTO firmas_documento (id_documento, id_firma, orden, firmo, fecha_firma)
VALUES
 (1, 3, 1, 0, NULL),  -- Docente (id_personal 3)
 (1, 1, 2, 0, NULL)   -- Director (id_personal 1)
GO