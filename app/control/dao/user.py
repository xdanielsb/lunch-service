from ..connection import execute
from ..services import send_email


class User:
    def create(self, stu):
        # TODO this code should be a transaction
        # if error rollback

        username = "e" + stu["identificacion"]
        q = "create ROLE {} LOGIN".format(username)
        execute(q)
        password = "pass_change"
        q = "ALTER ROLE {} with PASSWORD '{}'".format(username, password)
        execute(q)

        subject = "Bienvenido a apoyo alimentario"
        sender = "admin_email"  # TODO: env variable
        message = """
                Un saludo cordial,
                {} {},
                Para acceder al sistema de apoyo alimentario de la
                Universidad Distrital FJC, sus credenciales son las
                siguientes:
                 - Nombre de usuario = {}
                 - Contraseña = {}
                ¡No olvides cambiar tu contraseña!
                Atentamente,
                Equipo Apoyo alementario
                """.format(
            stu["nombre1"], stu["apellido1"], stu["identificacion"], password
        )

        return send_email(subject, sender, stu["email"], message)
