docker-machine start default
docker stop postgresql
docker rm postgresql

docker run -d --name postgresql --restart=always -e POSTGRES_PASSWORD=Passw0rd -p 127.0.0.1:5432:5432 fieldentech/postgresql:14

timeout 2
echo "------------------------------------------------------------------------------"

docker logs -f postgresql

