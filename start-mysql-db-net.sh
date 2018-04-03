NET_NAME=mysql-db-net
MYSQL_CONTAINER=mysql-db

docker network create --subnet=172.18.0.0/16  $NET_NAME
