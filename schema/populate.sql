/** Periodo **/
insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin) values (1, '2020-3','2020-10-27 00:00:00', '2021-4-27 23:59:59');
insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin) values (2, '2020-1','2020-02-01 00:00:00', '2020-05-29 23:59:59');


/** Estado Documento **/

insert into estado_documento(id_estado_documento, nombre) values (1, 'Sin Revisar');
insert into estado_documento(id_estado_documento, nombre) values (2, 'Aprovado');
insert into estado_documento(id_estado_documento, nombre) values (3, 'Requiere cambios');
insert into estado_documento(id_estado_documento, nombre) values (4, 'Rechazado');

/** Tipo Documento **/
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(1, 'Formulario de Solicitud de ingreso al Programa Apoyo Alimentario', 1);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(2, 'Carta dirigida al director del Centro de Bienestar Institucional', 1);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(3, 'Certificado de estratificación del lugar de residencia del estudiante', 1);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(4, 'Fotocopia de la factura de un recibo de servicio público de su domicilio', 1);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(5, 'Certificado de desplazamiento forzoso por violencia del Departamento', 0);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(6, 'Si es padre/madre, certificado Civil de nacimiento de los o las hijas', 0);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(7, 'Certificado de Discapacidad Medica, avalado por Bienestar Institucional', 0);
insert into tipo_documento(id_tipo_documento, nombre, obligatorio) values(8, 'Examen y Diagnostico Médico, Enfermedades presentes del estudiante', 0);

/** Puntaje tipo Documento **/

insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Formulario solicitud bien diligenciado', 1,  100);
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Formulario solicitud mal diligenciado', 1,  0);
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Carta al director bien escrita', 2,100);
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Carta al director mal escrita', 2,100);
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Estrato 1', 3,100  );
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Estrato 2', 3,90  );
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Estrato 3', 3,70  );
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Estrato 4', 3,50  );
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Estrato 5', 3,10  );
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Recibo Actual', 4, 100 );
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Recibo Desactualizado', 4,20  );
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Certificado desplazamiento forzoso correcto', 5, 100 );
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Certificado desplazamiento forzoso invalido', 5, 0 );
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Registro civil nacimento hijos valido', 6, 100  );
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Registro civil nacimento hijos invalido', 6, 0  );
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Certificado discapacidad medica valido', 7, 100 );
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Certificado discapacidad medica invalido', 7, 0  );
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Certificado enfermedades presentes valido ', 8, 100 );
insert into puntaje_tipo_documento(nombre, id_tipo_documento, puntaje) values ('Certificado enfermedades presentes valido ', 8,  0);

/** Facultad **/

insert into facultad( id_facultad, nombre) values (1,'artes');
insert into facultad( id_facultad, nombre) values (2,'ingenieria');


/** Proyecto Curricular **/

insert into proyecto_curricular(id_proyecto_curricular, id_facultad, nombre) values ( 1, 1, 'electronica');
insert into proyecto_curricular(id_proyecto_curricular, id_facultad, nombre) values ( 2, 2, 'industrial');


/** Tipo Subsidio **/
insert into tipo_subsidio(id_tipo_subsidio, nombre, porcentaje_subsidiado, puntos_requeridos, horas_semanales_a_cumplir) values(1, 'tipo A',100, 90, 30);
insert into tipo_subsidio(id_tipo_subsidio, nombre, porcentaje_subsidiado, puntos_requeridos, horas_semanales_a_cumplir) values(2, 'tipo B',70, 80, 40);


/** Estudiante **/
/* It is supposed that the students and officers already exist */
insert into estudiante(id_estudiante, identificacion, nombre1, apellido1, promedio, matriculas_restantes, email, id_proyecto_curricular) values (1, '20131020001', 'Alberto', 'Sanyas', 4.5, 8, 'alberto@correo.udistrital.edu.co', 2);
insert into estudiante(id_estudiante, identificacion, nombre1, apellido1, promedio, matriculas_restantes, email, id_proyecto_curricular) values (2, '20132005002', 'Gabriela', 'Harris', 5, 8, 'gabriela@correo.udistrital.edu.co', 2);
insert into estudiante(id_estudiante, identificacion, nombre1, apellido1, promedio, matriculas_restantes, email, id_proyecto_curricular) values (3, '20131002001', 'Bill', 'Ribont', 3.9, 2, 'bill@correo.udistrital.edu.co', 1);

/** Funcionario **/
insert into funcionario(id_funcionario, identificacion, nombre1, apellido1, email) values(1, '1020141478', 'Kevin', 'Ayala', 'kevin@correo.udistrital.edu.co');
insert into funcionario(id_funcionario, identificacion, nombre1, apellido1, email) values(2, '1010121110', 'Juana', 'Dominga', 'juana@correo.udistrital.edu.co');
insert into funcionario(id_funcionario, identificacion, nombre1, apellido1, email) values(3, '1019742929', 'Juan', 'De Maria', 'juan@correo.udistrital.edu.co');

