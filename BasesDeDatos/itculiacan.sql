CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE areas (
  id_area SERIAL PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  tipo_area VARCHAR(50) CHECK (tipo_area IN (
    'Dirección', 'Subdirección', 'Departamento', 'División', 'Centro', 'Oficina', 'Comité'
  )),
  id_superior INT NULL,
  FOREIGN KEY (id_superior) REFERENCES areas(id_area)
);

CREATE TABLE cargos (
  id_cargo SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  nivel_jerarquico INT DEFAULT 1
);

CREATE TABLE personal (
  id_personal SERIAL PRIMARY KEY,
  nombres VARCHAR(50) NOT NULL,
  apellidopat VARCHAR(30) NOT NULL,
  apellidomat VARCHAR(30),
  email VARCHAR(100),
  telefono VARCHAR(10),
  tipo_personal VARCHAR(50) CHECK (tipo_personal IN ('Docente', 'Administrativo', 'Directivo', 'Apoyo')),
  grado_estudios VARCHAR(100),
  estatus VARCHAR(30) DEFAULT 'VIGENTE',
  id_area INT NOT NULL,
  id_cargo INT NOT NULL,

  CONSTRAINT ck_tel CHECK (
    telefono IS NULL OR (telefono ~ '^[0-9]{10}$')
  ),

  CONSTRAINT ck_email CHECK (
      email IS NULL OR (
          email NOT LIKE '% %'
          AND email LIKE '%@%._%'
          AND email NOT LIKE '%@%@%'
          AND email NOT LIKE '@%'
          AND email NOT LIKE '%@.%'
          AND email NOT LIKE '%.@%'
      )
  ),

  FOREIGN KEY (id_area) REFERENCES areas(id_area),
  FOREIGN KEY (id_cargo) REFERENCES cargos(id_cargo)
);

CREATE TABLE recursos_humanos (
    id_rh SERIAL PRIMARY KEY,
    id_personal INT NOT NULL,
    tipo_contrato VARCHAR(50) CHECK (tipo_contrato IN ('Base', 'Interino', 'Honorarios')),
	por_horas INT CHECK (por_horas IN (40,30,20,10)),
    fecha_ingreso DATE,
    fecha_salida DATE,
    salario DECIMAL(10,2),
    rfc VARCHAR(20) UNIQUE NOT NULL,
    curp VARCHAR(20),
    nss VARCHAR(20),
    observaciones TEXT,
    FOREIGN KEY (id_personal) REFERENCES personal(id_personal)
);

CREATE TABLE carreras (
  id_carrera SERIAL PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  clave VARCHAR(20) UNIQUE NOT NULL,
  nivel VARCHAR(50) CHECK (nivel IN ('Licenciatura', 'Maestría', 'Doctorado')),
  id_departamento INT NOT NULL,
  FOREIGN KEY (id_departamento) REFERENCES areas(id_area)
);

CREATE TABLE materias (
  id_materia SERIAL PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  clave VARCHAR(20) UNIQUE,
  creditos INT NOT NULL,
  horas_semana INT NOT NULL,
  id_carrera INT NOT NULL,
  FOREIGN KEY (id_carrera) REFERENCES carreras(id_carrera)
);

CREATE TABLE estudiantes (
  numerocontrol VARCHAR(18) PRIMARY KEY,
  nombres VARCHAR(50) NOT NULL,
  apellidopat VARCHAR(30) NOT NULL,
  apellidomat VARCHAR(30),
  correo_institucional VARCHAR(120),
  semestre INT NOT NULL,
  id_carrera INT NOT NULL,
  estatus VARCHAR(20) DEFAULT 'VIGENTE',
  FOREIGN KEY (id_carrera) REFERENCES carreras(id_carrera)
);

CREATE TABLE grupos (
  id_grupo SERIAL PRIMARY KEY,
  clave_grupo VARCHAR(20) NOT NULL,
  periodo VARCHAR(20),
  id_materia INT NOT NULL,
  id_docente INT NOT NULL,
  FOREIGN KEY (id_materia) REFERENCES materias(id_materia),
  FOREIGN KEY (id_docente) REFERENCES personal(id_personal)
);

CREATE TABLE calificaciones (
  id_calificacion SERIAL PRIMARY KEY,
  numerocontrol VARCHAR(18) NOT NULL,
  id_grupo INT NOT NULL,
  calificacion INT NOT NULL,
  observaciones TEXT,
  FOREIGN KEY (numerocontrol) REFERENCES estudiantes(numerocontrol),
  FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo)
);

CREATE TABLE roles (
  id_rol SERIAL PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL
);

CREATE TABLE usuarios (
  id_usuario SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  contrasena VARCHAR(200) NOT NULL,
  id_personal INT NOT NULL,
  id_rol INT NOT NULL,
  activo BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (id_personal) REFERENCES personal(id_personal),
  FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);

CREATE TABLE categorias_edd (
  id_categoria SERIAL PRIMARY KEY,
  nombre VARCHAR(200) NOT NULL,
  descripcion TEXT
);

CREATE TABLE tipos_documento (
  id_tipo_doc SERIAL PRIMARY KEY,
  id_categoria INT,
  nombre_doc VARCHAR(100) NOT NULL,
  descripcion TEXT,
  plantilla_archivo VARCHAR(255),
  requiere_firmas BOOLEAN DEFAULT FALSE,
  num_firmas INT DEFAULT 0,
  FOREIGN KEY (id_categoria) REFERENCES categorias_edd(id_categoria)
);

CREATE TABLE documentos_generados (
  id_documento SERIAL PRIMARY KEY,
  id_tipo_doc INT NOT NULL,
  id_docente INT,
  fecha_creacion DATE DEFAULT NOW(),
  estado VARCHAR(20) DEFAULT 'En proceso',
  archivo_final VARCHAR(255),
  FOREIGN KEY (id_tipo_doc) REFERENCES tipos_documento(id_tipo_doc),
  FOREIGN KEY (id_docente) REFERENCES personal(id_personal)
);

CREATE TABLE campos_documento (
  id_campo SERIAL PRIMARY KEY,
  id_tipo_doc INT NOT NULL,
  nombre_campo VARCHAR(100) NOT NULL,
  tipo_dato VARCHAR(50) DEFAULT 'Texto',
  obligatorio BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (id_tipo_doc) REFERENCES tipos_documento(id_tipo_doc)
);

CREATE TABLE valores_documento (
  id_valor SERIAL PRIMARY KEY,
  id_documento INT NOT NULL,
  id_campo INT NOT NULL,
  valor TEXT,
  FOREIGN KEY (id_documento) REFERENCES documentos_generados(id_documento),
  FOREIGN KEY (id_campo) REFERENCES campos_documento(id_campo)
);

CREATE TABLE firmas_documento (
  id_firma_doc SERIAL PRIMARY KEY,
  id_documento INT NOT NULL,
  id_firma INT NOT NULL,
  orden INT NOT NULL,
  firmo BOOLEAN DEFAULT FALSE,
  fecha_firma DATE,
  FOREIGN KEY (id_documento) REFERENCES documentos_generados(id_documento),
  FOREIGN KEY (id_firma) REFERENCES personal(id_personal)
);

-- AREAS
CREATE INDEX ix_areas_nombre ON areas(nombre);
CREATE INDEX ix_areas_superior ON areas(id_superior);

-- PERSONAL
CREATE INDEX ix_personal_area ON personal(id_area);
CREATE INDEX ix_personal_cargo ON personal(id_cargo);
CREATE INDEX ix_personal_tipo ON personal(tipo_personal);
CREATE INDEX ix_personal_email ON personal(email);

-- RECURSOS HUMANOS
CREATE UNIQUE INDEX ix_rh_rfc ON recursos_humanos(rfc);
CREATE INDEX ix_rh_tipo_contrato ON recursos_humanos(tipo_contrato);
CREATE INDEX ix_rh_fecha_ingreso ON recursos_humanos(fecha_ingreso);

-- CARRERAS Y MATERIAS
CREATE INDEX ix_carreras_nombre ON carreras(nombre);
CREATE INDEX ix_materias_carrera ON materias(id_carrera);
CREATE INDEX ix_materias_clave ON materias(clave);

-- ESTUDIANTES
CREATE INDEX ix_estudiantes_carrera ON estudiantes(id_carrera);
CREATE INDEX ix_estudiantes_semestre ON estudiantes(semestre);
CREATE INDEX ix_estudiantes_correo ON estudiantes(correo_institucional);

-- GRUPOS
CREATE INDEX ix_grupos_docente ON grupos(id_docente);
CREATE INDEX ix_grupos_materia ON grupos(id_materia);
CREATE INDEX ix_grupos_periodo ON grupos(periodo);

-- CALIFICACIONES
CREATE INDEX ix_calif_estudiante ON calificaciones(numerocontrol);
CREATE INDEX ix_calif_grupo ON calificaciones(id_grupo);
CREATE INDEX ix_calif_calificacion ON calificaciones(calificacion);

-- USUARIOS Y ROLES
CREATE INDEX ix_usuarios_personal ON usuarios(id_personal);
CREATE INDEX ix_usuarios_rol ON usuarios(id_rol);
CREATE INDEX ix_roles_nombre ON roles(nombre);

-- DOCUMENTOS
CREATE INDEX ix_docs_tipo ON tipos_documento(nombre_doc);
CREATE INDEX ix_docs_cat ON tipos_documento(id_categoria);
CREATE INDEX ix_docs_docente ON documentos_generados(id_docente);
CREATE INDEX ix_docs_estado ON documentos_generados(estado);
CREATE INDEX ix_valores_doc ON valores_documento(id_documento);
CREATE INDEX ix_valores_campo ON valores_documento(id_campo);

CREATE VIEW v_datos_laborales_actual AS
SELECT 
    p.id_personal,
    p.nombres,
    p.apellidopat,
    p.apellidomat,
    p.tipo_personal,
    p.estatus,
    
    a.nombre AS area,
    a.tipo_area,

    c.nombre AS cargo,
    c.nivel_jerarquico,

    rh.tipo_contrato,
    rh.por_horas,
    rh.fecha_ingreso,
    rh.fecha_salida,
    rh.salario,
    
    rh.rfc,
    rh.curp,
    rh.nss,

    rh.observaciones
FROM personal p
JOIN areas a ON a.id_area = p.id_area
JOIN cargos c ON c.id_cargo = p.id_cargo
LEFT JOIN recursos_humanos rh ON rh.id_personal = p.id_personal;

-- PARA GUARDAR QR
ALTER TABLE documentos_generados
  ADD COLUMN qr_text TEXT;
-- ================================
