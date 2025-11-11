
CREATE DATABASE itculiacan
GO
USE itculiacan
GO

CREATE TABLE areas (
  id_area INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(150) NOT NULL,
  tipo_area NVARCHAR(50) CHECK (tipo_area IN (
    'Direcci�n', 'Subdirecci�n', 'Departamento', 'Divisi�n', 'Centro', 'Oficina', 'Comit�'
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
  nivel NVARCHAR(50) CHECK (nivel IN ('Licenciatura', 'Maestr�a', 'Doctorado')),
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
