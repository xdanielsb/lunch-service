-- AdminRol Grants

GRANT ALL ON periodo TO adminRol; 
GRANT ALL PRIVILEGES ON tipo_subsidio TO adminRol; 
GRANT ALL PRIVILEGES ON facultad TO adminRol; 
GRANT ALL PRIVILEGES ON convocatoria TO adminRol; 
GRANT ALL PRIVILEGES ON convocatoria_facultad TO adminRol; 
GRANT ALL PRIVILEGES ON tipo_subsidio_convocatoria TO adminRol; 
GRANT ALL PRIVILEGES ON tipo_documento TO adminRol; 
GRANT ALL PRIVILEGES ON solicitud TO adminRol; 
GRANT ALL PRIVILEGES ON documento_solicitud TO adminRol; 
GRANT ALL PRIVILEGES ON puntaje_tipo_documento TO adminRol; 
GRANT ALL PRIVILEGES ON estado_documento TO adminRol;
GRANT ALL PRIVILEGES ON estado_solicitud TO adminRol;  
GRANT ALL PRIVILEGES ON estudiante TO adminRol; 
GRANT ALL PRIVILEGES ON proyecto_curricular TO adminRol; 
GRANT ALL PRIVILEGES ON actividad_beneficiario TO adminRol; 
GRANT ALL PRIVILEGES ON ticket TO adminRol; 
GRANT ALL PRIVILEGES ON actividad TO adminRol; 
GRANT ALL PRIVILEGES ON estado_actividad TO adminRol;
GRANT ALL PRIVILEGES ON beneficiario TO adminRol;
GRANT ALL PRIVILEGES ON historico_solicitud TO adminRol;
GRANT ALL PRIVILEGES ON estado_actividad TO adminRol;
GRANT ALL PRIVILEGES ON beneficiario TO adminRol;
GRANT ALL PRIVILEGES ON historico_solicitud TO adminRol;

GRANT CREATE ANY SEQUENCE, ALTER ANY SEQUENCE, DROP ANY SEQUENCE, SELECT ANY SEQUENCE to adminRol;

--GRANT SELECT ON ticket_id_ticket_seq to adminRol;

--GRANT ALL ON SEQUENCE beneficiario_id_beneficiario_seq to admin;

--GRANT ALL ON SEQUENCE historico_solicitud_id_historico_solicitud_seq to admin;
--GRANT ALL ON SEQUENCE actividad_beneficiario_id_actividad_beneficiario_seq to admin;
GRANT GRANT ANY OBJECT PRIVILEGE TO adminRol;
GRANT GRANT ANY ROLE TO adminRol;

GRANT adminRol TO admin WITH ADMIN OPTION;




/* CONSULTAS UTILES*/

--select * from dba_roles; 
--SELECT table_name, privilege FROM DBA_TAB_PRIVS WHERE GRANTEE='ADMIN'; 
-- select table_name, privilege from ROLE_TAB_PRIVS  WHERE role='ADMINROL'; 

--select * from convocatoria where fecha_abierta <= 2021-02-27 and fecha_cerrada >= 2021-02-27;

--select grantee, granted_role from dba_role_privs
--where grantee = upper ('admin')
--order by grantee;