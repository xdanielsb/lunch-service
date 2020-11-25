from ..connection import query


class User:
    def exist(self, username, password):
        q = "select count(*) from pg_roles as u, estudiante as e where e.identificacion = '{}' and u.rolpassword = '{}'".format(
            username, password
        )
        ans = query(q)[0]
        return ans[0] != 0
