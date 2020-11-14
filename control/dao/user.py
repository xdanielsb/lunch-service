class User:
    def __init__(self, conn):
        self.conn = conn

    def exist(self, username, password):
        q = "select count(*) from usuario as u, estudiante as e where u.id_usuario = e.id_usuario and e.identificacion = '{}' and u.password = '{}'".format(
            username, password
        )
        return {"res": self.conn.query(q)[0]}
