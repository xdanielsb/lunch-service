import psycopg2
from flask import request
from flask import Flask, render_template
from control.dao.user import User
import os
import json

app = Flask(__name__)
# app.config.from_object("config")


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

@app.route("/login",methods = ['POST', 'GET'])
def login():
    if request.method == "POST":
        if(userDao.exist(request.form['username'], request.form['password']):
            return render_template('home.html')
    return render_template('login.html')


if __name__ == "__main__":
    app.run()
