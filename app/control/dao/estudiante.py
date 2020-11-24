from ..connection import query


class Estudiante:
    def get(self, iden):
        q = "select id_estudiante, nombre, apellido, email from estudiante where identificacion = '{}'".format(iden)
        return query(q)[0]
