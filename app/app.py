from flask import request
from flask import Flask, render_template
from control.dao.user import User
import os
import json
from control.connection import Connection

app = Flask(__name__)
app.config.from_object("config.Config")

conn = Connection()
userDao = User(conn)

@app.route("/",methods = ['POST', 'GET'])
def login():
    if request.method == "POST":
        if(userDao.exist(request.form['username'], request.form['password'])):
            return render_template('home.html')
    return render_template('login.html')


if __name__ == "__main__":
    app.run()
