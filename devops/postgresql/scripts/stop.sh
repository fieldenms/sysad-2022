#!/usr/bin/env bash

[ -n "$(docker ps -f name=postgresql -q)" ] &&
{
    echo -n "stopping ... "
    docker stop postgresql
    echo -n "removing ... "
    docker rm postgresql
}
