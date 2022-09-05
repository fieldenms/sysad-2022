#!/usr/bin/env bash
#
# Copy the specified script into a Docker PostgreSQL container and run it against the optionally specified database.
# If a database is not specified, then apply the script to database tg_local, which is created when the container starts.

if [ "$#" -eq 1 ]; then
    # No database was specified - use the default database in the container.
    DATABASE=tg_local
    SCRIPT_PATH=$1
else
    if [ "$#" -eq 2 ]; then
        DATABASE=$1
        SCRIPT_PATH=$2
    else
        echo $0: please specify database and script filename, or just script filename
        exit
    fi
fi

if [ ! -f $SCRIPT_PATH ]; then
    echo $0: specified SQL script not found
    exit
fi

SCRIPT_FILE=`basename $SCRIPT_PATH`

docker cp $SCRIPT_PATH postgresql:/tmp

# psql -h localhost       specifies the PostgreSQL server, in this case localhost as it is in the same container where the tools are
#      -U t32             the user to connect as
#      -a                 echo the script as it is executed
#      -f filename        read the script from the specified file (must have been copied into the container)
#
# You can optionally include `-o logfile` to write script output to the specified file (also inside the container),
# but will need to copy the log file out of the container to the Docker host to process it further.

docker exec -ti postgresql psql -h localhost -U t32 $DATABASE -a -f /tmp/$SCRIPT_FILE

