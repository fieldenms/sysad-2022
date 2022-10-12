#!/usr/bin/env bash

echo -n "stopping ... "
docker stop haproxy
echo -n "removing ... "
docker rm haproxy

# <local haproxy config directory> must be repaced with a full path to a directory on the local developer's machine
# containing files haproxy.cfg and haproxy.pem
# for example, /home/username/haproxy
docker run -d \
           -p 80:80 -p 443:443 -p 9000:9000 \
           --add-host host.docker.internal:host-gateway \
           --restart=always \
           --name haproxy \
           -v <local haproxy config directory>:/usr/local/etc/haproxy:ro \
           haproxy:1.9.8
sleep 2

echo "------------------------------------------------------------------------------"

docker logs -f haproxy


