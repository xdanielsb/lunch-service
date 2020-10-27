use apoyo_alimentario;
/* https://www.postgresql.org/docs/13/datatype.html */
/* \i file.sql */
/* \d table_tame */

/*
  We should create two connections to the database depend on the user, 
  each connection has associated an user, this user have different
  grants, so we avoid students creates in tables she/he is not allowed.
*/


/**************** USERS AUTHENTICATION ************************/
drop table if exists rol;
create table rol(
   role_id integer primary key,
   role_name varchar (30) unique not null
);
insert into rol(role_id, role_name) values(1, 'estudiante');
insert into rol(role_id, role_name) values(2, 'administrador');

drop table if exists usuario;
create table usuario(
  id_user serial not null,
  username varchar(11) unique not null,
  password varchar( 50 ) not null,
  created_on timestamp not null,
  last_login timestamp,
  role_id integer not null, 
  PRIMARY KEY (id_user)
);
insert into usuario(username, password, created_on, role_id) values ('student1', 'ouau32u1', current_timestamp, 1);
insert into usuario(username, password, created_on, role_id) values ('admin1', 'ouau32u1', current_timestamp, 2);


/**************** CONVOCATORIA ************************/


drop table if exists periodo;
create table periodo(
  id_periodo serial primary key, 
  nombre varchar(10) not null, 
  descripcion varchar(200) , 
  fecha_inicio timestamp not null, 
  fecha_fin timestamp not null, 
  semanas_periodo smallint   /* can be a computed attribute*/ 
);

insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin)
            values (1, '2020-3','2020-10-27 00:00:00', '2020-12-27 23:59:59');

drop table if exists convocatoria;
create table convocatoria(
  id_convocatoria serial primary key, 
  fecha_inicio timestamp not null,
  fecha_fin timestamp not null,
  id_periodo integer not null,
  foreign key(id_periodo) references periodo(id_periodo)
);

/* fecha inicio < fecha fin */
insert into convocatoria(fecha_inicio, fecha_fin, id_periodo) 
                 values ('2020-10-27 00:00:00', '2020-12-27 23:59:59', 1);


/**************** ESTUDIANTES ************************/

drop table if exists condicion_socioeconomica;
create table condicion_socioeconomica(
  id_condicion_socieconomica serial primary key, 
  condiciones_familiares smallint , /* estrato */ /* check estrato is valid? */
  procedencia varchar(200), /**/ 
  condiciones_de_salud varchar(10) /* una tabla catalogo, (bien, regular ...)? */
);
insert into condicion_socioeconomica(id_condicion_socieconomica, condiciones_familiares, procedencia, condiciones_de_salud)
      values (1, 2, 'indigena', 'excelente');


drop table if exists facultad;
create table facultad(
  id_facultad serial primary key,
  nombre varchar(200) not null
);
insert into facultad( id_facultad, nombre) values (1,'artes');
insert into facultad( id_facultad, nombre) values (2,'ingenieria');

drop table if exists proyecto_curricular;
create table proyecto_curricular(
  id_proyecto_curricular serial primary key,
  id_facultad integer not null,
  nombre varchar(200) not null, 
  foreign key(id_facultad) references facultad(id_facultad)
);
insert into proyecto_curricular(id_proyecto_curricular, id_facultad, nombre) values ( 1, 1, 'electronica');
insert into proyecto_curricular(id_proyecto_curricular, id_facultad, nombre) values ( 2, 2, 'industrial');


drop table if exists estudiante;
create table estudiante(
  codigo serial primary key, 
  identificacion varchar(30), /* take into account international students*/
  nombre varchar(50) not null,
  apellido varchar(50) not null,
  promedio numeric(3,2),  /* check 0  <= promedio <= 5.0 */
  matriculas_restantes smallint, 
  email varchar(100), 
  password varchar(256), 
  id_condicion_socieconomica integer not null,
  id_proyecto_curricular integer not null, 
  foreign key(id_condicion_socieconomica) references condicion_socioeconomica(id_condicion_socieconomica),
  foreign key(id_proyecto_curricular) references proyecto_curricular(id_proyecto_curricular)
);

insert into estudiante(codigo, identificacion, nombre, apellido, promedio, matriculas_restantes, email, password, id_condicion_socieconomica, id_proyecto_curricular)
values (1, '1018345847', 'jhon', 'doe', 4.5, 8, 'jhon@email.com', '0x23heoe7ik', 1 , 2);


/**************** SOLICITUD APOYO ALIMENTARIO ************************/

drop table if  exists estado_solicitud;
create table estado_solicitud(
  id_estado_solicitud serial primary key,
  estado varchar(30) not null, 
  descripcion varchar(200)
);
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 1, 'recibida', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 2, 'evaluada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 3, 'rechazada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 4, 'cancelada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 5, 'aprobada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 6, 'requiere cambios', '');


drop table if  exists solicitud;
create table solicitud(
  id_solicitud serial primary key, 
  codigo_estudiante integer not null, 
  puntaje smallint, /* check puntaje [0, 100] */
  fecha_de_creacion timestamp not null, 
  /* datos de la solicitud */

  /* */
  id_estado_solicitud integer not null, 
  id_convocatoria integer not null, /* if I insert a register should check convocatoria is active */
  foreign key (id_convocatoria) references convocatoria(id_convocatoria),
  foreign key (id_estado_solicitud) references estado_solicitud(id_estado_solicitud),
  foreign key (codigo_estudiante) references estudiante(codigo)
);


insert into solicitud(id_solicitud, codigo_estudiante, fecha_de_creacion, id_estado_solicitud, id_convocatoria) values (1, 1, current_timestamp, 1, 1);


/**************** PUNTAJES Y SUBSIDIOS ************************/

drop table if  exists convocatoria_facultad;
create table convocatoria_facultad(
  id_facultad  integer not null,
  id_convocatoria integer not null,
  cantidad_de_almuerzos smallint not null,
  primary key(id_facultad, id_convocatoria),
  foreign key( id_convocatoria) references convocatoria(id_convocatoria),
  foreign key( id_facultad) references facultad(id_facultad)
);

insert into convocatoria_facultad (id_facultad, id_convocatoria, cantidad_de_almuerzos) values (1, 1, 40);
insert into convocatoria_facultad (id_facultad, id_convocatoria, cantidad_de_almuerzos) values (2, 1, 120);

drop table if  exists tipo_subsidio;
create table tipo_subsidio(
  id_tipo_subsidio serial primary key, 
  nombre varchar(30) not null, 
  descripcion varchar(200),
  porcentaje_subsidiado smallint not null, 
  puntos_requeridos  smallint not null, 
  horas_semanales_a_cumplir smallint not null
);
insert into tipo_subsidio(id_tipo_subsidio, nombre, porcentaje_subsidiado, puntos_requeridos, horas_semanales_a_cumplir) values(1, 'tipo A',100, 90, 30); 

drop table if  exists beneficiario;
create table beneficiario(
  id_beneficiario serial primary key, 
  id_tipo_subsidio integer not null, 
  id_solicitud integer not null,
  foreign key(id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio),
  foreign key(id_solicitud) references solicitud(id_solicitud)
);
/* a beneficiario is created if the solicitud was accepted */
insert into beneficiario(id_beneficiario, id_tipo_subsidio, id_solicitud) values(1, 1, 1);


/****************  RETIRO DE ESTUDIANTE  ************************/
/****************  MANEJO DE TICKETS  ************************/
/****************  ACTIVIDADES DE SERVICIO  ************************/

