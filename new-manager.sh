#!/bin/bash
# Args from the command line
ARG1=$1
#wc $ARG1

# NET related vars
NET_NAME=mysql-db-net
SUBNET_MASK=172.18.0.0/16
DEB_IP=172.18.0.3
MYSQL_IP=172.18.0.2

# MySQL vars
MYSQL_CONTAINER=mysql-db

#Debian+JDK8+MVN+GIT+CDB vars
DEB_CONTAINER=jdk8-mvn-cdb
#MVN_REPO=/home/excilys/.m2/repository:/root/.m2/repository
MVN_REPO=/home/kranium632/.m2/repository:/root/.m2/repository

function build {
    DOCKER_TARGET=$1
    cd $DOCKER_TARGET && docker build -t $DOCKER_TARGET .
}


function build-no-cache {
    DOCKER_TARGET=$1
    cd $DOCKER_TARGET && docker build --no-cache -t $DOCKER_TARGET .
}

function start {
    # Create newtork
    docker network create --subnet=$SUBNET_MASK  $NET_NAME

    # Start container with Debian+JDK8+MVN+GIT+CDB and add it to the network
    docker run -dit -v $MVN_REPO --name $DEB_CONTAINER --net=$NET_NAME --ip=$DEB_IP $DEB_CONTAINER 

    # Launch MySQL container
    docker run --name $MYSQL_CONTAINER -tid $MYSQL_CONTAINER

    # Wait for mysql server to be up
    echo "Waiting 10 seconds for the MySQL server to be up and running..."
    sleep 10
    echo "done!"

    # Start MySQL container
    docker start $MYSQL_CONTAINER

    # Link MYSQL_CONTAINER to the network
    docker network connect --ip=$MYSQL_IP $NET_NAME $MYSQL_CONTAINER
}

function exec {
    docker start $MYSQL_CONTAINER
    docker exec $DEB_CONTAINER /bin/sh -c '/home/git-and-test.sh'
}

function stop {
    # Stop running container
    docker stop $DEB_CONTAINER
    docker stop $MYSQL_CONTAINER

    # Remove docker images
    docker rm $DEB_CONTAINER
    docker rm $MYSQL_CONTAINER

    # Remove network
    docker network rm $NET_NAME
}

function inspect {
    docker network inspect $NET_NAME
}


POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -b|--build)
        build "$2"
        shift # past argument
        shift # past value
        ;;
    -bnc|--build-no-cache)
        build-no-cache "$2"
        shift # past argument
        shift # past value
        ;;
    -s|--start)
        start
        shift # past argument=value
        ;;
    -e|--exec)
        exec
        shift # past argument=value
        ;;
    -k|--kill|--stop)
        stop
        shift # past argument=value
        ;;
    -r|--restart)
        stop
        start
        ;;
    -i|--inspect)
        inspect
        ;;
    *)
        echo $"Usage: $0 {start|exec|stop|kill|restart|inspect|build|build-no-cache}"
        exit 1
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters
