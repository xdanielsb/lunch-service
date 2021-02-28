import os

import cx_Oracle
import psycopg2
import psycopg2.extras
from flask import g


def get_db(username=None, password=None):
    """Opens a new database connection if there is none yet for the
    current application context.
    """
    err = None
    try:
        if not hasattr(g, "dbconn"):
            #src = os.environ.get("DB_SOURCE")
            src = "ORACLE"
            if src is None or src == "POSTGRES":
                g.dbconn = psycopg2.connect(
                    host="localhost",
                    database="apoyo_alimentario",
                    user=username if (username is not None) else g.user["username"],
                    password=password if (password is not None) else g.user["password"],
                )
            if src == "ORACLE":
                g.dbconn = cx_Oracle.connect(
                    username if (username is not None) else g.user["username"],
                    password if (password is not None) else g.user["password"],
                    "localhost/xe",
                    #"52.206.143.56/xe",
                )
    except Exception as ex:
        err = str(ex)
        print(err)
    return err


def adapt_db(func):
    def inner(q):
        #src = os.environ.get("DB_SOURCE")
        src = "ORACLE"
        if src == "ORACLE":
            q = q.replace(" as ", " ")
        return func(q)

    return inner


@adapt_db
def query(query):
    if not hasattr(g, "dbconn"):
        get_db()
    conn = g.dbconn
    #cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur = conn.cursor()
    cur.execute(query)
    ans = [row for row in cur]
    cur.close()
    return ans


@adapt_db
def execute(statement):
    if not hasattr(g, "dbconn"):
        get_db()
    conn = g.dbconn
    cur = conn.cursor()
    cur.execute(statement)
    conn.commit()
    cur.close()


if __name__ == "__main__":
    conn = psycopg2.connect(
        host="localhost", database="apoyo_alimentario", user="", password=""
    )
