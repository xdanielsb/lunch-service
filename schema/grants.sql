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
GRANT ALL ON TABLE estado_convocatoria to admin;
GRANT ALL ON SEQUENCE convocatoria_id_convocatoria_seq to admin;
GRANT ALL ON SEQUENCE solicitud_id_solicitud_seq to admin;
GRANT ALL ON TABLE estado_documento to admin;
GRANT ALL ON TABLE estado_solicitud to admin;
GRANT ALL ON TABLE estudiante to asistente;

/*asistent*/
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
GRANT ALL ON TABLE puntaje_tipo_documento to asistente;


GRANT SELECT ON TABLE estado_convocatoria to asistente;
GRANT ALL ON SEQUENCE convocatoria_id_convocatoria_seq to asistente;

/*estudiante*/
GRANT SELECT ON TABLE periodo to estudiante;
GRANT SELECT ON TABLE estado_documento to estudiante;
GRANT SELECT ON TABLE convocatoria to estudiante;
GRANT SELECT ON TABLE tipo_documento to estudiante;
GRANT SELECT ON TABLE estudiante to estudiante;
GRANT SELECT ON TABLE tipo_subsidio to estudiante;
GRANT SELECT ON TABLE facultad to estudiante;
GRANT SELECT ON TABLE estado_convocatoria to estudiante;
GRANT SELECT ON TABLE puntaje_tipo_documento to estudiante;
GRANT SELECT ON TABLE estado_solicitud to estudiante;
GRANT ALL ON TABLE solicitud to estudiante;
GRANT ALL ON TABLE documento_solicitud to estudiante;
GRANT ALL ON SEQUENCE solicitud_id_solicitud_seq to estudiante;


GRANT estudiante to e20131020001;
GRANT estudiante to e20132005002;

