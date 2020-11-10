/* https://www.postgresql.org/docs/13/datatype.html */
/* \i file.sql */
/* \d table_tame */
/* list tables \dt 8*/

/*
  We should create two connections to the database depend on the user, 
  each connection has associated an user, this user have different
  grants, so we avoid students creates in tables she/he is not allowed.
*/


/**************** USERS AUTHENTICATION ************************/
drop table if exists rol;
drop table if exists usuario;
drop table if exists periodo;
drop table if exists estado_convocatoria;
drop table if exists convocatoria;
drop table if exists historico_convocatoria;
drop table if exists estado_documento;
drop table if exists tipo_documento;
drop table if exists documento;
drop table if exists solicitud_documento;
drop table if exists facultad;
drop table if exists proyecto_curricular;
drop table if exists estudiante;
drop table if exists estado_solicitud;
drop table if exists solicitud;
drop table if exists historico_solicitud;
drop table if exists convocatoria_facultad;
drop table if exists tipo_subsidio;
drop table if exists subsidio_periodo;
drop table if exists beneficiario;
drop table if exists ticket;
drop table if exists estado_actividad;
drop table if exists actividad;
drop table if exists responsable_actividad;
drop table if exists actividad_beneficiario;
drop table if exists parametro;


create table rol(
   id_rol integer primary key,
   nombre varchar (30) unique not null
);
insert into rol(id_rol, nombre) values(1, 'estudiante');
insert into rol(id_rol, nombre) values(2, 'administrador');

create table usuario(
  id_usuario serial primary key,
  password varchar( 256 ) not null,
  fecha_creacion timestamp not null,
  ultimo_accesso timestamp default current_timestamp,
  id_rol integer not null
);
insert into usuario(id_usuario, password, fecha_creacion, id_rol) values (1, 'sha-ouau32u1', current_timestamp, 1);
insert into usuario(id_usuario, password, fecha_creacion, id_rol) values (2, 'sha-ouau32u1', current_timestamp, 2);


/**************** CONVOCATORIA ************************/


create table periodo(
  id_periodo serial primary key, 
  nombre varchar(10) not null, 
  descripcion varchar(200) , 
  fecha_inicio timestamp not null, 
  fecha_fin timestamp not null check(fecha_fin>fecha_inicio), 
  semanas_periodo integer  generated always as (trunc(date_part('day'::text,fecha_fin-fecha_inicio)/7)) stored
);

insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin)
            values (1, '2020-3','2020-10-27 00:00:00', '2020-12-27 23:59:59');

insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin)
            values (2, '2020-1','2020-02-01 00:00:00', '2020-05-29 23:59:59');

create table estado_convocatoria(
    id_estado_convocatoria serial primary key,
    estado varchar(30),
    descripcion varchar(200)
);
insert into estado_convocatoria(id_estado_convocatoria, estado) values(1, 'activa');
insert into estado_convocatoria(id_estado_convocatoria, estado) values(2, 'cerrada');
insert into estado_convocatoria(id_estado_convocatoria, estado) values(3, 'publicada');

create table convocatoria(
  id_convocatoria serial primary key, 
  fecha_inicio timestamp not null,
  fecha_fin timestamp not null check(fecha_fin>fecha_inicio),
  id_periodo integer not null,
  id_estado_convocatoria integer not null,
  foreign key(id_periodo) references periodo(id_periodo),
  foreign key(id_estado_convocatoria) references estado_convocatoria(id_estado_convocatoria)
);
insert into convocatoria(id_convocatoria, fecha_inicio, fecha_fin, id_periodo, id_estado_convocatoria) 
                 values (1, '2020-10-27 00:00:00', '2020-12-27 23:59:59', 1, 1);

create table historico_convocatoria(
  id_historico_convocatoria serial primary key,
  id_convocatoria integer,
  id_estado_convocatoria integer not null,
  fecha timestamp not null,
  foreign key(id_estado_convocatoria) references estado_convocatoria(id_estado_convocatoria),
  foreign key(id_convocatoria) references convocatoria(id_convocatoria)
);

insert into historico_convocatoria(id_convocatoria, id_estado_convocatoria, fecha)
  values (1, 1, current_timestamp);

/**************** ESTUDIANTES ************************/



create table estado_documento(
  id_estado_documento serial primary key,
  nombre varchar(30),
  descripcion varchar(200)
);
insert into estado_documento(id_estado_documento, nombre) values (1, 'Sin Revisar');
insert into estado_documento(id_estado_documento, nombre) values (2, 'Aprovado');
insert into estado_documento(id_estado_documento, nombre) values (3, 'Requiere cambios');
insert into estado_documento(id_estado_documento, nombre) values (4, 'Rechazado');


create table tipo_documento(
  id_tipo_documento serial primary key,
  nombre varchar(200)
);
insert into tipo_documento(id_tipo_documento, nombre) values(1, 'Formulario de solicitud');
insert into tipo_documento(id_tipo_documento, nombre) values(2, 'Carta dirigida a bienestar');
insert into tipo_documento(id_tipo_documento, nombre) values(3, 'Certificado estratificacion');
insert into tipo_documento(id_tipo_documento, nombre) values(4, 'Recibo publico');
insert into tipo_documento(id_tipo_documento, nombre) values(5, 'Recibo universidad');
insert into tipo_documento(id_tipo_documento, nombre) values(6, 'Desplazamiento forzoso');

create table documento(
  id_documento serial primary key,
  nombre varchar(200),
  id_tipo_documento integer not null,
  puntaje smallint check(puntaje>=0 and puntaje <=100),
  foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento)
);
insert into documento(id_documento, id_tipo_documento, nombre, puntaje) values (1, 1, 'Formulario de Solicitud Completo', 100);
insert into documento(id_documento, id_tipo_documento, nombre, puntaje) values (2, 2, 'Carta dirigida a bienestar Completa', 100);
insert into documento(id_documento, id_tipo_documento, nombre, puntaje) values (3, 3, 'Estrato 1', 100);
insert into documento(id_documento, id_tipo_documento, nombre, puntaje) values (4, 3, 'Estrato 2', 90);
insert into documento(id_documento, id_tipo_documento, nombre, puntaje) values (5, 3, 'Estrato 3', 80);
insert into documento(id_documento, id_tipo_documento, nombre, puntaje) values (6, 3, 'Estrato 4', 70);
insert into documento(id_documento, id_tipo_documento, nombre, puntaje) values (7, 3, 'Estrato 5', 60);
insert into documento(id_documento, id_tipo_documento, nombre, puntaje) values (8, 4, 'Recibo publico actual', 100);
insert into documento(id_documento, id_tipo_documento, nombre, puntaje) values (9, 3, 'Recibo universidad completo', 100);
insert into documento(id_documento, id_tipo_documento, nombre, puntaje) values (10, 3, 'Desplazamiento Forzoso', 100);


create table facultad(
  id_facultad serial primary key,
  nombre varchar(50) not null
);
insert into facultad( id_facultad, nombre) values (1,'artes');
insert into facultad( id_facultad, nombre) values (2,'ingenieria');


create table proyecto_curricular(
  id_proyecto_curricular serial primary key,
  id_facultad integer not null,
  nombre varchar(200) not null, 
  foreign key(id_facultad) references facultad(id_facultad)
);
insert into proyecto_curricular(id_proyecto_curricular, id_facultad, nombre) values ( 1, 1, 'electronica');
insert into proyecto_curricular(id_proyecto_curricular, id_facultad, nombre) values ( 2, 2, 'industrial');


create table estudiante(
  id_estudiante serial primary key, 
  identificacion varchar(30) unique,
  nombre varchar(50) not null,
  apellido varchar(50) not null,
  promedio numeric(3,2) check(promedio >=0 and promedio <=5.0),
  matriculas_restantes smallint default 10, 
  email varchar(100),
  id_usuario integer not null,
  id_proyecto_curricular integer not null, 
  foreign key(id_proyecto_curricular) references proyecto_curricular(id_proyecto_curricular),
  foreign key(id_usuario) references usuario(id_usuario)
);

insert into estudiante(id_estudiante, identificacion, nombre, apellido, promedio, matriculas_restantes, email, id_proyecto_curricular, id_usuario)
values (1, '1018345847', 'jhon', 'doe', 4.5, 8, 'jhon@email.com', 2, 1);


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
  puntaje smallint check(puntaje >=0 and puntaje <=100), /* check puntaje [0, 100] */
  ultima_actualizacion timestamp not null default current_timestamp, 
  id_estado_solicitud integer not null, 
  id_convocatoria integer not null, /* if I insert a register should check convocatoria is active */
  foreign key (id_convocatoria) references convocatoria(id_convocatoria),
  foreign key (id_estado_solicitud) references estado_solicitud(id_estado_solicitud),
  foreign key (id_estudiante) references estudiante(id_estudiante)
);


insert into solicitud(id_solicitud, id_estudiante, id_estado_solicitud, id_convocatoria) values (1, 1, 1, 1);

create table historico_solicitud(
  id_historico_solicitud serial primary key,
  id_solicitud integer,
  id_estado_solicitud integer,
  foreign key(id_estado_solicitud) references estado_solicitud(id_estado_solicitud),
  foreign key(id_solicitud) references solicitud(id_solicitud),
  fecha timestamp not null
);


create table solicitud_documento(
    id_solicitud integer not null,
    id_documento integer not null,
    id_estado_documento integer,
    revision varchar(300),
    url varchar(200) not null,
    foreign key(id_estado_documento) references estado_documento(id_estado_documento),
    foreign key(id_solicitud) references solicitud(id_solicitud),
    foreign key(id_documento) references documento(id_documento)
);



/**************** PUNTAJES Y SUBSIDIOS ************************/

create table convocatoria_facultad(
  id_facultad  integer not null,
  id_convocatoria integer not null,
  cantidad_de_almuerzos smallint not null check(cantidad_de_almuerzos>=0),
  primary key(id_facultad, id_convocatoria),
  foreign key( id_convocatoria) references convocatoria(id_convocatoria),
  foreign key( id_facultad) references facultad(id_facultad)
);

insert into convocatoria_facultad (id_facultad, id_convocatoria, cantidad_de_almuerzos) values (1, 1, 40);
insert into convocatoria_facultad (id_facultad, id_convocatoria, cantidad_de_almuerzos) values (2, 1, 120);

create table tipo_subsidio(
  id_tipo_subsidio serial primary key, 
  nombre varchar(30) not null, 
  descripcion varchar(200),
  porcentaje_subsidiado smallint not null check(porcentaje_subsidiado>=0 and porcentaje_subsidiado<=100),
  puntos_requeridos  smallint not null check( puntos_requeridos>=0), 
  horas_semanales_a_cumplir smallint not null
);
insert into tipo_subsidio(id_tipo_subsidio, nombre, porcentaje_subsidiado, puntos_requeridos, horas_semanales_a_cumplir) values(1, 'tipo A',100, 90, 30); 
insert into tipo_subsidio(id_tipo_subsidio, nombre, porcentaje_subsidiado, puntos_requeridos, horas_semanales_a_cumplir) values(2, 'tipo B',70, 80, 40); 


create table subsidio_periodo(
  id_periodo integer,
  id_tipo_subsidio integer,
  cantidad_de_almuerzos_ofertados smallint check(cantidad_de_almuerzos_ofertados>=0),
  foreign key( id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio),
  foreign key (id_periodo) references periodo(id_periodo),
  primary key(id_tipo_subsidio, id_periodo)
);

/**************** TICKET and BENEFICIARIO ************************/
create table beneficiario(
  id_beneficiario serial primary key,
  id_tipo_subsidio integer,
  id_solicitud integer,
  foreign key (id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio),
  foreign key (id_solicitud) references solicitud(id_solicitud)
);

create table ticket(
  id_ticket serial primary key,
  id_beneficiario integer not null,
  fecha_creacion timestamp default current_timestamp,
  fecha_uso timestamp,
  id_tipo_ticket varchar(15) check(id_tipo_ticket in('refrigerio', 'almuerzo')),
  foreign key (id_beneficiario) references beneficiario(id_beneficiario)
);



/**************** ACTIVIDADES ************************/

create table estado_actividad(
  id_estado_actividad serial primary key,
  nombre varchar(200),
  descripcion varchar(2000)
);


create table actividad(
  id_actividad serial primary key,
  nombre varchar(200) not null,
  descripcion varchar(1000),
  horas_equivalentes smallint not null check(horas_equivalentes >=0)
);

create table responsable_actividad(
  id_responsable serial primary key,
  id_usuario integer not null,
  nombre varchar(30) not null,
  email varchar(100),
  foreign key (id_usuario) references usuario(id_usuario)
);

create table actividad_beneficiario(
  id_actividad_beneficiario serial primary key,
  id_beneficiario integer,
  id_actividad integer,
  id_estado_actividad integer,
  id_responsable integer
);

/**************** PARAMETROS ************************/

create table parametro(
  id_parametro serial primary key,
  nombre_tabla varchar(30),
  clave varchar(100),
  valor varchar(100)
);
/* costo almuerzo, costo refrigerio, verificado(SI, NO)*/

