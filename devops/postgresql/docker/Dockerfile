FROM postgres:14.2
EXPOSE 5432
RUN mkdir -p /docker-entrypoint-initdb.d
COPY 01_init.sh /docker-entrypoint-initdb.d
COPY 02_cis.sh /docker-entrypoint-initdb.d
COPY create_insert_statement.sql /

