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
DROP ROLE IF EXISTS creadorUsuarios;
create ROLE creadorUsuarios LOGIN CREATEROLE;



/* Students of testing */
/* Note: this two registers must already exist in the table 'student' */
DROP ROLE IF EXISTS e20131020001 ;
create ROLE e20131020001 LOGIN INHERIT;
DROP ROLE IF EXISTS e20132005002 ;
create ROLE e20132005002 LOGIN INHERIT;

/* Funcionarios of testing */
/* Note: this two registers must already exist in the table 'funcionario' */
DROP ROLE IF EXISTS f1020141478;
create ROLE f1020141478 LOGIN INHERIT;
DROP ROLE IF EXISTS f1010121110;
create ROLE f1010121110 LOGIN INHERIT;


/* TODO: Change these passwords */
ALTER ROLE estudiante with PASSWORD 'epass'; 
ALTER ROLE admin with PASSWORD 'apass';
ALTER ROLE asistente with PASSWORD 'apass';
ALTER ROLE creadorUsuarios with PASSWORD 'cpass';


ALTER ROLE e20131020001 with PASSWORD 'epass';
ALTER ROLE e20132005002 with PASSWORD 'epass';
ALTER ROLE f1020141478 with PASSWORD 'fpass';
ALTER ROLE f1010121110 with PASSWORD 'fpass';



