from ..connection import query


class HistoricoSolicitud:

    def get(self, id_solicitud):
        q = "select * from historico_solicitud as s, estado_solicitud as es where s.id_estado_solicitud=es.id_estado_solicitud and id_solicitud={}".format(id_solicitud)
        return query(q)
