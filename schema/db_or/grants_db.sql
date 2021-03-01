/* PERMISOS */
GRANT connect TO asistenteRol;
GRANT connect TO adminRol;
GRANT connect TO estudianteRol;
GRANT connect TO creadorUsuariosRol;

-- AdminRol Grants
/* adminRol */
GRANT ALL ON periodo to adminRol; 
GRANT ALL ON tipo_subsidio to adminRol; 
GRANT ALL ON facultad to adminRol; 
GRANT ALL ON convocatoria to adminRol; 
GRANT ALL ON convocatoria_facultad to adminRol; 
GRANT ALL ON tipo_subsidio_convocatoria to adminRol; 
GRANT ALL ON tipo_documento to adminRol; 
GRANT ALL ON solicitud to adminRol; 
GRANT ALL ON documento_solicitud to adminRol; 
GRANT ALL ON puntaje_tipo_documento to adminRol; 
GRANT ALL ON estado_documento to adminRol;
GRANT ALL ON estado_solicitud to adminRol;  
GRANT ALL ON estudiante to adminRol; 
GRANT ALL ON proyecto_curricular to adminRol; 
GRANT ALL ON actividad_beneficiario to adminRol; 
GRANT ALL ON ticket to adminRol; 
GRANT ALL ON actividad to adminRol; 
GRANT ALL ON estado_actividad to adminRol;
GRANT ALL ON beneficiario to adminRol;
GRANT ALL ON historico_solicitud to adminRol;
GRANT ALL ON estado_actividad to adminRol;

GRANT CREATE ANY SEQUENCE, ALTER ANY SEQUENCE, DROP ANY SEQUENCE, SELECT ANY SEQUENCE to adminRol;
GRANT GRANT ANY OBJECT PRIVILEGE TO adminRol;
GRANT GRANT ANY ROLE TO adminRol;

GRANT adminRol TO admin WITH ADMIN OPTION;

/* creadorUsuariosRol */
GRANT SELECT ON estudiante to creadorUsuariosRol;

/* asistenteRol */
GRANT ALL ON convocatoria to asistenteRol;
GRANT ALL ON convocatoria_facultad to asistenteRol;
GRANT ALL ON tipo_subsidio_convocatoria to asistenteRol;
GRANT SELECT ON periodo to asistenteRol;
GRANT SELECT ON documento_solicitud to asistenteRol;
GRANT SELECT ON tipo_documento to asistenteRol;
GRANT ALL ON documento_solicitud to asistenteRol;
GRANT SELECT ON tipo_subsidio to asistenteRol;
GRANT SELECT ON facultad to asistenteRol;
GRANT SELECT ON estudiante to asistenteRol;
GRANT SELECT,UPDATE ON solicitud to asistenteRol;
GRANT SELECT ON estado_documento to asistenteRol;
GRANT SELECT ON estado_solicitud to asistenteRol;
GRANT SELECT ON funcionario to asistenteRol;
GRANT SELECT ON proyecto_curricular to asistenteRol;
GRANT ALL ON puntaje_tipo_documento to asistenteRol;
GRANT ALL ON beneficiario to asistenteRol;
GRANT INSERT,UPDATE,SELECT ON historico_solicitud to asistenteRol;
GRANT ALL ON ticket	 to asistenteRol;
GRANT ALL ON actividad to asistenteRol;
GRANT SELECT ON estado_actividad to asistenteRol;

/* estudianteRol */
GRANT SELECT ON periodo to estudianteRol;
GRANT SELECT ON estado_documento to estudianteRol;
GRANT SELECT ON convocatoria to estudianteRol;
GRANT SELECT ON tipo_documento to estudianteRol;
GRANT SELECT ON estudiante to estudianteRol;
GRANT SELECT ON tipo_subsidio to estudianteRol;
GRANT SELECT ON facultad to estudianteRol;
GRANT SELECT ON proyecto_curricular to estudianteRol;
GRANT SELECT ON puntaje_tipo_documento to estudianteRol;
GRANT SELECT ON estado_actividad to estudianteRol;
GRANT SELECT ON beneficiario to estudianteRol;
GRANT SELECT ON actividad_beneficiario to estudianteRol;
GRANT ALL ON solicitud to estudianteRol;
GRANT ALL ON documento_solicitud to estudianteRol;
GRANT INSERT,UPDATE,SELECT ON historico_solicitud to estudianteRol;
GRANT ALL ON ticket to estudianteRol;
GRANT SELECT ON actividad to estudianteRol;
GRANT SELECT ON estado_actividad to estudianteRol;


/* CONSULTAS UTILES*/

--select * from dba_roles; 
--SELECT table_name, privilege FROM DBA_TAB_PRIVS WHERE GRANTEE='ADMIN'; 
-- select table_name, privilege from ROLE_TAB_PRIVS  WHERE role='ADMINROL'; 

--select * from convocatoria where fecha_abierta <= 2021-02-27 and fecha_cerrada >= 2021-02-27;

--select grantee, granted_role from dba_role_privs
--where grantee = upper ('admin')
--order by grantee;