/* Query all possible roles */
/* SELECT * from pg_roles; */
/* better: \du */

/* Query all possible schemas */
/* SELECT nspname FROM pg_catalog.pg_namespace; */

/* query grants by user and table */
/* SELECT table_catalog, table_schema, table_name, privilege_type */
/* FROM   information_schema.table_privileges */ 
/* WHERE  grantee ='estudiante' and table_name ='puntaje_tipo_documento'; */

/*query tablespaces*/
/* select spcname from pg_tablespace; */

/* psql apoyo_alimentario -U e20131020001 */

/* Create role estudiante */
DROP ROLE IF EXISTS estudiante;
create ROLE estudiante LOGIN;
DROP ROLE IF EXISTS admin;
create ROLE admin LOGIN;
DROP ROLE IF EXISTS asistente;
create ROLE asistente LOGIN;
DROP ROLE IF EXISTS conexion;
create ROLE conexion LOGIN CREATEROLE;

create ROLE e20131020001 LOGIN INHERIT;
create ROLE e20132005002 LOGIN INHERIT;

/* TODO: Change these passwords */
ALTER ROLE estudiante with PASSWORD 'epass'; 
ALTER ROLE admin with PASSWORD 'apass';
ALTER ROLE asistente with PASSWORD 'apass';
ALTER ROLE conexion with PASSWORD 'cpass';


ALTER ROLE e20131020001 with PASSWORD 'estudiante';
ALTER ROLE e20132005002 with PASSWORD 'estudiante';



