from ..connection import query 

class Convocatoria:

    def is_active(self, fecha_actual):
        q = "select count(*) from convocatoria where fecha_inicio<='{}' and fecha_fin>='{}'".format(
            fecha_actual, fecha_actual
        )
        return query(q)[0] != 0
