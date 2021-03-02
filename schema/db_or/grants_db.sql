/* PERMISOS */
GRANT connect TO asistenteRol;
GRANT connect TO adminRol;
GRANT connect TO estudianteRol;
GRANT connect TO creadorUsuariosRol;

-- AdminRol Grants
/* adminRol */
GRANT ALL ON ADMIN.periodo to adminRol; 
GRANT ALL ON ADMIN.tipo_subsidio to adminRol; 
GRANT ALL ON ADMIN.facultad to adminRol; 
GRANT ALL ON ADMIN.convocatoria to adminRol; 
GRANT ALL ON ADMIN.convocatoria_facultad to adminRol; 
GRANT ALL ON ADMIN.tipo_subsidio_convocatoria to adminRol; 
GRANT ALL ON ADMIN.tipo_documento to adminRol; 
GRANT ALL ON ADMIN.solicitud to adminRol; 
GRANT ALL ON ADMIN.documento_solicitud to adminRol; 
GRANT ALL ON ADMIN.puntaje_tipo_documento to adminRol; 
GRANT ALL ON ADMIN.estado_documento to adminRol;
GRANT ALL ON ADMIN.estado_solicitud to adminRol;  
GRANT ALL ON ADMIN.estudiante to adminRol; 
GRANT ALL ON ADMIN.proyecto_curricular to adminRol; 
GRANT ALL ON ADMIN.actividad_beneficiario to adminRol; 
GRANT ALL ON ADMIN.ticket to adminRol; 
GRANT ALL ON ADMIN.actividad to adminRol; 
GRANT ALL ON ADMIN.estado_actividad to adminRol;
GRANT ALL ON ADMIN.beneficiario to adminRol;
GRANT ALL ON ADMIN.historico_solicitud to adminRol;
GRANT ALL ON ADMIN.estado_actividad to adminRol;

GRANT CREATE ANY SEQUENCE, ALTER ANY SEQUENCE, DROP ANY SEQUENCE, SELECT ANY SEQUENCE to adminRol;
GRANT GRANT ANY OBJECT PRIVILEGE TO adminRol;
GRANT GRANT ANY ROLE TO adminRol;

/* creadorUsuariosRol */
GRANT SELECT ON ADMIN.estudiante to creadorUsuariosRol;

/* asistenteRol */
GRANT ALL ON ADMIN.convocatoria to asistenteRol;
GRANT ALL ON ADMIN.convocatoria_facultad to asistenteRol;
GRANT ALL ON ADMIN.tipo_subsidio_convocatoria to asistenteRol;
GRANT SELECT ON ADMIN.periodo to asistenteRol;
GRANT SELECT ON ADMIN.documento_solicitud to asistenteRol;
GRANT SELECT ON ADMIN.tipo_documento to asistenteRol;
GRANT ALL ON ADMIN.documento_solicitud to asistenteRol;
GRANT SELECT ON ADMIN.tipo_subsidio to asistenteRol;
GRANT SELECT ON ADMIN.facultad to asistenteRol;
GRANT SELECT ON ADMIN.estudiante to asistenteRol;
GRANT SELECT,UPDATE ON ADMIN.solicitud to asistenteRol;
GRANT SELECT ON ADMIN.estado_documento to asistenteRol;
GRANT SELECT ON ADMIN.estado_solicitud to asistenteRol;
GRANT SELECT ON ADMIN.funcionario to asistenteRol;
GRANT SELECT ON ADMIN.proyecto_curricular to asistenteRol;
GRANT ALL ON ADMIN.puntaje_tipo_documento to asistenteRol;
GRANT ALL ON ADMIN.beneficiario to asistenteRol;
GRANT INSERT,UPDATE,SELECT ON ADMIN.historico_solicitud to asistenteRol;
GRANT ALL ON ADMIN.ticket	 to asistenteRol;
GRANT ALL ON ADMIN.actividad to asistenteRol;
GRANT SELECT ON ADMIN.estado_actividad to asistenteRol;


/* estudianteRol */
GRANT SELECT ON ADMIN.periodo to estudianteRol;
GRANT SELECT ON ADMIN.estado_documento to estudianteRol;
GRANT SELECT ON ADMIN.convocatoria to estudianteRol;
GRANT SELECT ON ADMIN.tipo_documento to estudianteRol;
GRANT SELECT ON ADMIN.estudiante to estudianteRol;
GRANT SELECT ON ADMIN.tipo_subsidio to estudianteRol;
GRANT SELECT ON ADMIN.facultad to estudianteRol;
GRANT SELECT ON ADMIN.proyecto_curricular to estudianteRol;
GRANT SELECT ON ADMIN.puntaje_tipo_documento to estudianteRol;
GRANT SELECT ON ADMIN.estado_actividad to estudianteRol;
GRANT SELECT ON ADMIN.beneficiario to estudianteRol;
GRANT SELECT ON ADMIN.actividad_beneficiario to estudianteRol;
GRANT ALL ON ADMIN.solicitud to estudianteRol;
GRANT ALL ON ADMIN.documento_solicitud to estudianteRol;
GRANT INSERT,UPDATE,SELECT ON ADMIN.historico_solicitud to estudianteRol;
GRANT ALL ON ADMIN.ticket to estudianteRol;
GRANT SELECT ON ADMIN.actividad to estudianteRol;
GRANT SELECT ON ADMIN.estado_actividad to estudianteRol;


GRANT adminRol TO ADMIN WITH ADMIN OPTION;
GRANT creadorUsuariosRol TO creadorUsuarios;
GRANT asistenteRol TO asistente;
GRANT estudianteRol TO student;