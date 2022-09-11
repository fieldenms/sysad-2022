### Database maintenance

#### Creating a user

`createuser -S -d -R -l -P -h <host> -U postgres -W <username>`

Parameter | Description
--------- | -----------
-S        | user will not be a superuser (default)
-d        | user will be allowed to create databasi
-R        | user will not be allowed to create roles
-l        | user will be allowed to login
-P        | prompt for a password for the new user
-h x      | database host
-U x      | name of user to connect as (must be able to create new users)
-W        | force password prompt for the -U user
username  | name of the new user

In the case of the first four parameters, the lowercase version will allow the permission (e.g. -d = user can create databases) whereas the uppercase version will disallow it (e.g. -D = user can not create databases).

For example, to create user `t32`:
   * in a local Docker container: `docker exec -ti postgresql createuser -S -d -R -l -P -h localhost -U postgres -W t32`
   * on `db-psql` in Azure: `createuser -S -d -R -l -P -h db-psql -U postgres -W t32`

#### Creating a database

`createdb -O <owner> -h <host> -U <user> --encoding UTF8 <database>`

For example, to create database `tg_dev` owned by `t32` as user `t32`:
   * in a local Docker container: `docker exec -ti postgresql createdb -h localhost -U t32 -O t32 tg_dev`

No output is expected from this command.

#### Listing all databases on a server

`psql -h <host> -U <user> -l`

For example, to list all databases connecting as user `t32`:
   * in a local Docker container: `docker exec -ti postgresql psql -h localhost -U t32 -l`

Sample output from this command:

```
                              List of databases
    Name    |  Owner   | Encoding | Collate |  Ctype  |   Access privileges
------------+----------+----------+---------+---------+-----------------------
 postgres   | postgres | UTF8     | C.UTF-8 | C.UTF-8 |
 template0  | postgres | UTF8     | C.UTF-8 | C.UTF-8 | =c/postgres          +
            |          |          |         |         | postgres=CTc/postgres
 template1  | postgres | UTF8     | C.UTF-8 | C.UTF-8 | =c/postgres          +
            |          |          |         |         | postgres=CTc/postgres
 tg_prod | t32      | UTF8     | C.UTF-8 | C.UTF-8 |
 tg_test | t32      | UTF8     | C.UTF-8 | C.UTF-8 |
(5 rows)
```

##### Listing all databases and their sizes

Connect to the server with the `psql` command line tool or a GUI application (these examples connect to the default database, but any database will suffice), for example:
   * in a local Docker container: `docker exec -ti postgresql psql -h localhost -U t32 postgres`

Execute the following query:

```
SELECT d.datname AS Name, pg_catalog.pg_get_userbyid(d.datdba) AS Owner,
    CASE WHEN pg_catalog.has_database_privilege(d.datname, 'CONNECT')
        THEN pg_catalog.pg_size_pretty(pg_catalog.pg_database_size(d.datname))
        ELSE 'No Access'
    END AS Size
FROM pg_catalog.pg_database d
    ORDER BY
    CASE WHEN pg_catalog.has_database_privilege(d.datname, 'CONNECT')
        THEN pg_catalog.pg_database_size(d.datname)
        ELSE NULL
    END DESC;
```

Sample output from this command:

```
    name    |  owner   |  size
------------+----------+---------
 tg_prod | t32      | 589 MB
 tg_test | t32      | 566 MB
 postgres   | postgres | 7953 kB
 template1  | postgres | 7953 kB
 template0  | postgres | 7809 kB
(5 rows)
```

#### Deleting a database

_Note that you cannot delete a database if it has active connections._

`dropdb -h <host> -U t32 <database>`

For example, to delete a database called `tspga_dev` connecting as user `t32`:
   * in a local Docker container: `docker exec -ti postgresql dropdb -h localhost -U t32 tg_dev`

No output is expected from this command.

#### Backup a database

`pg_dump -h <host> -U <user> -F c -f <filename> <database>`

Option `-F c` sets a custom backup format, and option `-f filename` specifies the output filename.

For example, to create a backup of database `tg_dev` connecting as user `t32`:
   * in a local Docker container: `docker exec -ti postgresql pg_dump -h localhost -U t32 -F c -f /tg_dev.pgd tg_dev`
     then copy the backup file out of the container: `docker cp postgresql:/tg_dev.pgd .`

No output is expected from this command.

#### Restore a database

`pg_restore -h <host> -U <user> -d <database> <filename>`

For example, to restore backup `tg_dev.pgd` into database `tg_test` as user `t32` (note that the database must already exist and should preferably be empty):
   * in a local Docker container:
     copy the backup file into the container: `docker cp tg_dev.pgd postgresql:/`
     then restore it: `docker exec -ti postgresql pg_restore -h localhost -U t32 -d tg_test /tg_dev.pgd`

No output is expected from this command, although in older versions of PostgreSQL is is not uncommon to receive warnings about being unable to overwrite certain system elements.

#### Running SQL queries

Connect to the database with the `psql` command line tool, for example:
   * in a local Docker container: `docker exec -ti postgresql psql -h localhost -U t32 tg_test`

   * `-h db_psql` - specifies the PostgreSQL server to connect to
   * `-U t32` - specifies the user to connect as
   * `tg_test` - specifies the database to connect to

Interactively type SQL commands and finish each line with a semi-colon.

Use `\d` when connected to produce a list of tables.

Use `\q` to quit from psql.

Use `\?` to list other internal commands.

If you have an SQL script to apply, you can do so from the command line and save the output in a log file, for example:

`psql -h db-psql -U t32 tg_test -f sql_script.sql -o sql_script.log`

   * `-h db_psql` - specifies the PostgreSQL server to connect to
   * `-U t32` - specifies the user to connect as
   * `tg_test` - specifies the database to connect to
   * `-f sql_script.sql` - the input SQL script
   * `-o sql_script.log` - the file to write output to

No output is expected from this command (it is all written to the specified output file).

#### Renaming a database

_Note that you cannot rename a database if it has active connections._

Connect to the server with the `psql` command line tool or a GUI application (these examples connect to the default database `postgres` as you cannot rename the database to, which you are connected), for example:
   * in a local Docker container: `docker exec -ti postgresql psql -h localhost -U t32 postgres`

Run command (substituting source and target database names): `alter database source_database rename to target_database;`

Sample output from this command:

```
postgres=> alter database tg_user rename to tg_user2;
ALTER DATABASE
```
