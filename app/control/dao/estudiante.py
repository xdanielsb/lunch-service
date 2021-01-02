from ..connection import query


class Estudiante:
    def get(self, iden):
        q = "select * from estudiante where identificacion = '{}'".format(iden)
        return query(q)[0]
