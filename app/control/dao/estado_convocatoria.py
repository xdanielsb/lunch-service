from ..connection import query


class EstadoConvocatoria:
    def get_all(self):
        q = "select * from estado_convocatoria"
        return query(q)
