# The base setup
This example shows how to get a postgres instance running online fast ;)

### How to run:
```
docker-compose up
```
Shut down:
```
CTRL-C 
# or
docker-compose down
```
Cleanup:
```
docker-compose rm
```

### How to play with the DB
There are some commands in 'commands.sql' that help you explore the DB.

### Used principles
The DB will be initialised in the 'init.sql' file.

### Idea connection config 
If you are Intellij Idea you can import this with CTRL+C and then in the Database Tab select '+' and then 'Import from Clipboard".
```
#DataSourceSettings#
#LocalDataSource: db
#BEGIN#
<data-source source="LOCAL" name="db" uuid="b431ebd8-6953-4566-8668-1e25b7ffc220"><database-info product="PostgreSQL" version="12.3" jdbc-version="4.2" driver-name="PostgreSQL JDBC Driver" driver-version="42.2.5" dbms="POSTGRES" exact-version="12.3" exact-driver-version="42.2"><identifier-quote-string>&quot;</identifier-quote-string></database-info><case-sensitivity plain-identifiers="lower" quoted-identifiers="exact"/><driver-ref>postgresql</driver-ref><synchronize>true</synchronize><jdbc-driver>org.postgresql.Driver</jdbc-driver><jdbc-url>jdbc:postgresql://localhost:5432/db</jdbc-url><secret-storage>master_key</secret-storage><user-name>db</user-name><schema-mapping><introspection-scope><node kind="database" qname="@"><node kind="schema" qname="@"/></node></introspection-scope></schema-mapping></data-source>
#END#
```
