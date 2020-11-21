from ..connection import execute, query


class DocumentoSolicitud:
    def create(self, data):
        q = "insert into documento_solicitud(id_solicitud, id_tipo_documento, url) values({}, {}, '{}')".format(
            data["id_solicitud"], data["id_tipo_documento"], data["url"]
        )
        return execute(q)

    def get(self, id_solicitud):
        q = "select id_tipo_documento, url from documento_solicitud where id_solicitud={}".format(
            id_solicitud
        )
        return query(q)
