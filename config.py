import os


class Config(object):
    DEBUG = False
    TESTING = False
    CSRF_ENABLED = True
    SECRET_KEY = "this-really-needs-to-be-changed"
    # max file size 16MB
    MAX_CONTENT_LENGTH = 16 * 1024 * 1024
    MAIL_SERVER = "smtp.gmail.com"
    MAIL_PORT = 465
    MAIL_USERNAME = os.environ.get("MAIL_USERNAME")
    MAIL_PASSWORD = os.environ.get("MAIL_PASSWORD")
    MAIL_USE_TLS = False
    MAIL_USE_SSL = True
