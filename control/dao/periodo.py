class Periodo:
    def __init__(self, conn):
        self.conn = conn

    def get_all(self):
        q = "select id_periodo, nombre from periodo"
        return self.conn.query(q)

    def create(self, id_periodo, fecha_inicio, fecha_fin):
        q = "insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin) values({},{},{})".format(id_periodo, fecha_inicio, fecha_fin)
        self.conn.execute(q)
        
