FROM postgres:14.2
EXPOSE 5432

RUN mkdir /opt 2>/dev/null || echo "/opt exists"
COPY dos2unix /opt/dos2unix
RUN chmod a+x /opt/dos2unix

RUN mkdir -p /docker-entrypoint-initdb.d

COPY 01_init.sh /docker-entrypoint-initdb.d
RUN /opt/dos2unix /docker-entrypoint-initdb.d/01_init.sh

COPY 02_cis.sh /docker-entrypoint-initdb.d
RUN /opt/dos2unix /docker-entrypoint-initdb.d/02_cis.sh

COPY create_insert_statement.sql /
RUN /opt/dos2unix /create_insert_statement.sql
