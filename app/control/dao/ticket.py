from ..connection import execute, query


class Ticket:
    def get_all(self, id_beneficiario):
        q = "select * from ticket where id_beneficiario = {}".format(id_beneficiario)
        return query(q)

    def get(self, id_ticket):
        q = "select * from ticket as t, beneficiario as b, solicitud as s, estudiante as e where t.id_beneficiario=b.id_beneficiario and e.id_estudiante = s.id_estudiante  and s.id_solicitud=b.id_solicitud and id_ticket = {}".format(
            id_ticket
        )
        return query(q)

    def get_ticket_almuerzo(self, id_beneficiario):
        qa = "select * from ticket where fecha_uso=current_date and tipo_ticket='almuerzo' and id_beneficiario = {} limit 1".format(
            id_beneficiario
        )
        ans = query(qa)
        if len(ans) != 0:
            return ans
        q = "select * from ticket where fecha_uso is null and tipo_ticket='almuerzo' and id_beneficiario = {} limit 1".format(
            id_beneficiario
        )
        return query(q)

    def get_ticket_refrigerio(self, id_beneficiario):
        qa = "select * from ticket where fecha_uso=current_date and tipo_ticket='refrigerio' and id_beneficiario = {} limit 1".format(
            id_beneficiario
        )
        ans = query(qa)
        if len(ans) != 0:
            return ans
        q = "select * from ticket where fecha_uso is null and tipo_ticket='refrigerio' and id_beneficiario = {} limit 1".format(
            id_beneficiario
        )
        return query(q)

    def usar_ticket(self, id_ticket):
        q = "update ticket set fecha_uso=current_date where id_ticket={}".format(
            id_ticket
        )
        execute(q)
