#!/usr/bin/env bash

set -e

# Note: User t32 can create additional databases (createdb permission).

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    create user t32 with createdb login password 't32';
    create database tg_local;
    grant all privileges on database tg_local to t32;
    create user junit with login password 'junit';
    create database test_db_1;
    grant all privileges on database test_db_1 to junit;
    create database test_db_2;
    grant all privileges on database test_db_2 to junit;
EOSQL

