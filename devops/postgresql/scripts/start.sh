#!/usr/bin/env bash

[ -n "$(docker ps -f name=postgresql -q)" ] &&
{
    echo -n "stopping ... "
    docker stop postgresql
    echo -n "removing ... "
    docker rm postgresql
}

docker run -d --name postgresql --restart=always -e POSTGRES_PASSWORD=Passw0rd -p 127.0.0.1:5432:5432 fieldentech/postgresql:14

docker logs -f postgresql

