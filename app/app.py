"""
    Copyright (C) 2021  Daniel Santos
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>
"""

import functools
import os
from datetime import date

import pdfkit
import psycopg2
from flask import (flash, g, make_response, redirect, render_template, request,
                   session, url_for)
from werkzeug.utils import secure_filename

from . import app
from .control import (ActividadBeneficiario, Beneficiario, Convocatoria,
                      ConvocatoriaFacultad, ConvocatoriaTipoSubsidio,
                      DocumentoSolicitud, EstadoDocumento, EstadoSolicitud,
                      Estudiante, Facultad, Funcionario, HistoricoSolicitud,
                      Periodo, PuntajeTipoDocumento, Solicitud, Ticket,
                      TipoDocumento, TipoSubsidio, User, generate_qr_image,
                      get_db)


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
        convocatoria = Convocatoria().get_current_active(
            fecha_actual=date.today().strftime("%Y-%m-%d")
        )
        if convocatoria is not None:
            g.user["current_convocatoria"] = convocatoria["id_convocatoria"]
            g.user["current_periodo"] = convocatoria["id_periodo"]

        if g.user["rol"].startswith("e"):
            g.user.update(Estudiante().get(g.user["rol"][1:]))
            if convocatoria is not None:
                solicitud = Solicitud().get_current(
                    data={
                        "id_convocatoria": convocatoria["id_convocatoria"],
                        "id_estudiante": g.user["id_estudiante"],
                    }
                )
                if solicitud is not None:
                    g.user["current_solicitud"] = solicitud["id_solicitud"]
                    beneficiario = Beneficiario().get(solicitud["id_solicitud"])
                    if beneficiario is not None:
                        g.user["current_beneficiario"] = beneficiario["id_beneficiario"]

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
            "username": "creadorusuarios",
            "password": "cpass",
            "rol": "creadorusuarios",
        }
        ans = Estudiante().get_by_email(email)
        if len(ans) == 0:
            flash("Estudiante no existe en la base de datos.")
        elif User().create(ans, send_message=True):
            flash(
                "Hemos enviado a tu correo institucional las credenciales de accesso."
            )
    return render_template("create-user.html")


@app.route("/", methods=["POST", "GET"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        error = get_db(username, password)
        if error is None:
            session.clear()
            session["username"] = username
            session["password"] = password
            return redirect(url_for("home"))
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
        isUpdate = convocatoria.exist(request.form["id_convocatoria"])

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

        if (
            convocatoria.lunch_facs_equal_lunch_types(request.form["id_convocatoria"])
            is False
        ):
            flash(
                "La suma de almuerzos asignados por facultad no es el misma que los asignados por tipo",
                "danger",
            )
            return redirect(
                url_for("convocatoria", id_convocatoria=request.form["id_convocatoria"])
            )

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
            "estrato": request.form["estrato"],
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

    convocatoria = Convocatoria().get_current_active(
        fecha_actual=date.today().strftime("%Y-%m-%d")
    )
    if convocatoria is None:
        flash("No hay convocatoria activa.")
        return redirect(url_for("home"))

    solicitud = Solicitud().get_current(
        data={
            "id_convocatoria": convocatoria["id_convocatoria"],
            "id_estudiante": g.user["id_estudiante"],
        }
    )
    if solicitud is not None:
        flash("Ya tienes una solicitud activa.")
        return redirect(url_for("consultar_solicitud"))

    tipos_documento = TipoDocumento().get_all()
    return render_template(
        "solicitud.html",
        convocatoria=convocatoria,
        tipos_documento=tipos_documento,
    )


@login_required
@app.route("/consultar_solicitud")
def consultar_solicitud():
    if g.user.get("current_solicitud") is not None:
        return redirect(
            url_for("revisar_solicitud", id_solicitud=g.user["current_solicitud"])
        )
    flash("Su usuario no tiene solicitudes creadas")
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
            historico=HistoricoSolicitud().get(id_solicitud),
            id_estado_solicitud=Solicitud().get_estado(id_solicitud),
        )
    return render_template("listar-solicitudes.html", solicitudes=Solicitud().get_all())


@app.route("/beneficiarios/<id_convocatoria>", methods=["POST", "GET"])
@login_required
def consultar_beneficiarios(id_convocatoria=None):
    res = Convocatoria().get_results(id_convocatoria)
    try:
        html = render_template("res_beneficiarios.html", res=res)
        pdf = pdfkit.from_string(html, False)
        response = make_response(pdf)
        response.headers["Content-Type"] = "application/pdf"
        response.headers[
            "Content-Disposition"
        ] = "inline; filename=res_convocatoria{}.pdf".format(id_convocatoria)
        return response
    except OSError:
        return {"results": res}


@app.route("/puntaje/<id_convocatoria>", methods=["POST", "GET"])
@login_required
def computar_puntajes(id_convocatoria=None):
    Convocatoria().compute_results(id_convocatoria)
    flash("Los puntajes han sido calculados")
    return redirect(url_for("convocatoria_view"))


@app.route("/generar_beneficiarios/<id_convocatoria>", methods=["POST", "GET"])
@login_required
def generar_beneficiarios(id_convocatoria=None):
    # Convocatoria().compute_results(id_convocatoria)
    # flash("Los puntajes han sido calculados")
    Convocatoria().generar_beneficiarios(id_convocatoria)
    flash("Los beneficiarios han sido generados.")
    Convocatoria().asignar_tickets(id_convocatoria)
    flash("Se han asignado los tickets de almuerzo y refrigerio.")
    return redirect(url_for("convocatoria_view"))


@app.errorhandler(psycopg2.Error)
def handle_exception(e):
    """Return JSON instead of HTML for HTTP errors."""
    response = {
        "code": e.pgcode,
        "error": e.pgerror,
    }
    return response


@app.route("/tickets")
@login_required
def mis_tickets():
    ctx = {}
    if g.user.get("current_beneficiario") is not None:
        id_beneficiario = g.user.get("current_beneficiario")
        actividades = ActividadBeneficiario().get(id_beneficiario)
        t_almuerzo = Ticket().get_ticket_almuerzo(g.user.get("current_beneficiario"))
        t_refrigerio = Ticket().get_ticket_refrigerio(
            g.user.get("current_beneficiario")
        )
        ctx["talmuerzo"] = t_almuerzo
        ctx["trefrigerio"] = t_refrigerio
        ctx["qr_talmuerzo"] = generate_qr_image(
            t_almuerzo["id_ticket"], id_beneficiario
        )
        ctx["qr_refrigerio"] = generate_qr_image(
            t_refrigerio["id_ticket"], id_beneficiario
        )
        return render_template("tickets.html", actividades=actividades, ctx=ctx)
    flash("No tienes asignado un beneficiario")
    return render_template("tickets.html", ctx=ctx)


if __name__ == "__main__":
    app.run(host="0.0.0.0", threaded=True)
