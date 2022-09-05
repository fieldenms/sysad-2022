#!/usr/bin/env bash
# Does not require that PostgreSQL (client) is installed locally i.e. psql command does not need to be available on the host.
docker exec -ti postgresql psql -h localhost -U t32 tg_local

