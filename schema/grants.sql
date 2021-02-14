/*admin*/
GRANT ALL PRIVILEGES ON DATABASE "apoyo_alimentario" to admin;

GRANT ALL ON TABLE PERIODO to admin;
GRANT ALL ON TABLE tipo_subsidio to admin;
GRANT ALL ON TABLE facultad to admin;
GRANT ALL ON TABLE convocatoria to admin;
GRANT ALL ON TABLE convocatoria_facultad to admin;
GRANT ALL ON TABLE tipo_subsidio_convocatoria to admin;
GRANT ALL ON TABLE tipo_documento to admin;
GRANT ALL ON TABLE solicitud to admin;
GRANT ALL ON TABLE documento_solicitud to admin;
GRANT ALL ON TABLE puntaje_tipo_documento to admin;
GRANT ALL ON SEQUENCE convocatoria_id_convocatoria_seq to admin;
GRANT ALL ON SEQUENCE solicitud_id_solicitud_seq to admin;
GRANT ALL ON TABLE estado_documento to admin;
GRANT ALL ON TABLE estado_solicitud to admin;
GRANT ALL ON TABLE estudiante to admin;
GRANT ALL ON TABLE proyecto_curricular to admin;
GRANT ALL ON TABLE actividad_beneficiario to admin;


GRANT ALL ON TABLE beneficiario to admin;
GRANT ALL ON SEQUENCE beneficiario_id_beneficiario_seq to admin;
GRANT ALL ON TABLE historico_solicitud to admin;
GRANT ALL ON SEQUENCE historico_solicitud_id_historico_solicitud_seq to admin;


/*creadorUsuarios*/
GRANT SELECT ON TABLE estudiante to creadorUsuarios;


/*asistente*/
GRANT ALL ON TABLE convocatoria to asistente;
GRANT ALL ON TABLE convocatoria_facultad to asistente;
GRANT ALL ON TABLE tipo_subsidio_convocatoria to asistente;
GRANT SELECT ON TABLE periodo to asistente;
GRANT SELECT ON TABLE documento_solicitud to asistente;
GRANT SELECT ON TABLE tipo_documento to asistente;
GRANT ALL ON TABLE documento_solicitud to asistente;
GRANT SELECT ON TABLE tipo_subsidio to asistente;
GRANT SELECT ON TABLE facultad to asistente;
GRANT SELECT ON TABLE estudiante to asistente;
GRANT SELECT, UPDATE ON TABLE solicitud to asistente;
GRANT SELECT ON TABLE estado_documento to asistente;
GRANT SELECT ON TABLE estado_solicitud to asistente;
GRANT SELECT ON TABLE funcionario to asistente;
GRANT SELECT ON TABLE proyecto_curricular to asistente;
GRANT ALL ON TABLE puntaje_tipo_documento to asistente;
GRANT ALL ON TABLE beneficiario to asistente;
GRANT ALL ON SEQUENCE beneficiario_id_beneficiario_seq to asistente;
GRANT ALL ON SEQUENCE historico_solicitud_id_historico_solicitud_seq to asistente;
GRANT ALL ON TABLE actividad_beneficiario to asistente;
GRANT INSERT,UPDATE, SELECT ON TABLE historico_solicitud to asistente;


GRANT ALL ON SEQUENCE convocatoria_id_convocatoria_seq to asistente;

/*estudiante*/
GRANT SELECT ON TABLE periodo to estudiante;
GRANT SELECT ON TABLE estado_documento to estudiante;
GRANT SELECT ON TABLE convocatoria to estudiante;
GRANT SELECT ON TABLE tipo_documento to estudiante;
GRANT SELECT ON TABLE estudiante to estudiante;
GRANT SELECT ON TABLE tipo_subsidio to estudiante;
GRANT SELECT ON TABLE facultad to estudiante;
GRANT SELECT ON TABLE proyecto_curricular to estudiante;
GRANT SELECT ON TABLE puntaje_tipo_documento to estudiante;
GRANT SELECT ON TABLE estado_solicitud to estudiante;
GRANT SELECT ON TABLE beneficiario to estudiante;
GRANT SELECT ON TABLE actividad_beneficiario to estudiante;
GRANT ALL ON TABLE solicitud to estudiante;
GRANT ALL ON TABLE documento_solicitud to estudiante;
GRANT ALL ON SEQUENCE solicitud_id_solicitud_seq to estudiante;
GRANT INSERT,UPDATE, SELECT ON TABLE historico_solicitud to estudiante;
GRANT ALL ON SEQUENCE historico_solicitud_id_historico_solicitud_seq to estudiante;


GRANT estudiante to e20131020001;
GRANT estudiante to e20132005002;
GRANT asistente to f1020141478;
GRANT asistente to f1010121110;
