import functools
import os
from datetime import date

import psycopg2
from control import (
    Convocatoria,
    ConvocatoriaFacultad,
    ConvocatoriaTipoSubsidio,
    DocumentoSolicitud,
    EstadoDocumento,
    EstadoSolicitud,
    Estudiante,
    Facultad,
    Periodo,
    PuntajeTipoDocumento,
    Solicitud,
    TipoDocumento,
    TipoSubsidio,
    get_db,
)
from flask import Flask, flash, g, redirect, render_template, request, session, url_for
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.config.from_object("config.Config")
# max file size 16MB
app.config["MAX_CONTENT_LENGTH"] = 16 * 1024 * 1024
path = os.getcwd()
UPLOAD_FOLDER = os.path.join(path, "static/uploads")
ALLOWED_EXTENSIONS = set(["pdf"])
if not os.path.isdir(UPLOAD_FOLDER):
    os.mkdir(UPLOAD_FOLDER)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


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
            if solicitud[0] == g.user["id_estudiante"]:
                return redirect(url_for("revisar_solicitud", id_solicitud=solicitud[0]))
    flash("Su usuario no tiene solicitudes activas")
    return redirect(url_for("home"))


@app.route("/revisar_solicitud", methods=["GET", "POST"])
@app.route("/revisar_solicitud/<id_solicitud>", methods=["GET", "POST"])
@login_required
def revisar_solicitud(id_solicitud=None):
    if request.method == "POST":
        tipos_documento = TipoDocumento().get_all()
        documento_solicitud = DocumentoSolicitud()
        Solicitud().update_estado(
            request.form["id_solicitud"], request.form["id_estado_solicitud"]
        )
        print(request.form)
        for idt, _, nombre_tipo in tipos_documento:
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
        documentos_solicitud = DocumentoSolicitud().get(id_solicitud)
        puntajes = PuntajeTipoDocumento().get_all()
        estados_solicitud = EstadoSolicitud().get_all()
        estados_documento = EstadoDocumento().get_all()
        return render_template(
            "revisar-solicitud.html",
            documentos_solicitud=documentos_solicitud,
            estados_solicitud=estados_solicitud,
            puntajes=puntajes,
            estados_documento=estados_documento,
            id_solicitud=id_solicitud,
            id_estado_solicitud=Solicitud().get_estado(id_solicitud),
        )
    solicitudes = Solicitud().get_all()
    return render_template("listar-solicitudes.html", solicitudes=solicitudes)


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
