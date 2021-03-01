import os

from flask import render_template

from ..connection import execute, query
from ..services import send_email
from .beneficiario import Beneficiario


class Convocatoria:
    def get_current_active(self, fecha_actual):
        q = "select * from convocatoria where fecha_abierta <= '{}' and fecha_cerrada >= '{}'".format(
            fecha_actual, fecha_actual
        )
        ans = query(q)
        if len(ans) == 0:
            return None
        return ans[0]

    def exist(self, id_convocatoria):
        q = "select count(*) from convocatoria where id_convocatoria = {}".format(
            id_convocatoria
        )
        ans = query(q)[0]
        return ans[0] != 0

    def create(self, data):
        q = "insert into convocatoria(id_convocatoria, fecha_creacion, fecha_abierta, fecha_cerrada, fecha_publicacion_resultados, id_periodo) values ({}, '{}', '{}', '{}', '{}', {})".format(
            data["id_convocatoria"],
            data["fecha_creacion"],
            data["fecha_abierta"],
            data["fecha_cerrada"],
            data["fecha_publicacion_resultados"],
            data["id_periodo"],
        )
        execute(q)

    def update(self, data):
        q = "update convocatoria set  fecha_abierta='{}' , fecha_cerrada='{}' , fecha_publicacion_resultados='{}', id_periodo={} where id_convocatoria={}".format(
            data["fecha_abierta"],
            data["fecha_cerrada"],
            data["fecha_publicacion_resultados"],
            data["id_periodo"],
            data["id_convocatoria"],
        )
        execute(q)

    def get(self, id_convocatoria):
        q = "select * from convocatoria where id_convocatoria={}".format(
            id_convocatoria
        )
        return query(q)

    def lunch_facs_equal_lunch_types(self, id_convocatoria):
        # verify the sum of tipo_subsidio_convocatoria is the same of convocatoria_facultad
        q1 = query(
            "select sum(cant_almuerzos_ofertados) from tipo_subsidio_convocatoria where id_convocatoria={}".format(
                id_convocatoria
            )
        )
        q2 = query(
            "select sum(cantidad_de_almuerzos) from convocatoria_facultad where id_convocatoria={}".format(
                id_convocatoria
            )
        )
        return q1[0][0] == q2[0][0]

    def compute_results(self, id_convocatoria):
        execute("call compute_scores_in_convocatory({})".format(id_convocatoria))

    def generar_beneficiarios(self, id_convocatoria):
        self.compute_results(id_convocatoria)
        # get the best solicitudes(id_solicitud, id_facultad) from best to worst for a given convocatoria (order by puntaje desc)
        # id_estado_solicitud = 4, hacer un join para decir estado=aprobado
        q1 = query(
            "select id_solicitud, id_facultad, e.email, e.nombre1, e.apellido1 as email_aprob from solicitud as s, estudiante as e, proyecto_curricular as p  where id_estado_solicitud=4 and id_convocatoria = {} and s.id_estudiante=e.id_estudiante and p.id_proyecto_curricular=e.id_proyecto_curricular order by puntaje desc".format(
                id_convocatoria
            )
        )
        # get the tipo_subsidios from the best to worst for a given convocatoria (order by porcentaje_subsidiado desc)
        q2 = query(
            "select * from tipo_subsidio as ts, tipo_subsidio_convocatoria as tsc where ts.id_tipo_subsidio=tsc.id_tipo_subsidio and id_convocatoria={} order by porcentaje_subsidiado desc".format(
                id_convocatoria
            )
        )
        # get the number of lunches per convocatoria and tipo subsidio
        q3 = dict(
            query(
                "select id_tipo_subsidio, cant_almuerzos_ofertados from tipo_subsidio_convocatoria where id_convocatoria={}".format(
                    id_convocatoria
                )
            )
        )
        # get the number of lunche per convocatoria and facultad
        q4 = dict(
            query(
                "select id_facultad, cantidad_de_almuerzos from convocatoria_facultad where id_convocatoria={}".format(
                    id_convocatoria
                )
            )
        )

        # here we go!, gimme luck !
        for id_solicitud, id_facultad, email, nombre1, apellido1 in q1:
            data_email = {
                "nombre1": nombre1,
                "apellido1": apellido1,
                "email": email,
            }
            if len(q2) > 0:  # is there any lunches left to assign?
                # find the tipo subsidio to assign, from best to worst
                tipo_subsidio_to_assign = q2[0]["id_tipo_subsidio"]
                while len(q2) and q3[tipo_subsidio_to_assign] == 0:
                    q2.pop(0)
                    if len(q2):
                        tipo_subsidio_to_assign = q2[0]["id_tipo_subsidio"]
                if q3[tipo_subsidio_to_assign] == 0:
                    break

                if q4[id_facultad] > 0:  # there are places left in that fac
                    # we have a winner
                    data = {
                        "id_tipo_subsidio": tipo_subsidio_to_assign,
                        "id_solicitud": id_solicitud,
                    }
                    Beneficiario().create(data)

                    self.send_email_new_beneficiario(data_email)
                    q4[id_facultad] = (
                        q4[id_facultad] - 1
                    )  # decrease the places in that fact
                    q3[tipo_subsidio_to_assign] = q3[tipo_subsidio_to_assign] - 1
                    if q3[tipo_subsidio_to_assign] == 0:
                        q2.pop(0)  # remove the first

    def send_email_new_beneficiario(self, data):
        if os.environ.get("MAIL_USERNAME") is not None:
            subject = "Tu solicitud ha sido aprobada - Apoyo alimentario"
            message = render_template("emailbeneficiario.html", user=data)
            send_email(subject, data["email"], message)

    def get_results(self, id_convocatoria):
        q = "select * from (select nombre1, apellido1, puntaje, pc.nombre as proyecto_curricular, identificacion, s.id_solicitud  from estudiante as e, solicitud as s, convocatoria as c, proyecto_curricular as pc where e.id_proyecto_curricular = pc.id_proyecto_curricular and  e.id_estudiante=s.id_estudiante and c.id_convocatoria=s.id_convocatoria and c.id_convocatoria={}) as r1 left join (select b1.id_solicitud, b2.nombre as ntipo_subsidio  from beneficiario as b1, tipo_subsidio as b2 where b1.id_tipo_subsidio=b2.id_tipo_subsidio ) as  r2 on r1.id_solicitud=r2.id_solicitud".format(
            id_convocatoria
        )
        return query(q)

    def asignar_tickets(self, id_convocatoria):
        execute("call assign_tickets({})".format(id_convocatoria))
        execute("call assign_activities({})".format(id_convocatoria))

    def delete(self, id_convocatoria):
        q = "delete from convocatoria where id_convocatoria={}".format(id_convocatoria)
        execute(q)

    def get_all(self):
        q = "select c.id_convocatoria,c.fecha_creacion, c.fecha_abierta, c.fecha_cerrada, c.fecha_publicacion_resultados, p.nombre from convocatoria as c, periodo as p  where p.id_periodo = c.id_periodo"
        return query(q)

    def get_next_id(self):
        q = "select nextval(pg_get_serial_sequence('convocatoria', 'id_convocatoria')) as id_convocatoria"
        return query(q)[0][0]
