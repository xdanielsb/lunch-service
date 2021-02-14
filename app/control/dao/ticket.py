from ..connection import query


class Ticket:
    def get_all(self, id_beneficiario):
        q = "select * from ticket where id_beneficiario = {}".format(id_beneficiario)
        return query(q)

    def get_ticket_almuerzo(self, id_beneficiario):
        q = "select * from ticket where fecha_uso is null and tipo_ticket='almuerzo' and id_beneficiario = {} limit 1".format(
            id_beneficiario
        )
        return query(q)

    def get_ticket_refrigerio(self, id_beneficiario):
        q = "select * from ticket where fecha_uso is null and tipo_ticket='refrigerio' and id_beneficiario = {} limit 1".format(
            id_beneficiario
        )
        return query(q)
