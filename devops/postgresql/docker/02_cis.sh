#!/usr/bin/env bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname tg_local -f /create_insert_statement.sql
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname test_db_1 -f /create_insert_statement.sql
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname test_db_2 -f /create_insert_statement.sql
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname test_db_3 -f /create_insert_statement.sql
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname test_db_4 -f /create_insert_statement.sql

