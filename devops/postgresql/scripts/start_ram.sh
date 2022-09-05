#!/usr/bin/env bash

echo -n "stopping ... "
docker stop postgresql
echo -n "removing ... "
docker rm postgresql

docker run -d \
    --name postgresql \
    --restart=always \
    -e POSTGRES_PASSWORD=Passw0rd \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    -v /Volumes/RAMDisk4:/var/lib/postgresql/data \
    -p 5432:5432 \
    fieldentech/postgresql:14

docker logs -f postgresql

