import psycopg2
from flask import Flask
from dao.user import User
from dao.periodo import Periodo
from dao.convocatoria import Convocatoria
import os
import json

app = Flask(__name__)
app.config.from_object("config")


class Connection:
    def __init__(self):
        self.conn = psycopg2.connect(
            host="localhost", database="apoyo_alimentario", user="postgres", password=""
        )

    def query(self, query):
        cur = self.conn.cursor()
        cur.execute(query)
        ans = cur.fetchone()
        cur.close()
        return ans

    def execute(self, statement):
        cur = self.conn.cursor()
        cur.execute(query)
        cur.close()


conn = Connection()

userDao = User(conn)
periodoDao = Periodo(conn)
convocatoriaDao = Convocatoria(conn)


@app.route("/login/<username>/<password>")
def valid_user(username, password):
    return userDao.exist(username, password)


@app.route("/periodo")
def get_periodos():
    return json.dumps(periodoDao.get_all())


@app.route("/periodo/new/<fecha_inicio>/<fecha_fin>")
def create_periodo(fecha_inicio, fecha_fin):
    print(fecha_inicio, fecha_fin)
    return ""


if __name__ == "__main__":
    app.run()
