import psycopg2
from psycopg2 import OperationalError
from flask import g


def get_db(username=None, password=None):
    """Opens a new database connection if there is none yet for the
    current application context.
    """
    try:
        if not hasattr(g, "dbconn"):
            g.dbconn = psycopg2.connect(
                host="localhost",
                database="apoyo_alimentario",
                user=username if (username is not None) else g.user["username"],
                password=password if (password is not None) else g.user["password"],
            )
        return g.dbconn
    except OperationalError as err:
        print(err)
        return None
    return None


def query(query):
    conn = get_db()
    cur = conn.cursor()
    cur.execute(query)
    ans = [row for row in cur]
    cur.close()
    return ans


def execute(statement):
    conn = get_db()
    cur = conn.cursor()
    cur.execute(statement)
    conn.commit()
    cur.close()
