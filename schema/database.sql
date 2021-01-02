/* https://www.postgresql.org/docs/13/datatype.html */
/* \i file.sql */
/* \d table_tame */
/* list tables \dt 8*/


/**************** USERS AUTHENTICATION ************************/
drop table if exists rol;
drop table if exists periodo;
drop table if exists estado_convocatoria;
drop table if exists convocatoria;
drop table if exists estado_documento;
drop table if exists tipo_documento;
drop table if exists puntaje_tipo_documento;
drop table if exists documento_solicitud;
drop table if exists facultad;
drop table if exists proyecto_curricular;
drop table if exists estudiante;
drop table if exists estado_solicitud;
drop table if exists solicitud;
drop table if exists historico_solicitud;
drop table if exists convocatoria_facultad;
drop table if exists tipo_subsidio;
drop table if exists tipo_subsidio_convocatoria;
drop table if exists beneficiario;
drop table if exists ticket;
drop table if exists estado_actividad;
drop table if exists actividad;
drop table if exists actividad_beneficiario;
drop table if exists parametro;

/**************** CONVOCATORIA ************************/

create table periodo(
  id_periodo serial primary key,
  nombre varchar(10) not null unique,
  descripcion varchar(200) ,
  fecha_inicio timestamp not null,
  fecha_fin timestamp not null constraint chk_periodo_feacha_fin_greater_fecha_inicio check(fecha_fin>fecha_inicio),
  semanas_periodo integer  generated always as (trunc(date_part('day'::text,fecha_fin-fecha_inicio)/7)) stored
);

create table estado_convocatoria(
  id_estado_convocatoria serial primary key,
  estado varchar(30) not null,
  descripcion varchar(200)
);

create table convocatoria(
  id_convocatoria serial primary key,
  fecha_inicio date not null,
  fecha_fin date not null constraint chk_convocatoria_fecha_fin_greater_fecha_inicio check(fecha_fin>fecha_inicio),
  id_periodo integer not null unique,
  id_estado_convocatoria integer not null,
  foreign key(id_periodo) references periodo(id_periodo),
  foreign key(id_estado_convocatoria) references estado_convocatoria(id_estado_convocatoria)
);


/**************** ESTUDIANTES ************************/

create table estado_documento(
  id_estado_documento serial primary key,
  nombre varchar(30) not null,
  descripcion varchar(200)
);

create table tipo_documento(
  id_tipo_documento serial primary key,
  obligatorio numeric(1,0) check(obligatorio in(0, 1)) not null,
  nombre varchar(200)
);

create table puntaje_tipo_documento(
  id_puntaje_tipo_documento serial primary key,
  nombre varchar(200) not null,
  id_tipo_documento integer not null,
  puntaje smallint not null constraint chk_documento_puntaje_greater_than_zero check(puntaje>=0 and puntaje <=100),
  foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento)
);

create table facultad(
  id_facultad serial primary key,
  nombre varchar(50) not null
);

create table proyecto_curricular(
  id_proyecto_curricular serial primary key,
  id_facultad integer not null,
  nombre varchar(200) not null,
  foreign key(id_facultad) references facultad(id_facultad)
);

create table estudiante(
  id_estudiante serial primary key,
  identificacion varchar(30) unique not null,
  nombre1 varchar(50) not null,
  nombre2 varchar(50),
  apellido1 varchar(50) not null,
  apellido2 varchar(50),
  promedio numeric(3,2) constraint chk_estudiante_promedio_greater_in_zero_five_range check(promedio >=0 and promedio <=5.0),
  matriculas_restantes smallint default 10,
  email varchar(100),
  id_proyecto_curricular integer not null,
  foreign key(id_proyecto_curricular) references proyecto_curricular(id_proyecto_curricular)
);

/**************** SOLICITUD APOYO ALIMENTARIO ************************/

create table estado_solicitud(
  id_estado_solicitud serial primary key,
  estado varchar(30) not null,
  descripcion varchar(200)
);
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 1, 'en progreso', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 2, 'completada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 3, 'rechazada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 4, 'cancelada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 5, 'aprobada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 6, 'requiere cambios', '');

create table solicitud(
  id_solicitud serial primary key,
  id_estudiante integer not null,
  puntaje smallint constraint chk_puntaje_in_zero_hundred_range check(puntaje >=0 and puntaje <=100),
  ultima_actualizacion timestamp not null default current_timestamp,
  id_estado_solicitud integer default 1,
  id_convocatoria integer not null,
  foreign key (id_convocatoria) references convocatoria(id_convocatoria),
  foreign key (id_estado_solicitud) references estado_solicitud(id_estado_solicitud),
  foreign key (id_estudiante) references estudiante(id_estudiante),
  unique(id_convocatoria, id_estudiante)
);

create table historico_solicitud(
  id_historico_solicitud serial primary key,
  id_solicitud integer not null,
  id_estado_solicitud integer not null,
  foreign key(id_estado_solicitud) references estado_solicitud(id_estado_solicitud),
  foreign key(id_solicitud) references solicitud(id_solicitud),
  fecha timestamp not null
);

create table documento_solicitud(
  id_solicitud integer not null,
  id_puntaje_tipo_documento integer,
  id_estado_documento integer default 1,
  id_tipo_documento integer not null,
  comentarios varchar(300),
  url varchar(200) not null,
  foreign key(id_estado_documento) references estado_documento(id_estado_documento),
  foreign key(id_solicitud) references solicitud(id_solicitud) on delete cascade,
  foreign key(id_puntaje_tipo_documento) references puntaje_tipo_documento(id_puntaje_tipo_documento),
  foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento),
  primary key(id_solicitud, id_tipo_documento)
);

/**************** PUNTAJES Y SUBSIDIOS ************************/

create table tipo_subsidio(
  id_tipo_subsidio serial primary key,
  nombre varchar(30) not null,
  descripcion varchar(200),
  porcentaje_subsidiado smallint not null constraint chk_tipo_subsidiado_porcentaje_in_zero_hundred_range check(porcentaje_subsidiado>=0 and porcentaje_subsidiado<=100),
  puntos_requeridos  smallint not null constraint chk_tipo_subsidiado_puntos_requeridos_greater_than_zero check( puntos_requeridos>=0),
  horas_semanales_a_cumplir smallint not null
);

create table convocatoria_facultad(
  id_facultad  integer not null,
  id_convocatoria integer not null,
  cantidad_de_almuerzos smallint not null constraint chk_convocatoria_facultad_cantidad_almuerzos_greater_than_zero check(cantidad_de_almuerzos>=0),
  primary key(id_facultad, id_convocatoria),
  foreign key( id_convocatoria) references convocatoria(id_convocatoria)  on delete cascade,
  foreign key( id_facultad) references facultad(id_facultad)
);

create table tipo_subsidio_convocatoria(
  id_convocatoria integer not null,
  id_tipo_subsidio integer not null,
  cantidad_de_almuerzos_ofertados  smallint constraint chk_subsidio_periodo_cantidad_almuerzos_positive check(cantidad_de_almuerzos_ofertados>=0),
  foreign key( id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio),
  foreign key (id_convocatoria) references convocatoria(id_convocatoria) on delete cascade,
  primary key(id_tipo_subsidio, id_convocatoria)
);

/**************** TICKET and BENEFICIARIO ************************/
create table beneficiario(
  id_beneficiario serial primary key,
  id_tipo_subsidio integer not null,
  id_solicitud integer not null,
  foreign key (id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio),
  foreign key (id_solicitud) references solicitud(id_solicitud)
);

create table ticket(
  id_ticket serial primary key,
  id_beneficiario integer not null,
  fecha_creacion timestamp default current_timestamp,
  fecha_uso timestamp,
  tipo_ticket varchar(15) constraint chk_ticket_tipo_in_defined_types check(tipo_ticket in('refrigerio', 'almuerzo')),
  foreign key (id_beneficiario) references beneficiario(id_beneficiario)
);

/**************** ACTIVIDADES ************************/

create table estado_actividad(
  id_estado_actividad serial primary key,
  nombre varchar(200) not null,
  descripcion varchar(2000)
);

create table actividad(
  id_actividad serial primary key,
  nombre varchar(200) not null,
  descripcion varchar(1000),
  horas_equivalentes smallint not null constraint chk_actividad_horas_positive check(horas_equivalentes >=0)
);

create table actividad_beneficiario(
  id_actividad_beneficiario serial primary key,
  id_beneficiario integer,
  id_actividad integer,
  id_estado_actividad integer,
  foreign key (id_estado_actividad) references estado_actividad(id_estado_actividad),
  foreign key (id_actividad) references actividad(id_actividad),
  foreign key (id_beneficiario) references beneficiario(id_beneficiario)
);

/**************** PARAMETROS ************************/

create table parametro(
  id_parametro serial primary key,
  nombre_tabla varchar(30),
  clave varchar(100),
  valor varchar(100)
);

/**************** FUNCIONARIOS ************************/

create table funcionario(
  id_funcionario serial primary key,
  identificacion varchar(30) unique not null,
  nombre1 varchar(50) not null,
  nombre2 varchar(50),
  apellido1 varchar(50) not null,
  apellido2 varchar(50),
  email varchar(100)
);

