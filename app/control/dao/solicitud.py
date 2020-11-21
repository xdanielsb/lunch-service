from ..connection import execute, query


class Solicitud:
    def create(self, data):
        q = "insert into solicitud(id_solicitud, id_estudiante, id_convocatoria) values ({}, {}, {})".format(
            data["id_solicitud"], data["id_estudiante"], data["id_convocatoria"]
        )
        execute(q)

    def get_all(self):
        q = "select id_solicitud, id_estudiante, ultima_actualizacion, id_estado_solicitud, id_convocatoria from solicitud"
        return query(q)

    def get_next_id(self):
        q = "select nextval(pg_get_serial_sequence('solicitud', 'id_solicitud')) as id_solicitud"
        return query(q)[0][0]
