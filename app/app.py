import functools
import os
from datetime import date

from control.dao.convocatoria import Convocatoria
from control.dao.convocatoria_facultad import ConvocatoriaFacultad
from control.dao.convocatoria_tipo_subsidio import ConvocatoriaTipoSubsidio
from control.dao.documento_solicitud import DocumentoSolicitud
from control.dao.estado_convocatoria import EstadoConvocatoria
from control.dao.facultad import Facultad
from control.dao.periodo import Periodo
from control.dao.puntaje_tipo_documento import PuntajeTipoDocumento
from control.dao.solicitud import Solicitud
from control.dao.tipo_documento import TipoDocumento
from control.dao.tipo_subsidio import TipoSubsidio
from control.dao.user import User
from flask import (Flask, flash, g, redirect, render_template, request,
                   session, url_for)
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.config.from_object("config.Config")
# max file size 16MB
app.config["MAX_CONTENT_LENGTH"] = 16 * 1024 * 1024

path = os.getcwd()
UPLOAD_FOLDER = os.path.join(path, "static/uploads")
if not os.path.isdir(UPLOAD_FOLDER):
    os.mkdir(UPLOAD_FOLDER)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

ALLOWED_EXTENSIONS = set(["pdf"])


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


@app.before_request
def load_logged_in_user():
    user_id = session.get("user_id")
    if user_id is None:
        g.user = None
    else:
        # TODO: query from db this data
        g.user = {
            "name": "postgres",
            "id_estudiante": "1",
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
        convocatoria_facultad = ConvocatoriaFacultad()
        convocatoria_tipo_subsidio = ConvocatoriaTipoSubsidio()
        isUpdate = (
            True if convocatoria.exist(request.form["id_convocatoria"]) else False
        )

        if isUpdate:
            convocatoria.update(request.form)
            flash("Convocatoria actualizada exitosamente")
        else:
            convocatoria.create(request.form)
            flash("Convocatoria creada exitosamente")

        for field in request.form:
            if field.startswith("facultad"):
                id_facultad = int(field.replace("facultad", ""))
                data = {
                    "id_facultad": id_facultad,
                    "id_convocatoria": request.form["id_convocatoria"],
                    "cantidad_de_almuerzos": request.form[field],
                }
                if isUpdate:
                    convocatoria_facultad.update(data)
                else:
                    convocatoria_facultad.create(data)

        for field in request.form:
            if field.startswith("tipo_subsidio"):
                id_tipo_subsidio = int(field.replace("tipo_subsidio", ""))
                data = {
                    "id_tipo_subsidio": id_tipo_subsidio,
                    "id_convocatoria": request.form["id_convocatoria"],
                    "cantidad_de_almuerzos_ofertados": request.form[field],
                }
                if isUpdate:
                    convocatoria_tipo_subsidio.update(data)
                else:
                    convocatoria_tipo_subsidio.create(data)
        return redirect(url_for("convocatoria_view"))
    else:
        today = date.today()
        periodo = Periodo()
        active_periodo = periodo.get_active_period(
            fecha_actual=today.strftime("%Y-%m-%d")
        )
        if len(active_periodo) == 0:
            flash("No hay periodos activos.")
            return redirect(url_for("home"))

        tipos_subsidio = TipoSubsidio().get_all()
        facultades = Facultad().get_all()
        estados_convoc = EstadoConvocatoria().get_all()
        data = {
            "periodo": active_periodo,
            "tipos_subsidio": tipos_subsidio,
            "facultades": facultades,
            "estados_convocatoria": estados_convoc,
        }

        if id_convocatoria is not None:
            data["id_convocatoria"] = id_convocatoria
            if convocatoria.exist(id_convocatoria):
                ans0 = convocatoria.get(id_convocatoria=id_convocatoria)[0]
                data["fecha_inicio"] = ans0[0]
                data["fecha_fin"] = ans0[1]
                data["id_periodo"] = ans0[2]
                data["id_estado_convocatoria"] = ans0[3]
                ans1 = ConvocatoriaFacultad().get(id_convocatoria=id_convocatoria)
                for id_fac, num in ans1:
                    data["facultad{}".format(id_fac)] = num
                ans2 = ConvocatoriaTipoSubsidio().get(id_convocatoria=id_convocatoria)
                for id_tipo_sub, num in ans2:
                    data["tipo_subsidio{}".format(id_tipo_sub)] = num
        else:
            data["id_convocatoria"] = convocatoria.get_next_id()

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


@app.route("/solicitud", methods=["GET", "POST"])
@login_required
def solicitud():
    if request.method == "POST":
        documento_s = DocumentoSolicitud()
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
                documento_s.create(data)
        flash("Archivos exitosamente guardados")
        return redirect(url_for("home"))

    convocatoria = Convocatoria()
    today = date.today()
    id_convocatoria = convocatoria.get_active_current(
        fecha_actual=today.strftime("%Y-%m-%d")
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


@app.route("/revisar_solicitud", methods=["GET", "POST"])
@app.route("/revisar_solicitud/<id_solicitud>", methods=["GET", "POST"])
@login_required
def revisar_solicitud(id_solicitud=None):
    if request.method == "POST":
        tipos_documento = TipoDocumento().get_all()
        documento_solicitud = DocumentoSolicitud()
        for idt, _, nombre_tipo in tipos_documento:
            if "revisado{}".format(idt) in request.form:
                data = {
                    "comentarios": request.form["comentario{}".format(idt)],
                    "id_solicitud": request.form["id_solicitud"],
                    "id_tipo_documento": idt,
                    "revisado": 1 if "revisado{}".format(idt) in request.form else 0,
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
        return render_template(
            "revisar-solicitud.html",
            documentos_solicitud=documentos_solicitud,
            puntajes=puntajes,
            id_solicitud=id_solicitud,
        )
    solicitudes = Solicitud().get_all()
    return render_template("listar-solicitudes.html", solicitudes=solicitudes)


if __name__ == "__main__":
    app.run()
