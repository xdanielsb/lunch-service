from ..connection import query


class User:
    def exist(self, username, password):
        q = "select count(*) from usuario as u, estudiante as e where u.id_usuario = e.id_usuario and e.identificacion = '{}' and u.password = '{}'".format(
            username, password
        )
        ans = query(q)[0]
        return ans[0] != 0
