import functools
import os
from datetime import date

import psycopg2
from flask import (flash, g, redirect, render_template, request, session,
                   url_for)
from werkzeug.utils import secure_filename

from . import app
from .control import (Convocatoria, ConvocatoriaFacultad,
                      ConvocatoriaTipoSubsidio, DocumentoSolicitud,
                      EstadoDocumento, EstadoSolicitud, Estudiante, Facultad,
                      Funcionario, Periodo, PuntajeTipoDocumento, Solicitud,
                      TipoDocumento, TipoSubsidio, User, get_db)


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ["pdf"]


@app.before_request
def load_logged_in_user():
    user_id = session.get("username")
    if user_id is None:
        g.user = None
    else:
        password = session.get("password")
        g.user = {
            "username": user_id,
            "password": password,
            "rol": user_id,
        }
        if g.user["rol"].startswith("e"):
            g.user.update(Estudiante().get(g.user["rol"][1:]))
        if g.user["rol"].startswith("f"):
            g.user.update(Funcionario().get(g.user["rol"][1:]))


def login_required(view):
    @functools.wraps(view)
    def wrapped_view(**kwargs):
        if g.user is None:
            return redirect(url_for("login"))
        return view(**kwargs)

    return wrapped_view


@app.route("/registro", methods=["POST", "GET"])
def signup():
    if request.method == "POST":
        email = request.form["email"]
        g.user = {
            "username": "conexion",
            "password": "cpass",
            "rol": "conexion",
        }
        ans = Estudiante().get_by_email(email)
        if len(ans) == 0:
            flash("Estudiante no existe en la base de datos")
        if User.create(ans[0]):
            flash("Hemos enviado a tu correo institucional las credenciales de accesso")
    return render_template("create-user.html")


@app.route("/", methods=["POST", "GET"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        if app.config["TESTING"]:
            if username == "username" and password == "right_password":
                return redirect(url_for("home"))
            return redirect(url_for("login"))
        error = None
        if not username:
            error = "Username is required."
        elif not password:
            error = "Password is required."
        elif get_db(username, password) is not None:
            session.clear()
            session["username"] = username
            session["password"] = password
            return redirect(url_for("home"))
        else:
            error = "Invalid Credentials"
        flash(error)
    if g.user is None:
        return render_template("login.html")
    return redirect(url_for("home"))


@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))


@app.route("/home")
@login_required
def home():
    return render_template("home.html")


@app.route("/convocotoria", methods=["POST", "GET"])
@app.route("/convocotoria/<id_convocatoria>", methods=["POST", "GET"])
@login_required
def convocatoria(id_convocatoria=None):
    data = {}
    convocatoria = Convocatoria()
    if request.method == "POST":
        isUpdate = (
            True if convocatoria.exist(request.form["id_convocatoria"]) else False
        )

        if isUpdate:
            convocatoria.update(request.form)
            flash("Convocatoria actualizada exitosamente")
        else:
            convocatoria.create(request.form)
            flash("Convocatoria creada exitosamente")

        cf = ConvocatoriaFacultad()
        for field in request.form:
            if field.startswith("facultad"):
                id_facultad = int(field.replace("facultad", ""))
                data = {
                    "id_facultad": id_facultad,
                    "id_convocatoria": request.form["id_convocatoria"],
                    "cantidad_de_almuerzos": request.form[field],
                }
                if isUpdate:
                    cf.update(data)
                else:
                    cf.create(data)

        cts = ConvocatoriaTipoSubsidio()
        for field in request.form:
            if field.startswith("tipo_subsidio"):
                id_tipo_subsidio = int(field.replace("tipo_subsidio", ""))
                data = {
                    "id_tipo_subsidio": id_tipo_subsidio,
                    "id_convocatoria": request.form["id_convocatoria"],
                    "cantidad_de_almuerzos_ofertados": request.form[field],
                }
                if isUpdate:
                    cts.update(data)
                else:
                    cts.create(data)
        return redirect(url_for("convocatoria_view"))

    active_periodo = Periodo().get_active_period(
        fecha_actual=date.today().strftime("%Y-%m-%d")
    )
    if len(active_periodo) == 0:
        flash("No hay periodos activos.")
        return redirect(url_for("home"))

    data = {
        "periodo": active_periodo,
        "tipos_subsidio": TipoSubsidio().get_all(),
        "facultades": Facultad().get_all(),
    }

    if id_convocatoria is not None:
        if convocatoria.exist(id_convocatoria):
            data.update(convocatoria.get(id_convocatoria=id_convocatoria)[0])
            for id_fac, num in ConvocatoriaFacultad().get(
                id_convocatoria=id_convocatoria
            ):
                data["facultad{}".format(id_fac)] = num
            for id_tipo_sub, num in ConvocatoriaTipoSubsidio().get(
                id_convocatoria=id_convocatoria
            ):
                data["tipo_subsidio{}".format(id_tipo_sub)] = num
    else:
        data["id_convocatoria"] = convocatoria.get_next_id()
        data["fecha_creacion"] = date.today().strftime("%Y-%m-%d")

    return render_template("convocatoria.html", data=data)


@app.route("/convocatoria/view")
@login_required
def convocatoria_view():
    convocatorias = Convocatoria().get_all()
    return render_template("consultar-convocatoria.html", convocatorias=convocatorias)


@app.route("/convocatoria/edit/<id_convocatoria>")
@login_required
def convocatoria_edit(id_convocatoria):
    convocatorias = Convocatoria().get(id_convocatoria=id_convocatoria)
    return render_template("consultar-convocatoria.html", convocatorias=convocatorias)


@app.route("/convocatoria/delete/<id_convocatoria>")
@login_required
def convocatoria_delete(id_convocatoria):
    Convocatoria().delete(id_convocatoria)
    flash("Convocatoria {} fue eliminada exitosamente.".format(id_convocatoria))
    return redirect(url_for("home"))


# TODO: do update solicitud
@app.route("/solicitud", methods=["GET", "POST"])
@login_required
def solicitud():
    if request.method == "POST":
        solicitud = Solicitud()
        id_solicitud = solicitud.get_next_id()
        data = {
            "id_solicitud": id_solicitud,
            "id_estudiante": g.user["id_estudiante"],
            "id_convocatoria": request.form["id_convocatoria"],
        }
        solicitud.create(data)

        for name_file in request.files:
            file = request.files[name_file]
            if file and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                url = os.path.join(app.config["UPLOAD_FOLDER"], filename)
                file.save(url)
                data = {
                    "id_solicitud": id_solicitud,
                    "id_tipo_documento": name_file,
                    "url": filename,
                }
                DocumentoSolicitud().create(data)
        flash("Archivos exitosamente guardados")
        return redirect(url_for("home"))

    convocatoria = Convocatoria()
    id_convocatoria = convocatoria.get_active_current(
        fecha_actual=date.today().strftime("%Y-%m-%d")
    )
    if id_convocatoria is None:
        flash("No hay convocatoria activa.")
        return redirect(url_for("home"))

    tipos_documento = TipoDocumento().get_all()
    return render_template(
        "solicitud.html",
        id_convocatoria=id_convocatoria,
        tipos_documento=tipos_documento,
    )


@login_required
@app.route("/consultar_solicitud")
def consultar_solicitud():
    if g.user.get("id_estudiante") is not None:
        solicitudes = Solicitud().get_all2()
        for solicitud in solicitudes:
            if solicitud["id_estudiante"] == g.user["id_estudiante"]:
                return redirect(
                    url_for("revisar_solicitud", id_solicitud=solicitud["id_solicitud"])
                )
    flash("Su usuario no tiene solicitudes activas")
    return redirect(url_for("home"))


@app.route("/revisar_solicitud", methods=["GET", "POST"])
@app.route("/revisar_solicitud/<id_solicitud>", methods=["GET", "POST"])
@login_required
def revisar_solicitud(id_solicitud=None):
    if request.method == "POST":
        documento_solicitud = DocumentoSolicitud()
        Solicitud().update_estado(
            request.form["id_solicitud"], request.form["id_estado_solicitud"]
        )
        for idt, _, nombre_tipo in TipoDocumento().get_all():
            if "doc{}".format(idt) in request.form:
                data = {
                    "comentarios": request.form["comentario{}".format(idt)],
                    "id_solicitud": request.form["id_solicitud"],
                    "id_tipo_documento": idt,
                    "id_estado_documento": request.form[
                        "estado_documento{}".format(idt)
                    ],
                    "id_puntaje_tipo_documento": request.form[
                        "tipo_puntaje{}".format(idt)
                    ],
                }
                documento_solicitud.update(data)
                flash("Documento {} Revisado".format(nombre_tipo))
        return redirect(url_for("revisar_solicitud"))
    if id_solicitud is not None:
        return render_template(
            "revisar-solicitud.html",
            documentos_solicitud=DocumentoSolicitud().get(id_solicitud),
            estados_solicitud=EstadoSolicitud().get_all(),
            puntajes=PuntajeTipoDocumento().get_all(),
            estados_documento=EstadoDocumento().get_all(),
            id_solicitud=id_solicitud,
            id_estado_solicitud=Solicitud().get_estado(id_solicitud),
        )
    return render_template("listar-solicitudes.html", solicitudes=Solicitud().get_all())


@app.errorhandler(psycopg2.Error)
def handle_exception(e):
    """Return JSON instead of HTML for HTTP errors."""
    response = {
        "code": e.pgcode,
        "error": e.pgerror,
    }
    return response


if __name__ == "__main__":
    app.run(host="0.0.0.0", threaded=True)
