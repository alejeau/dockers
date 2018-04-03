NET_NAME=mysql-db-net
MYSQL_CONTAINER=mysql-db
CDB_CONTAINERE=jdk8-mvn-cdb

docker network create $NET_NAME
# docker run -ti -d --name $MYSQL_CONTAINER --net=$NET_NAME $MYSQL_CONTAINER
# docker run -ti -d --name $CDB_CONTAINER --net=$NET_NAME $CDB_CONTAINER


