from ..connection import execute, query


class Convocatoria:
    def get_active_current(self, fecha_actual):
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

    def delete(self, id_convocatoria):
        q = "delete from convocatoria where id_convocatoria={}".format(id_convocatoria)
        execute(q)

    def get_all(self):
        q = "select c.id_convocatoria,c.fecha_creacion, c.fecha_abierta, c.fecha_cerrada, c.fecha_publicacion_resultados, p.nombre from convocatoria as c, periodo as p  where p.id_periodo = c.id_periodo"
        return query(q)

    def get_next_id(self):
        q = "select nextval(pg_get_serial_sequence('convocatoria', 'id_convocatoria')) as id_convocatoria"
        return query(q)[0][0]
