DROP ROLE adminRol;
DROP ROLE estudianteRol;
DROP ROLE creadorUsuariosRol;
DROP ROLE asistenteRol;

/* CREACIÓN DE ROLES */

CREATE ROLE adminRol IDENTIFIED BY apass;
CREATE ROLE estudianteRol IDENTIFIED BY apass;
CREATE ROLE creadorUsuariosRol IDENTIFIED BY apass;
CREATE ROLE asistenteRol IDENTIFIED BY apass;


/* PERMISOS */
GRANT connect TO asistenteRol;
GRANT connect TO adminRol;
GRANT connect TO estudianteRol;
GRANT connect TO creadorUsuariosRol;

