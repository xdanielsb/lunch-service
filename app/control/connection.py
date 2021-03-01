import app
import os

import cx_Oracle
import psycopg2
import psycopg2.extras
from datetime import date
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
                    host="52.206.143.56",
                    database="apoyo_alimentario",
                    user=username if (username is not None) else g.user["username"],
                    password=password if (password is not None) else g.user["password"],
                )
            if src == "ORACLE":
                g.dbconn = cx_Oracle.connect(
                    username if (username is not None) else g.user["username"],
                    password if (password is not None) else g.user["password"],
                    #"localhost/xe",
                    "52.206.143.56/xe",
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
            if q.count('select nextval')>0:
                if q.count('id_convocatoria')>0:
                    q = "select seq_id_convocatoria.nextval from dual" 
                     
                if q.count('id_solicitud')>0:
                    q = "select seq_id_solicitud.nextval from dual" 
            
            if func.__name__=='query':       
                if q.count('fecha')>0:
                    fechas=['fecha','fecha_abierta','fecha_creacion',
                           'fecha_cerrada','fecha_publicacion_resultados',
                           'fecha_inicio','fecha_fin','fecha_uso']
                    vals=q.split('where')
                    data=str(vals[1]).split('and')
                    queryData=vals[0]+"where"
                    for i in data:
                        res = any(item in i for item in fechas)
                        if res:
                            temp=i.split("\'")
                            if  data[0]==i:
                                dateQuery="TO_DATE ('{}', 'yyyy-mm-dd')".format(temp[1])
                                queryData=queryData+temp[0]+dateQuery
                            else:
                                dateQuery="TO_DATE ('{}', 'yyyy-mm-dd')".format(temp[1])
                                queryData=queryData+" and "+temp[0]+dateQuery
                        else:
                            if  data[0]==i:
                                queryData=queryData+i
                            else:
                                queryData=queryData+" and "+i
                    
                    q=queryData   
                                     
                    
            if func.__name__=='execute':       
                if q.count('fecha')>0:
                    datos=[]
                    vals=q.split('values')
                    vals[1]=vals[1].replace(")","")
                    data=str(vals[1]).split(',')
                    tabla=str(vals[0]).split('(')
                    datos=tabla[0]+" values "
                    for i in data:
                        if i.count('-')>1:
                            i=i.replace("'","") 
                            i="TO_DATE ('{}', 'yyyy-mm-dd')".format(i)
                            datos=datos+","+i
                        else:
                            i=i.replace(",","")  
                            i=i.replace(" ","")  
                            if i.count("(")>0:
                                datos=datos+i
                            else:
                                datos=datos+","+i
    
                    datos=datos+")"
                    q=datos                  
                            
            q = q.replace(" as ", " ")
        return func(q)

    return inner


@adapt_db
def query(query):
    if not hasattr(g, "dbconn"):
        get_db()
    conn = g.dbconn
    src = "ORACLE"
    if src =="ORACLE": 
        cur = conn.cursor()
        cur.execute(query)
        #cur.rowfactory = makeDictFactory(cur)
        
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute(query)
    ans = [row for row in cur]
    cur.close()
    #print(type(ans))
    #print(ans)
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

def makeDictFactory(cursor):
    columnNames = [d[0] for d in cursor.description]
    def createRow(*args):
        listOfDict=[]  
        for i in range(len(listOfDict)):
            listOfDict.append(columnNames[i], args[i])    
    return createRow

if __name__ == "__main__":
    conn = psycopg2.connect(
        host="52.206.143.56", database="apoyo_alimentario", user="", password=""
    )
