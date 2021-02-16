from ..connection import query


class ActividadBeneficiario:
    def get(self, id_beneficiario):
        q = "select a.nombre as nombre, a.horas_equivalentes, ea.nombre as estado from actividad as a, actividad_beneficiario as ab, estado_actividad as ea where a.id_actividad = ab.id_actividad and ea.id_estado_actividad=ab.id_estado_actividad and id_beneficiario={}".format(
            id_beneficiario
        )
        return query(q)
