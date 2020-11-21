from ..connection import execute


class DocumentoSolicitud:
    def create(self, data):
        q = "insert into documento_solicitud(id_solicitud, id_tipo_documento, url) values({}, {}, '{}')".format(
            data["id_solicitud"], data["id_tipo_documento"], data["url"]
        )
        return execute(q)
