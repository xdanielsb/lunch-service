import os


def adapt_db(func):
    def inner(q):
        src = os.environ.get("DB_SOURCE")
        if src == "ORACLE":
            q = q.replace(" as ", " ")
        return func(q)

    return inner


@adapt_db
def query(q):
    # execute the query changed
    return q


def test_select():
    q = "select * from table as t"
    expected = "select * from table t"
    ans = query(q)
    if os.environ.get("DB_SOURCE") == "ORACLE":
        assert ans == expected
    else:
        assert ans == q


test_select()
