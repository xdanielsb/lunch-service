/* https://www.postgresql.org/docs/13/datatype.html */
/* \i file.sql */
/* \d table_tame */
/* list tables \dt 8*/


/**************** USERS AUTHENTICATION ************************/
-- drop table rol CASCADE CONSTRAINTS ;
-- drop table periodo CASCADE CONSTRAINTS ;
-- drop table convocatoria CASCADE CONSTRAINTS ;
-- drop table estado_documento CASCADE CONSTRAINTS ;
-- drop table tipo_documento CASCADE CONSTRAINTS ;
-- drop table puntaje_tipo_documento CASCADE CONSTRAINTS ;
-- drop table documento_solicitud CASCADE CONSTRAINTS ;
-- drop table facultad CASCADE CONSTRAINTS ;
-- drop table proyecto_curricular CASCADE CONSTRAINTS ;
-- drop table estudiante CASCADE CONSTRAINTS ;
-- drop table estado_solicitud CASCADE CONSTRAINTS ;
-- drop table solicitud CASCADE CONSTRAINTS ;
-- drop table historico_solicitud CASCADE CONSTRAINTS ;
-- drop table convocatoria_facultad CASCADE CONSTRAINTS ;
-- drop table tipo_subsidio CASCADE CONSTRAINTS ;
-- drop table tipo_subsidio_convocatoria CASCADE CONSTRAINTS ;
-- drop table beneficiario CASCADE CONSTRAINTS ;
-- drop table ticket CASCADE CONSTRAINTS ;
-- drop table estado_actividad CASCADE CONSTRAINTS ;
-- drop table actividad CASCADE CONSTRAINTS ;
-- drop table actividad_beneficiario CASCADE CONSTRAINTS ;
-- drop table parametro CASCADE CONSTRAINTS ;
-- drop table funcionario CASCADE CONSTRAINTS ;

/**************** CONVOCATORIA ************************/

-- create table periodo(
  -- id_periodo serial primary key,
  -- nombre varchar(10) not null unique,
  -- descripcion varchar(200) ,
  -- fecha_inicio timestamp not null,
  -- fecha_fin timestamp not null constraint chk_periodo_feacha_fin_greater_fecha_inicio check(fecha_fin>fecha_inicio),
  -- semanas_periodo integer  generated always as (trunc(date_part('day'::text,fecha_fin-fecha_inicio)/7)) stored
-- );
create table periodo(
  id_periodo number(2,0) not null,
  nombre varchar2(10 byte) not null,
  descripcion varchar2(200 byte),
  fecha_inicio timestamp not null,
  fecha_fin timestamp not null,
  semanas_periodo number(2,0) generated always as ((trunc(fecha_fin) - trunc(fecha_inicio))/7) VIRTUAL,
  constraint chk_periodo_fin_inicio check(fecha_fin>fecha_inicio),
  constraint periodo_pk primary key (id_periodo) enable
); 
--SELECT TO_TIMESTAMP('2021-02-28') FROM DUAL;
--select id_periodo, nombre from periodo where to_char(FECHA_CREACION, 'DD/MM/YYYY')= TO_DATE ('2021-02-28', 'yyyy-mm-dd') and fecha_fin>=TO_DATE ('2021-02-28', 'yyyy-mm-dd');

--select id_periodo, to_char(fecha_inicio, 'YYYY-MM-DD') "FECHA_IN", to_char(fecha_fin, 'YYYY-MM-DD') "FECHA_FN" from periodo where 'FECHA_IN' <= '2021-02-28' and 'FECHA_FN' >= '2021-02-28';
--select * from periodo ;
--select id_periodo, nombre from periodo where fecha_inicio<=TO_DATE ('2021-02-28', 'yyyy-mm-dd') and fecha_fin >=TO_DATE ('2021-02-28', 'yyyy-mm-dd');

--alter table periodo add constraint chk_periodo_fin_inicio check(fecha_fin>fecha_inicio);

-- create table convocatoria(
  -- id_convocatoria serial primary key,
  -- fecha_creacion date not null,
  -- fecha_abierta date not null constraint chk_convocatoria_fecha_abierta_greater_fecha_creacion check(fecha_abierta>=fecha_creacion),
  -- fecha_cerrada date not null constraint chk_convocatoria_fecha_cerrada_greater_fecha_abierta check(fecha_cerrada>fecha_abierta),
  -- fecha_publicacion_resultados date not null constraint chk_convocatoria_publicacion_greater_fecha_cerrada check(fecha_publicacion_resultados>fecha_cerrada),
  -- id_periodo integer not null unique,
  -- foreign key(id_periodo) references periodo(id_periodo)
-- );

create table convocatoria(
  id_convocatoria number(2,0) not null,
  fecha_creacion timestamp not null,
  fecha_abierta timestamp not 	null,
  fecha_cerrada timestamp not null,
  fecha_publicacion_resultados timestamp not null,
  id_periodo number(2,0) not null unique,
  --id_estado_convocatoria number(2,0) not null,
  constraint id_convocatoria primary key (id_convocatoria) enable,
  constraint convocatoria_periodo_fk foreign key (id_periodo) references periodo (id_periodo) enable,
  constraint chk_conv_fecha_abierta  check(fecha_abierta>=fecha_creacion),
  constraint chk_conv_fecha_cerrada check(fecha_cerrada>fecha_abierta),
  constraint chk_conv_fecha_publicacion  check(fecha_publicacion_resultados>fecha_cerrada)
);

CREATE SEQUENCE seq_id_convocatoria INCREMENT BY 1 START WITH 1;
--select seq_id_convocatoria.nextval from dual;
--select seq_id_convocatoria.currval from dual;

--alter table convocatoria add constraint convocatoria_periodo_fk foreign key (id_periodo) references periodo (id_periodo) enable;
--alter table convocatoria add constraint chk_conv_fecha_abierta check(fecha_cerrada>=fecha_creacion);
--alter table convocatoria add constraint chk_conv_fecha_cerrada check(fecha_cerrada>fecha_abierta);
--alter table convocatoria add constraint chk_conv_fecha_resultados check(fecha_resultados>fecha_cerrada);

-- --alter table convocatoria add constraint estado_convocatoria_fk foreign key (id_estado_convocatoria) references estado_convocatoria (id_estado_convocatoria) enable;


/**************** ESTUDIANTES ************************/

-- create table estado_documento(
  -- id_estado_documento serial primary key,
  -- nombre varchar(30) not null,
  -- descripcion varchar(200)
-- );

create table estado_documento(
  id_estado_documento number(2,0) not null,
  nombre varchar2(30 BYTE) not null,
  descripcion varchar2(200 BYTE),
  constraint id_estado_documento primary key (id_estado_documento) enable
);

-- create table tipo_documento(
  -- id_tipo_documento serial primary key,
  -- obligatorio numeric(1,0) check(obligatorio in(0, 1)) not null,
  -- nombre varchar(200)
-- );

create table tipo_documento(
  id_tipo_documento number(2,0) not null,
  obligatorio number(1,0) not null,
  nombre varchar2(200 BYTE),
  constraint id_tipo_documento primary key (id_tipo_documento) enable,
  constraint chk_obligatorio check(obligatorio in (0,1))
);

-- alter table tipo_documento add constraint chk_obligatorio check(obligatorio in (0,1));

-- create table puntaje_tipo_documento(
  -- id_puntaje_tipo_documento serial primary key,
  -- nombre varchar(200) not null,
  -- id_tipo_documento integer not null,
  -- puntaje smallint not null constraint chk_documento_puntaje_greater_than_zero check(puntaje>=0 and puntaje <=100),
  -- foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento)
-- );

create table puntaje_tipo_documento(
  id_puntaje_tipo_documento number(2,0) not null,
  nombre varchar2(200 BYTE) not null,
  id_tipo_documento number(2,0) not null,
  puntaje number not null, 
  constraint id_puntaje_tipo_documento primary key (id_puntaje_tipo_documento) enable,
  constraint id_tipo_documento_fk foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento),
  constraint chk_documento_puntaje check(puntaje>=0 and puntaje <=100)
);

--alter table puntaje_tipo_documento add constraint id_tipo_documento_fk foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento);
--alter table puntaje_tipo_documento add constraint chk_documento_puntaje check(puntaje>=0 and puntaje <=100);


-- create table facultad(
  -- id_facultad serial primary key,
  -- nombre varchar(50) not null
-- );

create table facultad(
  id_facultad number(2,0) not null,
  nombre varchar2(50 BYTE) not null,
  constraint id_facultad primary key (id_facultad) enable
);

-- create table proyecto_curricular(
  -- id_proyecto_curricular serial primary key,
  -- id_facultad integer not null,
  -- nombre varchar(200) not null,
  -- foreign key(id_facultad) references facultad(id_facultad)
-- );

create table proyecto_curricular(
  id_proyecto_curricular number(2,0) not null,
  id_facultad number(2,0) not null,
  nombre varchar2(200 BYTE) not null,
  constraint id_proyecto_curricular primary key (id_proyecto_curricular) enable,
  constraint id_facultad_fk foreign key(id_facultad) references facultad(id_facultad)
);

--alter table proyecto_curricular add constraint id_facultad_fk foreign key(id_facultad) references facultad(id_facultad);

/* TODO: implements inheritance with table 'funcionario' */
-- create table estudiante(
  -- id_estudiante serial primary key,
  -- identificacion varchar(30) unique not null,
  -- nombre1 varchar(50) not null,
  -- nombre2 varchar(50),
  -- apellido1 varchar(50) not null,
  -- apellido2 varchar(50),
  -- promedio numeric(3,2) constraint chk_estudiante_promedio_greater_in_zero_five_range check(promedio >=0 and promedio <=5.0),
  -- matriculas_restantes smallint default 10,
  -- email varchar(100),
  -- id_proyecto_curricular integer not null,
  -- foreign key(id_proyecto_curricular) references proyecto_curricular(id_proyecto_curricular)
-- );

create table estudiante(
  id_estudiante number(11,0) not null,
  identificacion varchar2(30 BYTE) unique not null,
  nombre1 varchar2(50 BYTE) not null,
  nombre2 varchar2(50 BYTE),
  apellido1 varchar2(50 BYTE) not null,
  apellido2 varchar2(50 BYTE),
  promedio number(3,2) not null, 
  matriculas_restantes number(2,0) not null,
  email varchar2(100 BYTE),
  --id_usuario number(11,0) not null,
  id_proyecto_curricular number(2,0) not null,
  constraint estudiante_pk primary key (id_estudiante) enable,
  constraint id_proyecto_curricular_fk foreign key(id_proyecto_curricular) references proyecto_curricular(id_proyecto_curricular),
  constraint chk_estudiante_promedio check(promedio >=0 and promedio <=5.0)
);

--alter table estudiante add constraint id_proyecto_curricular_fk foreign key(id_proyecto_curricular) references proyecto_curricular(id_proyecto_curricular);
--alter table estudiante add constraint chk_estudiante_promedio check(promedio >=0 and promedio <=5.0);

-- --alter table estudiante add constraint id_usuario_fk foreign key(id_usuario) references usuario(id_usuario);


/**************** SOLICITUD APOYO ALIMENTARIO ************************/

-- create table estado_solicitud(
  -- id_estado_solicitud serial primary key,
  -- estado varchar(30) not null,
  -- descripcion varchar(200)
-- );

create table estado_solicitud(
  id_estado_solicitud number(2,0) not null,
  estado varchar2(30 BYTE) not null,
  descripcion varchar(200),
  constraint estado_solicitud_pk primary key (id_estado_solicitud) enable
);


-- insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 1, 'en progreso', '');
-- insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 2, 'completada', '');
-- insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 3, 'rechazada', '');
-- insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 4, 'cancelada', '');
-- insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 5, 'aprobada', '');
-- insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values( 6, 'requiere cambios', '');

-- create table solicitud(
  -- id_solicitud serial primary key,
  -- id_estudiante integer not null,
  -- puntaje smallint default 0,
  -- ultima_actualizacion timestamp not null default current_timestamp,
  -- estrato integer constraint chk_estrato_grt_zero_leq_six check(estrato>=0 and estrato<=6),
  -- id_estado_solicitud integer default 1,
  -- id_convocatoria integer not null,
  -- foreign key (id_convocatoria) references convocatoria(id_convocatoria),
  -- foreign key (id_estado_solicitud) references estado_solicitud(id_estado_solicitud),
  -- foreign key (id_estudiante) references estudiante(id_estudiante),
  -- unique(id_convocatoria, id_estudiante)
-- );

create table solicitud(
  id_solicitud number(2,0) not null,
  id_estudiante number(11,0) not null,
  puntaje number(3,0),
  ultima_actualizacion timestamp not null,
  estrato number(1,0) not null,
  id_estado_solicitud number(1,0) default 1,
  id_convocatoria number(2,0) not null,
  constraint solicitud_pk primary key (id_solicitud) enable,
  constraint chk_estrato check(estrato >=0 and puntaje <=6),
  constraint chk_puntaje_in_zero check(puntaje >=0 and puntaje <=100),
  constraint id_convocatoria_fk foreign key (id_convocatoria) references convocatoria(id_convocatoria),
  constraint id_estado_solicitud_fk foreign key (id_estado_solicitud) references estado_solicitud(id_estado_solicitud),
  constraint id_estudiante foreign key (id_estudiante) references estudiante(id_estudiante),
  constraint uq_id_convocatoria unique(id_convocatoria),
  constraint uq_id_estudiante unique(id_estudiante)
);

CREATE SEQUENCE seq_id_solicitud INCREMENT BY 1 START WITH 1; 
  
--alter table solicitud add constraint chk_estrato check(estrato >=0 and puntaje <=6);
--alter table solicitud add constraint chk_puntaje_in_zero check(puntaje >=0 and puntaje <=100);
--alter table solicitud add constraint id_convocatoria_fk foreign key (id_convocatoria) references convocatoria(id_convocatoria);
--alter table solicitud add constraint id_estado_solicitud_fk foreign key (id_estado_solicitud) references estado_solicitud(id_estado_solicitud);
--alter table solicitud add constraint id_estudiante foreign key (id_estudiante) references estudiante(id_estudiante);
--alter table solicitud add constraint uq_id_convocatoria unique(id_convocatoria);
--alter table solicitud add constraint uq_id_estudiante unique(id_estudiante);


-- create table historico_solicitud(
  -- id_historico_solicitud serial primary key,
  -- id_solicitud integer not null,
  -- id_estado_solicitud integer not null,
  -- modificado_por VARCHAR(32),
  -- foreign key(id_estado_solicitud) references estado_solicitud(id_estado_solicitud),
  -- foreign key(id_solicitud) references solicitud(id_solicitud),
  -- fecha timestamp not null
-- );

create table historico_solicitud(
  id_historico_solicitud number(2,0) not null,
  id_solicitud number(2,0) not null,
  id_estado_solicitud number(2,0) not null,
  modificado_por varchar2(32 byte),
  fecha timestamp not null,
  constraint historico_solicitud_pk primary key (id_historico_solicitud) enable,
  constraint id_estado_his_solicitud_fk foreign key(id_estado_solicitud) references estado_solicitud(id_estado_solicitud),
  constraint id_solicitud_fk foreign key(id_solicitud) references solicitud(id_solicitud)
);

--alter table historico_solicitud add constraint id_estado_his_solicitud_fk foreign key(id_estado_solicitud) references estado_solicitud(id_estado_solicitud);
--alter table historico_solicitud add constraint id_solicitud_fk foreign key(id_solicitud) references solicitud(id_solicitud);


-- create table documento_solicitud(
  -- id_solicitud integer not null,
  -- id_puntaje_tipo_documento integer,
  -- id_estado_documento integer default 1,
  -- id_tipo_documento integer not null,
  -- comentarios varchar(300),
  -- url varchar(200) not null,
  -- foreign key(id_estado_documento) references estado_documento(id_estado_documento),
  -- foreign key(id_solicitud) references solicitud(id_solicitud) on delete cascade,
  -- foreign key(id_puntaje_tipo_documento) references puntaje_tipo_documento(id_puntaje_tipo_documento),
  -- foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento),
  -- primary key(id_solicitud, id_tipo_documento)
-- );

create table documento_solicitud(
  id_solicitud number(2,0) not null,
  id_puntaje_tipo_documento number(2,0),
  id_estado_documento number(2,0),
  id_tipo_documento number(2,0) not null,
  comentarios varchar2(300 BYTE),
  url varchar2(200 BYTE) not null,
  --necesita_cambios number(1,0) default 0,
  --revisado number(1,0) default 0,
  constraint documento_solicitud_pk primary key (id_solicitud, id_tipo_documento) enable,
  constraint id_estado_documento_fk foreign key(id_estado_documento) references estado_documento(id_estado_documento),
  constraint id_solicitud_documento_fk foreign key(id_solicitud) references solicitud(id_solicitud) on delete cascade,
  constraint id_puntaje_tipo_documento_fk foreign key(id_puntaje_tipo_documento) references puntaje_tipo_documento(id_puntaje_tipo_documento),
  constraint id_tipo_documento_solicitud_fk foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento)
);
  
--alter table documento_solicitud add constraint id_estado_documento_fk foreign key(id_estado_documento) references estado_documento(id_estado_documento);
--alter table documento_solicitud add constraint id_solicitud_documento_fk foreign key(id_solicitud) references solicitud(id_solicitud) on delete cascade;
--alter table documento_solicitud add constraint id_puntaje_tipo_documento_fk foreign key(id_puntaje_tipo_documento) references puntaje_tipo_documento(id_puntaje_tipo_documento);
--alter table documento_solicitud add constraint id_tipo_documento_solicitud_fk foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento);


/**************** PUNTAJES Y SUBSIDIOS ************************/

-- create table tipo_subsidio(
  -- id_tipo_subsidio serial primary key,
  -- nombre varchar(30) not null,
  -- descripcion varchar(200),
  -- porcentaje_subsidiado smallint not null constraint chk_tipo_subsidiado_porcentaje_in_zero_hundred_range check(porcentaje_subsidiado>=0 and porcentaje_subsidiado<=100),
  -- puntos_requeridos  smallint not null constraint chk_tipo_subsidiado_puntos_requeridos_greater_than_zero check( puntos_requeridos>=0),
  -- horas_semanales_a_cumplir smallint not null
-- );

create table tipo_subsidio(
  id_tipo_subsidio number(2,0) not null,
  nombre varchar2(30 BYTE) not null,
  descripcion varchar2(200 BYTE),
  porcentaje_subsidiado number(3,0) not null,
  puntos_requeridos  number(3,0) not null,
  horas_semanales_a_cumplir number(3,0) not null,
  constraint tipo_subsidio_pk primary key (id_tipo_subsidio) enable,
  constraint chk_tipo_subsidiado_porcentaje check(porcentaje_subsidiado>=0 and porcentaje_subsidiado<=100),
  constraint chk_tipo_subsidiado_puntos check( puntos_requeridos>=0)
);

--alter table tipo_subsidio add constraint chk_tipo_subsidiado_porcentaje check(porcentaje_subsidiado>=0 and porcentaje_subsidiado<=100);
--alter table tipo_subsidio add constraint chk_tipo_subsidiado_puntos check( puntos_requeridos>=0);


-- create table convocatoria_facultad(
  -- id_facultad  integer not null,
  -- id_convocatoria integer not null,
  -- cantidad_de_almuerzos smallint not null constraint chk_convocatoria_facultad_cantidad_almuerzos_greater_than_zero check(cantidad_de_almuerzos>=0),
  -- primary key(id_facultad, id_convocatoria),
  -- foreign key( id_convocatoria) references convocatoria(id_convocatoria)  on delete cascade,
  -- foreign key( id_facultad) references facultad(id_facultad)
-- );

create table convocatoria_facultad(
  id_facultad number(2,0) not null,
  id_convocatoria number(2,0) not null,
  cantidad_de_almuerzos number(4,0) not null,
  constraint convocatoria_facultad_pk primary key(id_facultad, id_convocatoria) enable,
  constraint id_convocatoria_facultad_fk foreign key( id_convocatoria) references convocatoria(id_convocatoria)  on delete cascade,
  constraint id_facultad__fk foreign key( id_facultad) references facultad(id_facultad),
  constraint chk_conv_facultad_cantidad check(cantidad_de_almuerzos>=0)
);

--alter table convocatoria_facultad add constraint id_convocatoria_facultad_fk foreign key( id_convocatoria) references convocatoria(id_convocatoria)  on delete cascade;
--alter table convocatoria_facultad add constraint id_facultad__fk foreign key( id_facultad) references facultad(id_facultad);
--alter table convocatoria_facultad add constraint chk_conv_facultad_cantidad check(cantidad_de_almuerzos>=0);


-- create table tipo_subsidio_convocatoria(
  -- id_convocatoria integer not null,
  -- id_tipo_subsidio integer not null,
  -- cant_almuerzos_ofertados  smallint constraint chk_subsidio_periodo_cantidad_almuerzos_positive check(cant_almuerzos_ofertados>=0),
  -- foreign key( id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio),
  -- foreign key (id_convocatoria) references convocatoria(id_convocatoria) on delete cascade,
  -- primary key(id_tipo_subsidio, id_convocatoria)
-- );

create table tipo_subsidio_convocatoria(
  id_convocatoria number(2,0) not null,
  id_tipo_subsidio number(2,0) not null,
  cant_almuerzos_ofertados  number(4,0), 
  constraint tipo_subsidio_convocatoria_pk primary key(id_tipo_subsidio, id_convocatoria) enable,
  constraint id_tipo_subsidio_fk foreign key( id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio),
  constraint id_convocatoria_tipo_fk foreign key (id_convocatoria) references convocatoria(id_convocatoria) on delete cascade,
  constraint chk_cantidad_almuerzos check(cant_almuerzos_ofertados>=0)
  );

--alter table tipo_subsidio_convocatoria add constraint id_tipo_subsidio_fk foreign key( id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio);
--alter table tipo_subsidio_convocatoria add constraint id_convocatoria_tipo_fk foreign key (id_convocatoria) references convocatoria(id_convocatoria) on delete cascade;
--alter table tipo_subsidio_convocatoria add constraint chk_antidad_almuerzos check(cant_almuerzos_ofertados>=0);

/**************** TICKET and BENEFICIARIO ************************/
-- create table beneficiario(
  -- id_beneficiario serial primary key,
  -- id_tipo_subsidio integer not null,
  -- id_solicitud integer unique not null,
  -- foreign key (id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio),
  -- foreign key (id_solicitud) references solicitud(id_solicitud)
-- );

create table beneficiario(
  id_beneficiario number(3,0) not null,
  id_tipo_subsidio number(2,0) not null,
  id_solicitud number(2,0) not null,
  constraint beneficiario_pk primary key (id_beneficiario) enable,
  constraint id_tipo_subsidio_benef_fk foreign key (id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio),
  constraint id_solicitud_beneficiario_fk foreign key (id_solicitud) references solicitud(id_solicitud)
  );

--alter table beneficiario add constraint id_tipo_subsidio_benef_fk foreign key (id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio);
--alter table beneficiario add constraint id_solicitud_beneficiario_fk foreign key (id_solicitud) references solicitud(id_solicitud);


-- create table ticket(
  -- id_ticket serial primary key,
  -- id_beneficiario integer not null,
  -- fecha_creacion timestamp default current_timestamp,
  -- fecha_uso date,
  -- tipo_ticket varchar(15) constraint chk_ticket_tipo_in_defined_types check(tipo_ticket in('refrigerio', 'almuerzo')),
  -- foreign key (id_beneficiario) references beneficiario(id_beneficiario),
  -- unique(fecha_uso, tipo_ticket) /* prevent to have lunch two times in one day */
-- );

create table ticket(
  id_ticket number(2,0) not null,
  id_beneficiario number (3,0) not null,
  fecha_creacion timestamp default current_timestamp,
  fecha_uso timestamp,
  id_tipo_ticket varchar2(15 BYTE),
  constraint ticket_pk primary key (id_ticket) enable,
  constraint id_beneficiario_fk foreign key (id_beneficiario) references beneficiario(id_beneficiario),
  constraint chk_ticket_tipo check(id_tipo_ticket in('refrigerio', 'almuerzo'))
  );
  
--alter table ticket add constraint id_beneficiario_fk foreign key (id_beneficiario) references beneficiario(id_beneficiario);
--alter table ticket add constraint chk_ticket_tipo check(id_tipo_ticket in('refrigerio', 'almuerzo'));


/**************** ACTIVIDADES ************************/

-- create table estado_actividad(
  -- id_estado_actividad serial primary key,
  -- nombre varchar(200) not null,
  -- descripcion varchar(2000)
-- );

create table estado_actividad(
  id_estado_actividad number(2,0) not null,
  nombre varchar2(200 BYTE) not null,
  descripcion varchar2(2000 BYTE),
  constraint estado_actividad_pk primary key (id_estado_actividad) enable);

-- create table actividad(
  -- id_actividad serial primary key,
  -- nombre varchar(200) not null,
  -- descripcion varchar(1000),
  -- horas_equivalentes smallint not null constraint chk_actividad_horas_positive check(horas_equivalentes >=0)
-- );

create table actividad(
  id_actividad number(2,0) not null,
  nombre varchar2(200 BYTE) not null,
  descripcion varchar2(1000 BYTE),
  horas_equivalentes number(3,0) not null,
  constraint actividad_pk primary key (id_actividad) enable,
  constraint chk_actividad_horas_positive check(horas_equivalentes >=0)
  );

--alter table actividad add constraint chk_actividad_horas_positive check(horas_equivalentes >=0);


-- create table actividad_beneficiario(
  -- id_actividad_beneficiario serial primary key,
  -- id_beneficiario integer,
  -- id_actividad integer,
  -- id_estado_actividad integer,
  -- foreign key (id_estado_actividad) references estado_actividad(id_estado_actividad),
  -- foreign key (id_actividad) references actividad(id_actividad),
  -- foreign key (id_beneficiario) references beneficiario(id_beneficiario)
-- );

create table actividad_beneficiario(
  id_actividad_beneficiario number(2,0) not null,
  id_beneficiario number(2,0),
  id_actividad number(2,0),
  id_estado_actividad number(2,0),
  --id_responsable number(2,0),
  constraint actividad_beneficiario_pk primary key (id_actividad_beneficiario) enable);


/**************** PARAMETROS ************************/

-- create table parametro(
  -- id_parametro serial primary key,
  -- nombre_tabla varchar(30),
  -- clave varchar(100),
  -- valor varchar(100)
-- );

create table parametro(
  id_parametro number(2,0) not null,
  nombre_tabla varchar2(30 BYTE),
  clave varchar2(100 BYTE),
  valor varchar2(100 BYTE),
  constraint parametro_pk primary key (id_parametro) enable);

/**************** FUNCIONARIOS ************************/

-- create table funcionario(
  -- id_funcionario serial primary key,
  -- identificacion varchar(30) unique not null,
  -- nombre1 varchar(50) not null,
  -- nombre2 varchar(50),
  -- apellido1 varchar(50) not null,
  -- apellido2 varchar(50),
  -- email varchar(100)
-- );

create table funcionario(
  id_funcionario number(2,0) not null,
  identificacion varchar2(30 BYTE) not null,
  nombre1 varchar2(50 BYTE) not null,
  nombre2 varchar2(50 BYTE),
  apellido1 varchar2(50 BYTE) not null,
  apellido2 varchar2(50 BYTE),
  email varchar2(100 BYTE),
  constraint funcionario_pk primary key (id_funcionario) enable);
