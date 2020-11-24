/* Query all possible roles */
/* SELECT * from pg_roles; */
/* better: \du */

/* Query all possible schemas */
/* SELECT nspname FROM pg_catalog.pg_namespace; */

/* SELECT table_catalog, table_schema, table_name, privilege_type */
/* FROM   information_schema.table_privileges */ 
/* WHERE  grantee ='estudiante' and table_name ='puntaje_tipo_documento'; */

/* Create role estudiante */
create ROLE estudiante LOGIN;
create ROLE admin LOGIN;
create ROLE asistente LOGIN;
create ROLE e20131020001 LOGIN INHERIT;
create ROLE e20132005002 LOGIN INHERIT;
ALTER ROLE estudiante with PASSWORD 'estudiante_pass';
ALTER ROLE admin with PASSWORD 'admin_pass';
ALTER ROLE e20131020001 with PASSWORD 'estudiante';
ALTER ROLE e20132005002 with PASSWORD 'estudiante';



