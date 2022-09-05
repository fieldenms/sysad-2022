#!/usr/bin/env bash
#
# List PostgreSQL databases in a running container.
#
# psql -h localhost       specifies the PostgreSQL server, in this case localhost as it is in the same container there the tools are
#      -U t32             the user to connect as
#      -l                 list databases
# An option to specify the password is not included (for security reasons), and will use the `.pgpass` file if available,
# otherwise it will prompt for the password as required.

docker exec -ti postgresql psql -h localhost -U t32 -l


