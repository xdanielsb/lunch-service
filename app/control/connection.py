import psycopg2
from flask import g


def get_db():
    """Opens a new database connection if there is none yet for the
    current application context.
    """
    if not hasattr(g, "dbconn"):
        g.dbconn = psycopg2.connect(
            host="localhost",
            database="apoyo_alimentario",
            user="postgres" if g.user is None else g.user["name"],
            password="" if g.user is None else g.user["password"],
        )
    return g.dbconn


def query(query):
    cur = get_db().cursor()
    cur.execute(query)
    ans = [row for row in cur]
    cur.close()
    return ans


def execute(statement):
    cur = get_db().cursor()
    cur.execute(statement)
    cur.close()
