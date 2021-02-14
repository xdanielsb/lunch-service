from ..connection import query


class ActividadBeneficiario:
    def get(self, id_beneficiario):
        q = "select * from actividad_beneficiario where  id_beneficiario={}".format(
            id_beneficiario
        )
        return query(q)
