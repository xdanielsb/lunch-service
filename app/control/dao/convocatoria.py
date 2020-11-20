from ..connection import query, execute


class Convocatoria:
    def is_active(self, fecha_actual):
        q = "select count(*) from convocatoria where fecha_inicio<='{}' and fecha_fin>='{}'".format(
            fecha_actual, fecha_actual
        )
        return query(q)[0] != 0

    def create(self, data):
        q = "insert into convocatoria(fecha_inicio, fecha_fin, id_periodo, id_estado_convocatoria) values ('{}', '{}', {}, {})".format(
            data["fecha_inicio"],
            data["fecha_fin"],
            data["id_periodo"],
            data["id_estado_convocatoria"],
        )
        print(data)
        print(q)
        execute(q)
    
    def get_all(self):
        q = "select id_convocatoria, fecha_inicio, fecha_fin, id_periodo, id_estado_convocatoria from convocatoria"
        return query(q)
