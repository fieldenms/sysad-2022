echo stopping...
docker stop sendria
echo removing...
docker rm sendria

docker run -d -p 25:1025 -p 1080:1080 --restart=always --name sendria msztolcman/sendria:v2.2.2.0

docker logs -f sendria

