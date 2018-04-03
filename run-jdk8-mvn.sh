CONTAINER_NAME=jdk8-mvn
NET_NAME=mysql-db-net
# docker run -d --name $CONTAINER_NAME --net=$NET_NAME $CONTAINER_NAME
docker run -it -v /home/excilys/.m2/repository:/root/.m2/repository --name $CONTAINER_NAME --net=$NET_NAME $CONTAINER_NAME 

