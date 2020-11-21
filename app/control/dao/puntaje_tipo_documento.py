from ..connection import query
from collections import defaultdict


class PuntajeTipoDocumento:
    def get_all(self):
        q = "select nombre, id_tipo_documento, puntaje from puntaje_tipo_documento"
        res = defaultdict(list)
        for nombre, id_tipo_documento, puntaje in query(q):
            res[id_tipo_documento].append([nombre, id_tipo_documento, puntaje])
        return res
