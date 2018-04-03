CONTAINER_NAME=mysql-db
NET_NAME=mysql-db-net
IP=172.18.0.2
docker run --name $CONTAINER_NAME -tid $CONTAINER_NAME
docker start $CONTAINER_NAME

