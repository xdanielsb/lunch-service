class Convocatoria:
    def __init__(self, conn):
        self.conn = conn

    def is_active(self, fecha_actual):
        q = "select count(*) from convocatoria where fecha_inicio<='{}' and fecha_fin>='{}'".format(
            fecha_actual, fecha_actual
        )
        return self.conn.query(q)[0] != 0
