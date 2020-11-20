from ..connection import execute


class ConvocatoriaTipoSubsidio:
    def create(self, data):
        q = "insert into tipo_subsidio_convocatoria(id_convocatoria, id_tipo_subsidio, cantidad_de_almuerzos_ofertados) values ({}, {}, {})".format(
            data["id_convocatoria"],
            data["id_tipo_subsidio"],
            data["cantidad_de_almuerzos_ofertados"],
        )
        execute(q)
