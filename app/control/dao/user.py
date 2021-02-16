from ..connection import execute
from ..services import send_email


class User:
    def create(self, stu, send_message=None):
        # TODO this code should be a transaction
        # if error rollback

        # generate a sec-password
        password = "epass"
        username = "e" + stu["identificacion"]

        execute("create ROLE {} LOGIN".format(username))
        execute("ALTER ROLE {} with PASSWORD '{}'".format(username, password))
        execute("GRANT estudiante to {}".format(username))
        ans = True
        if send_message is not None:
            subject = "Bienvenido a apoyo alimentario"
            message = """
                Un saludo cordial,
                {} {},

                Para acceder al sistema de apoyo alimentario de la
                Universidad Distrital, sus credenciales son las
                siguientes:
                 - Nombre de usuario = e{}
                 - Contraseña = {}
                ¡No olvides cambiar tu contraseña!


                Atentamente,
                Equipo Apoyo alimentario
                """.format(
                stu["nombre1"], stu["apellido1"], stu["identificacion"], password
            )
            ans = send_email(subject, stu["email"], message)
        return ans
