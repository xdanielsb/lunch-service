
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

create table convocatoria(
  id_convocatoria number(2,0) not null,
  fecha_creacion timestamp not null,
  fecha_abierta timestamp not 	null,
  fecha_cerrada timestamp not null,
  fecha_publicacion_resultados timestamp not null,
  id_periodo number(2,0) not null unique,
  constraint id_convocatoria primary key (id_convocatoria) enable,
  constraint convocatoria_periodo_fk foreign key (id_periodo) references periodo (id_periodo) enable,
  constraint chk_conv_fecha_abierta  check(fecha_abierta>=fecha_creacion),
  constraint chk_conv_fecha_cerrada check(fecha_cerrada>fecha_abierta),
  constraint chk_conv_fecha_publicacion  check(fecha_publicacion_resultados>fecha_cerrada)
);

/**************** ESTUDIANTES ************************/

create table estado_documento(
  id_estado_documento number(2,0) not null,
  nombre varchar2(30 BYTE) not null,
  descripcion varchar2(200 BYTE),
  constraint id_estado_documento primary key (id_estado_documento) enable
);

create table tipo_documento(
  id_tipo_documento number(2,0) not null,
  obligatorio number(1,0) not null,
  nombre varchar2(200 BYTE),
  constraint id_tipo_documento primary key (id_tipo_documento) enable,
  constraint chk_obligatorio check(obligatorio in (0,1))
);

create table puntaje_tipo_documento(
  id_puntaje_tipo_documento number(2,0) not null,
  nombre varchar2(200 BYTE) not null,
  id_tipo_documento number(2,0) not null,
  puntaje number not null, 
  constraint id_puntaje_tipo_documento primary key (id_puntaje_tipo_documento) enable,
  constraint id_tipo_documento_fk foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento),
  constraint chk_documento_puntaje check(puntaje>=0 and puntaje <=100)
);

create table facultad(
  id_facultad number(2,0) not null,
  nombre varchar2(50 BYTE) not null,
  constraint id_facultad primary key (id_facultad) enable
);

create table proyecto_curricular(
  id_proyecto_curricular number(2,0) not null,
  id_facultad number(2,0) not null,
  nombre varchar2(200 BYTE) not null,
  constraint id_proyecto_curricular primary key (id_proyecto_curricular) enable,
  constraint id_facultad_fk foreign key(id_facultad) references facultad(id_facultad)
);

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
  id_proyecto_curricular number(2,0) not null,
  constraint estudiante_pk primary key (id_estudiante) enable,
  constraint id_proyecto_curricular_fk foreign key(id_proyecto_curricular) references proyecto_curricular(id_proyecto_curricular),
  constraint chk_estudiante_promedio check(promedio >=0 and promedio <=5.0)
);

/**************** SOLICITUD APOYO ALIMENTARIO ************************/

create table estado_solicitud(
  id_estado_solicitud number(2,0) not null,
  estado varchar2(30 BYTE) not null,
  descripcion varchar(200),
  constraint estado_solicitud_pk primary key (id_estado_solicitud) enable
);

create table solicitud(
  id_solicitud number(2,0) not null,
  id_estudiante number(11,0) not null,
  puntaje number(3,0),
  ultima_actualizacion timestamp not null,
  estrato number(1,0) not null,
  id_estado_solicitud number(2,0) default 1,
  id_convocatoria number(2,0) not null,
  constraint solicitud_pk primary key (id_solicitud) enable,
  constraint chk_estrato check(estrato >=0 and estrato <=6),
  constraint chk_puntaje_in_zero check(puntaje >=0 and puntaje <=100),
  constraint id_convocatoria_fk foreign key (id_convocatoria) references convocatoria(id_convocatoria),
  constraint id_estado_solicitud_fk foreign key (id_estado_solicitud) references estado_solicitud(id_estado_solicitud),
  constraint id_estudiante foreign key (id_estudiante) references estudiante(id_estudiante),
  constraint uq_id_estudiante unique(id_estudiante)
);

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

create table documento_solicitud(
  id_solicitud number(2,0) not null,
  id_puntaje_tipo_documento number(2,0),
  id_estado_documento number(2,0),
  id_tipo_documento number(2,0) not null,
  comentarios varchar2(300 BYTE),
  url varchar2(200 BYTE) not null,
  constraint documento_solicitud_pk primary key (id_solicitud, id_tipo_documento) enable,
  constraint id_estado_documento_fk foreign key(id_estado_documento) references estado_documento(id_estado_documento),
  constraint id_solicitud_documento_fk foreign key(id_solicitud) references solicitud(id_solicitud) on delete cascade,
  constraint id_puntaje_tipo_documento_fk foreign key(id_puntaje_tipo_documento) references puntaje_tipo_documento(id_puntaje_tipo_documento),
  constraint id_tipo_documento_solicitud_fk foreign key(id_tipo_documento) references tipo_documento(id_tipo_documento)
);
  
/**************** PUNTAJES Y SUBSIDIOS ************************/

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

create table convocatoria_facultad(
  id_facultad number(2,0) not null,
  id_convocatoria number(2,0) not null,
  cantidad_de_almuerzos number(4,0) not null,
  constraint convocatoria_facultad_pk primary key(id_facultad, id_convocatoria) enable,
  constraint id_convocatoria_facultad_fk foreign key( id_convocatoria) references convocatoria(id_convocatoria)  on delete cascade,
  constraint id_facultad__fk foreign key( id_facultad) references facultad(id_facultad),
  constraint chk_conv_facultad_cantidad check(cantidad_de_almuerzos>=0)
);

create table tipo_subsidio_convocatoria(
  id_convocatoria number(2,0) not null,
  id_tipo_subsidio number(2,0) not null,
  cant_almuerzos_ofertados  number(4,0), 
  constraint tipo_subsidio_convocatoria_pk primary key(id_tipo_subsidio, id_convocatoria) enable,
  constraint id_tipo_subsidio_fk foreign key( id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio),
  constraint id_convocatoria_tipo_fk foreign key (id_convocatoria) references convocatoria(id_convocatoria) on delete cascade,
  constraint chk_cantidad_almuerzos check(cant_almuerzos_ofertados>=0)
  );


create table beneficiario(
  id_beneficiario number(3,0) not null,
  id_tipo_subsidio number(2,0) not null,
  id_solicitud number(2,0) not null,
  cantidad_tickets_asignados number(4,0) default -1, 
  constraint beneficiario_pk primary key (id_beneficiario) enable,
  constraint id_tipo_subsidio_benef_fk foreign key (id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio),
  constraint id_solicitud_beneficiario_fk foreign key (id_solicitud) references solicitud(id_solicitud)
  );


create table ticket(
  id_ticket number(3,0) not null,
  id_beneficiario number (3,0) not null,
  fecha_creacion timestamp default current_timestamp,
  fecha_uso timestamp,
  id_tipo_ticket varchar2(15 BYTE),
  constraint ticket_pk primary key (id_ticket) enable,
  constraint id_beneficiario_fk foreign key (id_beneficiario) references beneficiario(id_beneficiario),
  constraint chk_ticket_tipo check(id_tipo_ticket in('refrigerio', 'almuerzo'))
  );
  

/**************** ACTIVIDADES ************************/

create table estado_actividad(
  id_estado_actividad number(2,0) not null,
  nombre varchar2(200 BYTE) not null,
  descripcion varchar2(2000 BYTE),
  constraint estado_actividad_pk primary key (id_estado_actividad) enable);

create table actividad(
  id_actividad number(2,0) not null,
  nombre varchar2(200 BYTE) not null,
  descripcion varchar2(1000 BYTE),
  horas_equivalentes number(3,0) not null,
  constraint actividad_pk primary key (id_actividad) enable,
  constraint chk_actividad_horas_positive check(horas_equivalentes >=0)
  );


create table actividad_beneficiario(
  id_actividad_beneficiario number(2,0) not null,
  id_beneficiario number(2,0),
  id_actividad number(2,0),
  id_estado_actividad number(2,0),
  constraint actividad_beneficiario_pk primary key (id_actividad_beneficiario) enable,
  constraint id_beneficiario_ab_fk foreign key (id_beneficiario) references beneficiario(id_beneficiario),
  constraint id_actividad_ab_fk foreign key (id_actividad) references actividad(id_actividad),
  constraint id_estado_actividad_ab_fk foreign key (id_estado_actividad) references estado_actividad(id_estado_actividad)
);

/**************** FUNCIONARIOS ************************/

create table funcionario(
  id_funcionario number(2,0) not null,
  identificacion varchar2(30 BYTE) not null,
  nombre1 varchar2(50 BYTE) not null,
  nombre2 varchar2(50 BYTE),
  apellido1 varchar2(50 BYTE) not null,
  apellido2 varchar2(50 BYTE),
  email varchar2(100 BYTE),
  constraint funcionario_pk primary key (id_funcionario) enable);
