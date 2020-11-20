from ..connection import query, execute


class Convocatoria:
    def is_active(self, fecha_actual):
        q = "select count(*) from convocatoria where fecha_inicio<='{}' and fecha_fin>='{}'".format(
            fecha_actual, fecha_actual
        )
        return query(q)[0] != 0

    def create(self, id_convocatoria, data):
        q = "insert into convocatoria(id_convocatoria, fecha_inicio, fecha_fin, id_periodo, id_estado_convocatoria) values ({}, '{}', '{}', {}, {})".format(
            id_convocatoria,
            data["fecha_inicio"],
            data["fecha_fin"],
            data["id_periodo"],
            data["id_estado_convocatoria"],
        )
        execute(q)

    def delete(self, id_convocatoria):
        q = "delete from convocatoria where id_convocatoria={}".format(id_convocatoria)
        execute(q)

    def get_all(self):
        q = "select id_convocatoria, fecha_inicio, fecha_fin, id_periodo, id_estado_convocatoria from convocatoria"
        return query(q)

    def get_next_id(self):
        q = "select nextval(pg_get_serial_sequence('convocatoria', 'id_convocatoria')) as id_convocatoria"
        return query(q)[0][0]
