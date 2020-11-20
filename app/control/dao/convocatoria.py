from ..connection import execute, query


class Convocatoria:
    def is_active(self, fecha_actual):
        q = "select count(*) from convocatoria where fecha_inicio<='{}' and fecha_fin>='{}'".format(
            fecha_actual, fecha_actual
        )
        ans = query(q)[0]
        return ans[0] != 0

    def exist(self, id_convocatoria):
        q = "select count(*) from convocatoria where id_convocatoria = {}".format(
            id_convocatoria
        )
        ans = query(q)[0]
        return ans[0] != 0

    def create(self, data):
        q = "insert into convocatoria(id_convocatoria, fecha_inicio, fecha_fin, id_periodo, id_estado_convocatoria) values ({}, '{}', '{}', {}, {})".format(
            data["id_convocatoria"],
            data["fecha_inicio"],
            data["fecha_fin"],
            data["id_periodo"],
            data["id_estado_convocatoria"],
        )
        execute(q)

    def update(self, data):
        q = "update convocatoria set fecha_inicio ='{}', fecha_fin='{}', id_periodo={}, id_estado_convocatoria={} where id_convocatoria={}".format(
            data["fecha_inicio"],
            data["fecha_fin"],
            data["id_periodo"],
            data["id_estado_convocatoria"],
            data["id_convocatoria"],
        )
        execute(q)

    def get(self, id_convocatoria):
        q = "select fecha_inicio, fecha_fin, id_periodo, id_estado_convocatoria from convocatoria where id_convocatoria={}".format(
            id_convocatoria
        )
        return query(q)

    def delete(self, id_convocatoria):
        q = "delete from convocatoria where id_convocatoria={}".format(id_convocatoria)
        execute(q)

    def get_all(self):
        q = "select id_convocatoria, fecha_inicio, fecha_fin, id_periodo, id_estado_convocatoria from convocatoria"
        return query(q)

    def get_next_id(self):
        q = "select nextval(pg_get_serial_sequence('convocatoria', 'id_convocatoria')) as id_convocatoria"
        return query(q)[0][0]
