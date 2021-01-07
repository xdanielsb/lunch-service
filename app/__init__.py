import os

from flask import Flask
from flask_mail import Mail

app = Flask(__name__)
app.config.from_object("config.Config")
path = os.getcwd()
UPLOAD_FOLDER = os.path.join(path, "static/uploads")
if not os.path.isdir(UPLOAD_FOLDER):
    os.mkdir(UPLOAD_FOLDER)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
mail = Mail(app)
