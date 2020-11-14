from flask import Flask
from dao.user import User
import psycopg2
import os


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

    def valid_user(self, username, password):
        q = "select count(*) from usuario as u, estudiante as e where u.id_usuario = e.id_usuario and e.identificacion = '{}' and u.password = '{}'".format(
            username, password
        )
        return {"res": len(self.query(q))}


con = Connection()


@app.route("/login/<username>/<password>")
def valid_user(username, password):
    return con.valid_user(username, password)


if __name__ == "__main__":
    app.run()
