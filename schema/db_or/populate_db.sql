/** Periodo **/

insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin) values (SEQ_PERIODO.NEXTVAL, '2020-3',to_date('2020-10-27 00:00:00', 'yyyy-mm-dd hh24:mi:ss'), to_date('2021-4-27 23:59:59','yyyy-mm-dd hh24:mi:ss'));
insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin) values (SEQ_PERIODO.NEXTVAL, '2020-1',to_date('2020-02-01 00:00:00','yyyy-mm-dd hh24:mi:ss'), to_date('2020-05-29 23:59:59', 'yyyy-mm-dd hh24:mi:ss'));

/** Estado Documento **/

insert into estado_documento(id_estado_documento, nombre) values (SEQ_ESTADO_DOCUMENTO.NEXTVAL, 'Sin Revisar');
insert into estado_documento(id_estado_documento, nombre) values (SEQ_ESTADO_DOCUMENTO.NEXTVAL, 'Aprovado');
insert into estado_documento(id_estado_documento, nombre) values (SEQ_ESTADO_DOCUMENTO.NEXTVAL, 'Requiere cambios');
insert into estado_documento(id_estado_documento, nombre) values (SEQ_ESTADO_DOCUMENTO.NEXTVAL, 'Rechazado');

/** Tipo Documento **/

insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(SEQ_TIPO_DOCUMENTO.NEXTVAL, 'Formulario de Solicitud de ingreso al Programa Apoyo Alimentario', 1);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(SEQ_TIPO_DOCUMENTO.NEXTVAL, 'Carta dirigida al director del Centro de Bienestar Institucional', 1);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(SEQ_TIPO_DOCUMENTO.NEXTVAL, 'Certificado de estratificación del lugar de residencia del estudiante', 1);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(SEQ_TIPO_DOCUMENTO.NEXTVAL, 'Fotocopia de la factura de un recibo de servicio público de su domicilio', 1);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(SEQ_TIPO_DOCUMENTO.NEXTVAL, 'Certificado de desplazamiento forzoso por violencia del Departamento', 0);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(SEQ_TIPO_DOCUMENTO.NEXTVAL, 'Si es padre/madre, certificado Civil de nacimiento de los o las hijas', 0);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(SEQ_TIPO_DOCUMENTO.NEXTVAL, 'Certificado de Discapacidad Medica, avalado por Bienestar Institucional', 0);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(SEQ_TIPO_DOCUMENTO.NEXTVAL, 'Examen y Diagnostico Médico, Enfermedades presentes del estudiante', 0);

/** Puntaje tipo Documento **/

insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Formulario solicitud bien diligenciado', 1,  100);
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Formulario solicitud mal diligenciado', 1,  0);
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Carta al director bien escrita', 2,100);
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Carta al director mal escrita', 2,0);
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Estrato 1', 3,100  );
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Estrato 2', 3,90  );
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Estrato 3', 3,70  );
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Estrato 4', 3,50  );
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Estrato 5', 3,10  );
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Recibo Actual', 4, 100 );
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Recibo Desactualizado', 4,20  );
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Certificado desplazamiento forzoso correcto', 5, 100 );
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Certificado desplazamiento forzoso invalido', 5, 0 );
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Registro civil nacimento hijos valido', 6, 100  );
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Registro civil nacimento hijos invalido', 6, 0  );
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Certificado discapacidad medica valido', 7, 100 );
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Certificado discapacidad medica invalido', 7, 0  );
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Certificado enfermedades presentes valido ', 8, 100 );
insert into puntaje_tipo_documento(id_puntaje_tipo_documento,nombre, id_tipo_documento, puntaje) values (SEQ_PUNTAJE_TIPO_DOCUMENTO.NEXTVAL,'Certificado enfermedades presentes valido ', 8,  0);


/** Facultad **/

insert into facultad( id_facultad, nombre) values (SEQ_FACULTAD.NEXTVAL,'artes');
insert into facultad( id_facultad, nombre) values (SEQ_FACULTAD.NEXTVAL,'ingenieria');

/** Proyecto Curricular **/

insert into proyecto_curricular(id_proyecto_curricular, id_facultad, nombre) values (SEQ_PROYECTO_CURRICULAR.NEXTVAL, 1, 'electronica');
insert into proyecto_curricular(id_proyecto_curricular, id_facultad, nombre) values (SEQ_PROYECTO_CURRICULAR.NEXTVAL, 2, 'industrial');

/** Estado solicitud**/

insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values(SEQ_ESTADO_SOLICITUD.NEXTVAL, 'en progreso', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values(SEQ_ESTADO_SOLICITUD.NEXTVAL, 'rechazada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values(SEQ_ESTADO_SOLICITUD.NEXTVAL, 'cancelada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values(SEQ_ESTADO_SOLICITUD.NEXTVAL, 'aprobada', '');
insert into estado_solicitud(id_estado_solicitud, estado, descripcion) values(SEQ_ESTADO_SOLICITUD.NEXTVAL, 'requiere cambios', '');

/** Tipo Subsidio **/
insert into tipo_subsidio(id_tipo_subsidio, nombre, porcentaje_subsidiado, puntos_requeridos, horas_semanales_a_cumplir) values(SEQ_TIPO_SUBSIDIO.NEXTVAL, 'tipo A',100, 90, 30);
insert into tipo_subsidio(id_tipo_subsidio, nombre, porcentaje_subsidiado, puntos_requeridos, horas_semanales_a_cumplir) values(SEQ_TIPO_SUBSIDIO.NEXTVAL, 'tipo B',70, 80, 40);


/** Estudiante **/

insert into estudiante(id_estudiante, identificacion, nombre1, apellido1, promedio, matriculas_restantes, email, id_proyecto_curricular) values (SEQ_ESTUDIANTE.NEXTVAL, '20131020001', 'Alberto', 'Sanyas', 4.5, 8, 'alberto@correo.udistrital.edu.co', 2);
insert into estudiante(id_estudiante, identificacion, nombre1, apellido1, promedio, matriculas_restantes, email, id_proyecto_curricular) values (SEQ_ESTUDIANTE.NEXTVAL, '20132005002', 'Gabriela', 'Harris', 5, 8, 'gabriela@correo.udistrital.edu.co', 2);
insert into estudiante(id_estudiante, identificacion, nombre1, apellido1, promedio, matriculas_restantes, email, id_proyecto_curricular) values (SEQ_ESTUDIANTE.NEXTVAL, '20131002001', 'Bill', 'Ribont', 3.9, 2, 'bill@correo.udistrital.edu.co', 1);
insert into estudiante(id_estudiante, identificacion, nombre1, apellido1, promedio, matriculas_restantes, email, id_proyecto_curricular) values (SEQ_ESTUDIANTE.NEXTVAL, '20131020016', 'Daniel', 'Santos', 4.6, 2, 'dfsantosb@correo.udistrital.edu.co', 1);

/** Funcionario **/
insert into funcionario(id_funcionario, identificacion, nombre1, apellido1, email) values(SEQ_FUNCIONARIO.NEXTVAL, '1020141478', 'Kevin', 'Ayala', 'kevin@correo.udistrital.edu.co');
insert into funcionario(id_funcionario, identificacion, nombre1, apellido1, email) values(SEQ_FUNCIONARIO.NEXTVAL, '1010121110', 'Juana', 'Dominga', 'juana@correo.udistrital.edu.co');
insert into funcionario(id_funcionario, identificacion, nombre1, apellido1, email) values(SEQ_FUNCIONARIO.NEXTVAL, '1019742929', 'Juan', 'De Maria', 'juan@correo.udistrital.edu.co');

/** Estado Actividad **/
insert into  estado_actividad(id_estado_actividad, nombre) values(SEQ_ESTADO_ACTIVIDAD.NEXTVAL, 'Por completar');
insert into  estado_actividad(id_estado_actividad, nombre) values(SEQ_ESTADO_ACTIVIDAD.NEXTVAL, 'Completada');


/**  Actividad **/
insert into actividad(id_actividad,nombre, horas_equivalentes) values (SEQ_ACTIVIDAD.NEXTVAL,'Servicio social bienestar social', 2);
insert into actividad(id_actividad,nombre, horas_equivalentes) values (SEQ_ACTIVIDAD.NEXTVAL,'Servicio social coordinación de ingeniería', 1);
insert into actividad(id_actividad,nombre, horas_equivalentes) values (SEQ_ACTIVIDAD.NEXTVAL,'Servicio social decanatura', 3);