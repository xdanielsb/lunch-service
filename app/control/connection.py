import psycopg2


class Connection:
    def __init__(self, username="postgres", password=""):
        self.conn = psycopg2.connect(
            host="localhost", database="apoyo_alimentario", user=username, password=password
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
