from ..connection import execute


class ConvocatoriaFacultad:
    def create(self, data):
        q = "insert into convocatoria_facultad(id_convocatoria, id_facultad, cantidad_de_almuerzos) values({}, {}, {})".format(
            data["id_convocatoria"], data["id_facultad"], data["cantidad_de_almuerzos"]
        )
        execute(q)
