#!/usr/bin/env bash
#
# Restore a PostgreSQL database into a running Docker container.
#
# Note that as the PostgreSQL commands are executed within the container, the backup file must also exist within the container.
# This script copies the backup file into the container before performing the restore.
#
# Usage: restore.sh backup_filename database_name
#
# The backup file will be copied into the container so PostgreSQL commands can access it.
# The specified database will be dropped and (re-)created prior to the restore.

if [ "$#" -ne 2 ]; then
    echo $0: usage: $0 backup_filename database_name
    exit
fi

if [ ! -f $1 ]; then
    echo $0: specified backup file not found
    exit
fi

BACKUP_PATH=$1
BACKUP_FILE=`basename $1`
DATABASE=$2

set -e

echo Deleting database ...
docker exec -ti postgresql dropdb -h localhost -U postgres $DATABASE

echo Creating database ...
docker exec -ti postgresql createdb -h localhost -U postgres -O t32 $DATABASE

echo Copying backup file into container ...
docker cp "$BACKUP_PATH" postgresql:/tmp

echo Restoring ...
#docker exec -ti postgresql pg_restore -h localhost -U t32 -d $DATABASE "/tmp/$BACKUP_FILE"
docker exec -ti postgresql pg_restore -h localhost -U t32 -d $DATABASE "/tmp/$BACKUP_FILE"

echo Removing backup file ...
docker exec -ti postgresql rm -f "/tmp/$BACKUP_FILE"

echo All done.

