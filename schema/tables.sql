use apoyo_alimentario;
/* https://www.postgresql.org/docs/13/datatype.html */
/* \i file.sql */
/* \d table_tame */

drop table if exists roles;
create table roles(
   role_id integer primary key,
   role_name varchar (30) unique not null
);
insert into roles(role_id, role_name) values(1, 'estudiante');
insert into roles(role_id, role_name) values(2, 'administrador');

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



