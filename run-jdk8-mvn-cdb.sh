CONTAINER_NAME=jdk8-mvn-cdb
NET_NAME=mysql-db-net
MVN_REPO=/home/excilys/.m2/repository:/root/.m2/repository
IP=172.18.0.3
# docker run -d --name $CONTAINER_NAME --net=$NET_NAME $CONTAINER_NAME
docker run -dit -v $MVN_REPO --name $CONTAINER_NAME --net=$NET_NAME --ip=$IP $CONTAINER_NAME 

