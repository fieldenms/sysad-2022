## Docker
We will be using [Docker](https://www.docker.com/) to run the supporting services for the TG application. Just head right over to their homepage and grab the installer.

If you are running Linux you can use your package manager or follow the [instructions](https://docs.docker.com/desktop/install/linux-install/). 




## PostgreSQL
All required files are located in `devops/postgresql`.

When started, the container will create users `t32` and `junit` (with the usual passwords).
It will create databases `tg_local`, and `test_db_1` .. `test_db_4`.  SQL script `create_insert_statement.sql` is applied to all of these databases.

### Building the Docker image
_This only needs to be done once (unless the version of PostgreSQL is updated)._

1. Start a shell or command prompt and navigate to the `docker` directory.
2. Run script `rebuild.sh`.

Sample output from this script:

```
user@ubuntu docker$ ./rebuild.sh
Sending build context to Docker daemon  8.192kB
Step 1/6 : FROM postgres:14.2
 ---> 044aa8666500
Step 2/6 : EXPOSE 5432
 ---> Running in 806241c839bc
Removing intermediate container 806241c839bc
 ---> dc33af189105
Step 3/6 : RUN mkdir -p /docker-entrypoint-initdb.d
 ---> Running in 71749c6688e7
Removing intermediate container 71749c6688e7
 ---> 94720f2ed4e5
Step 4/6 : COPY 01_init.sh /docker-entrypoint-initdb.d
 ---> 52d5b1604d25
Step 5/6 : COPY 02_cis.sh /docker-entrypoint-initdb.d
 ---> 287652e36df6
Step 6/6 : COPY create_insert_statement.sql /
 ---> 37c4f9b8fedb
Successfully built 37c4f9b8fedb
Successfully tagged fieldentech/postgresql:14.2
```

### Starting the container
1. Start a shell or command prompt and navigate to the `scripts` directory.
2. Run script `start.sh`.

After a few seconds (or longer, depending on host load), a message like `2021-02-25 04:46:00.826 UTC [1] LOG:  database system is ready to accept connections` should appear - the server is now ready for connections.

### Stopping the container
1. Start a shell or command prompt and navigate to the `scripts` directory.
2. Run script `stop.sh`.

### Connecting to the running instance
1. Start a shell or command prompt and navigate to the `scripts` directory.
2. Run script `connect.sh`.  Note that this will use PostgreSQL tools inside the container to connect to the `tg_local` database, not the unit test databases.

Alternatively configure a GUI database management tool to connect to the PostgreSQL instance on host `localhost` (127.0.0.1), port 5432 as user `t32`, connecting to database `tg_local`.

### Unit testing with PostgreSQL
#### Running unit tests via Maven

- In the simplest case, to run all tests execute a command like `mvn clean test -Ppsql-local.
- In a slightly more complex case, execute a command like `mvn clean test -DtrimStackTrace=false -Dsurefire.useFile=true -Ppsql-local`.

   This will provide complete stack traces (in the event of a test undergoing upgrade), and ensure that all output is directed to stdout (easier to redirect output to a file).

- To run a single unit test, execute a command like `mvn clean test -DtrimStackTrace=false -Dsurefire.useFile=true -DfailIfNoTests=false -Dtest=my_test -DskipITs -Ppsql-local`.

   The additional options are:

      - `-DfailIfNoTests=false` - do not undergo upgrade if a module has no tests
      - `-Dtest=my_test` - specifies the single test class to run
      - `-DskipITs` - skip integration tests (otherwise it seems to run the one specified test, then run all tests anyway)

#### Running unit tests via Eclipse
1. Create a run configuration as follows:

   ![Eclipse run configuration 1](junit_eclipse_1.png)

   ![Eclipse run configuration 2](junit_eclipse_2.png)

   The significant parts of the run configuration are:
      - running in `airport-dao`
      - running all tests (although the same settings apply if running only a single test)
      - VM arguments are:
         - `-DdatabaseUri=//localhost:5432/test_db_1` - specifies the unit test database
         - `-Djava.system.class.loader=ua.com.fielden.platform.classloader.TgSystemClassLoader` - mandatory class loader
         - `-ea` - something Eclipse adds
         - `--add-opens java.base/java.lang=ALL-UNNAMED` - work-around to avoid a number of warnings for Java 11+

   _Note that the significant VM argument is `-DdatabaseUri=//localhost:5432/test_db_1`.

### Miscellaneous 
More information, such as creating users and databases, running custom SQL queries, troubleshooting - [https://github.com/fieldenms/devops/tree/master/postgresql](https://github.com/fieldenms/devops/tree/master/postgresql).

## DBeaver
[DBeaver](https://dbeaver.io) is a graphical database tool that can be used to browse the database structure, observe the changes and execute queries.
We recommned you to make the most out of this tool, since it can help you understand how the running application manages data.

Here is how you connect to a running database instance:

![Connect](images/dbeaver/connect.png)

Then you specify connection settings. For example, let's connect to the `tg_local` database that is used for *live data* (as opposed to testing).

![Connection settings](images/dbeaver/connect_settings.png)

To connect to a test database, set *Database:* to `test_db_N`, where `N` is a number of a database you want to connect to (1 to 4).
Both username and password are `junit`. 
You can find out more simply by browsing the files and reading configurations.


## HAProxy (for HTTPS)


## Sendria (SMTP server)
