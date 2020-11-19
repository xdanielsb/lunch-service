from flask import request
from flask import Flask, render_template, flash, redirect, url_for, session, g
from control.dao.user import User
import functools
import os
import json
from control.connection import Connection

app = Flask(__name__)
app.config.from_object("config.Config")

conn = Connection()
userDao = User(conn)


@app.before_request
def load_logged_in_user():
    user_id = session.get("user_id")
    if user_id is None:
        g.user = None
    else:
        # TODO: query from db this data
        g.user = {"name": "Matilda Harris", "rol": "Estudiante"}


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


@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))


if __name__ == "__main__":
    app.run()
