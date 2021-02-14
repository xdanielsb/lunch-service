from ..connection import execute, query


class Beneficiario:
    def get_all(self):
        q = "select * from beneficiario"
        return query(q)

    def get(self, id_solicitud):
        q = "select * from beneficiario where id_solicitud = {}".format(id_solicitud)
        ans = query(q)
        if len(ans) == 0:
            return None
        return ans[0]

    def create(self, data):
        q = "insert into beneficiario (id_tipo_subsidio, id_solicitud) values({},{})".format(
            data["id_tipo_subsidio"], data["id_solicitud"]
        )
        execute(q)

    def delete_all(self):
        q = "delete from beneficiario"
        execute(q)
