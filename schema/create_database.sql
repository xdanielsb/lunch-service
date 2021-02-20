/*
    Copyright (C) 2021  Daniel Santos, Samuel Holguin, Sergio Gomez, 
                         Luisa Cajamarca, Andres Pachon
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>
*/
create table periodo(
  id_periodo serial primary key, 
  nombre varchar(10) not null unique, 
  descripcion varchar(200), 
  fecha_inicio timestamp not null, 
  fecha_fin timestamp not null constraint chk_periodo_feacha_fin_greater_fecha_inicio check(fecha_fin > fecha_inicio), 
  semanas_periodo integer generated always as (
    trunc(
      date_part(
        'day' :: text, fecha_fin - fecha_inicio
      )/ 7
    )
  ) stored
);
create table convocatoria(
  id_convocatoria serial primary key, 
  fecha_creacion date not null, 
  fecha_abierta date not null constraint chk_convocatoria_fecha_abierta_greater_fecha_creacion check(fecha_abierta >= fecha_creacion), 
  fecha_cerrada date not null constraint chk_convocatoria_fecha_cerrada_greater_fecha_abierta check(fecha_cerrada > fecha_abierta), 
  fecha_publicacion_resultados date not null constraint chk_convocatoria_publicacion_greater_fecha_cerrada check(
    fecha_publicacion_resultados > fecha_cerrada
  ), 
  id_periodo integer not null unique, 
  foreign key(id_periodo) references periodo(id_periodo)
);
create table estado_documento(
  id_estado_documento serial primary key, 
  nombre varchar(30) not null, 
  descripcion varchar(200)
);
create table tipo_documento(
  id_tipo_documento serial primary key, 
  obligatorio numeric(1, 0) check(
    obligatorio in(0, 1)
  ) not null, 
  nombre varchar(200)
);
create table puntaje_tipo_documento(
  id_puntaje_tipo_documento serial primary key, 
  nombre varchar(200) not null, 
  id_tipo_documento integer not null, 
  puntaje smallint not null constraint chk_documento_puntaje_greater_than_zero check(
    puntaje >= 0 
    and puntaje <= 100
  ), 
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
  promedio numeric(3, 2) constraint chk_estudiante_promedio_greater_in_zero_five_range check(
    promedio >= 0 
    and promedio <= 5.0
  ), 
  matriculas_restantes smallint default 10, 
  email varchar(100), 
  id_proyecto_curricular integer not null, 
  foreign key(id_proyecto_curricular) references proyecto_curricular(id_proyecto_curricular)
);
create table estado_solicitud(
  id_estado_solicitud serial primary key, 
  estado varchar(30) not null, 
  descripcion varchar(200)
);
create table solicitud(
  id_solicitud serial primary key, 
  id_estudiante integer not null, 
  puntaje smallint default 0, 
  ultima_actualizacion timestamp not null default current_timestamp, 
  estrato integer constraint chk_estrato_grt_zero_leq_six check(
    estrato >= 0 
    and estrato <= 6
  ), 
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
  modificado_por VARCHAR(32), 
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
create table tipo_subsidio(
  id_tipo_subsidio serial primary key, 
  nombre varchar(30) not null, 
  descripcion varchar(200), 
  porcentaje_subsidiado smallint not null constraint chk_tipo_subsidiado_porcentaje_in_zero_hundred_range check(
    porcentaje_subsidiado >= 0 
    and porcentaje_subsidiado <= 100
  ), 
  puntos_requeridos smallint not null constraint chk_tipo_subsidiado_puntos_requeridos_greater_than_zero check(puntos_requeridos >= 0), 
  horas_semanales_a_cumplir smallint not null
);
create table convocatoria_facultad(
  id_facultad integer not null, 
  id_convocatoria integer not null, 
  cantidad_de_almuerzos smallint not null constraint chk_convocatoria_facultad_cantidad_almuerzos_greater_than_zero check(cantidad_de_almuerzos >= 0), 
  primary key(id_facultad, id_convocatoria), 
  foreign key(id_convocatoria) references convocatoria(id_convocatoria) on delete cascade, 
  foreign key(id_facultad) references facultad(id_facultad)
);
create table tipo_subsidio_convocatoria(
  id_convocatoria integer not null, 
  id_tipo_subsidio integer not null, 
  cantidad_de_almuerzos_ofertados smallint constraint chk_subsidio_periodo_cantidad_almuerzos_positive check(
    cantidad_de_almuerzos_ofertados >= 0
  ), 
  foreign key(id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio), 
  foreign key (id_convocatoria) references convocatoria(id_convocatoria) on delete cascade, 
  primary key(
    id_tipo_subsidio, id_convocatoria
  )
);
create table beneficiario(
  id_beneficiario serial primary key, 
  id_tipo_subsidio integer not null, 
  cantidad_tickets_asignados integer default 0, 
  id_solicitud integer unique not null, 
  foreign key (id_tipo_subsidio) references tipo_subsidio(id_tipo_subsidio), 
  foreign key (id_solicitud) references solicitud(id_solicitud)
);
create table ticket(
  id_ticket serial primary key, 
  id_beneficiario integer not null, 
  fecha_creacion timestamp default current_timestamp, 
  fecha_uso date, 
  tipo_ticket varchar(15) constraint chk_ticket_tipo_in_defined_types check(
    tipo_ticket in('refrigerio', 'almuerzo')
  ), 
  foreign key (id_beneficiario) references beneficiario(id_beneficiario), 
  unique(fecha_uso, tipo_ticket) -- prevent to have lunch two times in one day 
  );
create table estado_actividad(
  id_estado_actividad serial primary key, 
  nombre varchar(20) not null, 
  descripcion varchar(2000)
);
create table actividad(
  id_actividad serial primary key, 
  nombre varchar(50) not null, 
  horas_equivalentes smallint not null constraint chk_actividad_horas_positive check(horas_equivalentes >= 0), 
  descripcion varchar(1000)
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
create table funcionario(
  id_funcionario serial primary key, 
  identificacion varchar(30) unique not null, 
  nombre1 varchar(50) not null, 
  nombre2 varchar(50), 
  apellido1 varchar(50) not null, 
  apellido2 varchar(50), 
  email varchar(100)
);

