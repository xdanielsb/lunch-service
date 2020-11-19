from flask import request
from flask import Flask, render_template, flash, redirect, url_for, session, g
from control.dao.user import User
from control.dao.convocatoria import Convocatoria
from control.dao.periodo import Periodo
from control.dao.tipo_subsidio import TipoSubsidio
from control.dao.facultad import Facultad
import functools
import os
import json
from datetime import date

from control.connection import get_db, query, execute

app = Flask(__name__)
app.config.from_object("config.Config")


@app.before_request
def load_logged_in_user():
    user_id = session.get("user_id")
    if user_id is None:
        g.user = None
    else:
        # TODO: query from db this data
        g.user = {
            "name": "postgres",
            "password": "",
            "rol": "Estudiante",
            "email": "matilda@udistrital.co",
        }


def login_required(view):
    @functools.wraps(view)
    def wrapped_view(**kwargs):
        if g.user is None:
            return redirect(url_for("login"))
        return view(**kwargs)

    return wrapped_view


@app.route("/", methods=["POST", "GET"])
def login():
    if request.method == "POST":
        userDao = User()
        username = request.form["username"]
        password = request.form["password"]
        error = None
        if not username:
            error = "Username is required."
        elif not password:
            error = "Password is required."
        elif userDao.exist(username, password):
            session.clear()
            session["user_id"] = username
            return redirect(url_for("home"))
        flash(error)
    if g.user is None:
        return render_template("login.html")
    return render_template("home.html")


@app.route("/home")
@login_required
def home():
    return render_template("home.html")


@app.route("/solicitud")
@login_required
def solicitud():
    convocatoria = Convocatoria()
    today = date.today()
    if convocatoria.is_active(fecha_actual=today.strftime("%Y-%m-%d")) is not True:
        flash("No hay convocatoria activa.")
        return redirect(url_for("home"))
    return render_template("solicitud.html")


@app.route("/revisar_solicitud")
@login_required
def revisar_solicitud():
    return render_template("revisar-solicitud.html")


@app.route("/convocotoria")
@login_required
def convocatoria():
    if request.method == "POST":
        pass
    else:
        # TODO: make fecha_actual global
        today = date.today()
        periodo = Periodo().get_active_period(fecha_actual=today.strftime("%Y-%m-%d"))
        tipos_subsidio = TipoSubsidio().get_all()
        facultades = Facultad().get_all()
        data = {
            "periodo": periodo,
            "tipos_subsidio": tipos_subsidio,
            "facultades": facultades,
        }
        if len(periodo) == 0:
            flash("No hay periodos activos.")
            return redirect(url_for("home"))
    return render_template("convocatoria.html", data=data)


@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))


if __name__ == "__main__":
    app.run()
