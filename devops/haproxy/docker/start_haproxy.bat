docker stop haproxy
docker rm haproxy

REM <local haproxy config directory> must be replaced with a full path to a directory on the local developer's machine
REM containing files haproxy.cfg and haproxy.pem
REM for example, /c/Users/username/haproxy
REM /c is a valid Windows path that Docker understands as C:\
docker run -d -p 80:80 -p 443:443 -p 9000:9000 --name haproxy --restart=always -v <local haproxy config directory>:/usr/local/etc/haproxy:ro haproxy:1.9.8

docker logs -f haproxy
