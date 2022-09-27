#!/usr/bin/env bash

echo -n "stopping ... "
docker stop postgresql
echo -n "removing ... "
docker rm postgresql
