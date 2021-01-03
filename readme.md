A simple prototype application to manage the logic behind restaurant tickets in a public university in Colombia, this use the security features of a database, then there are many features which are not included. This prototype will include:

- application process
- restaurant tickets
- review of applications

***It is worth to say it is just a prototype and it is develop for academic purposes for the subject databases, then the backend contains "many" problems.***

### Instructions

#### Database
```sh
  $ cd schema
  $ sh utils/init.sh
  apoyo_alimentario=# \i database.sql
  apoyo_alimentario=# \i populate.sql
  apoyo_alimentario=# \i roles.sql
  apoyo_alimentario=# \i grants.sql
  apoyo_alimentario=# \q
```

#### App
```sh
 $ cd app/
 $ python3 -m venv env-lunch/
 $ source env-lunch/bin/activate
 (env-lunch)$ pip3 install -r requirements.txt
 (env-lunch)$ flask run # export FLASK_APP=app
```

#### Testing
```sh
 $ cd app/
 $ python3 -m pytest tests
```
