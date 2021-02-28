import os
import secrets

from flask import render_template

from ..connection import execute
from ..services import send_email


class User:
    def create(self, stu):
        password = secrets.token_urlsafe(12)
        username = "e" + stu["identificacion"]

        execute("create ROLE {} LOGIN".format(username))
        execute("ALTER ROLE {} with PASSWORD '{}'".format(username, password))
        execute("GRANT estudiante to {}".format(username))
        ans = True
        if os.environ.get("MAIL_USERNAME") is not None:
            subject = "¡ Bienvenido al sistema de apoyo alimentario !"
            data = {
                "password": password,
                "username": username,
                "nombre1": stu["nombre1"],
                "apellido1": stu["apellido1"],
            }
            message = render_template("email.html", user=data)
            ans = send_email(subject, stu["email"], message)
        return ans
