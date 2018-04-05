#!/bin/bash

# file: new-manager
# new-manager.sh parameter-completion

_new-manager ()   #  By convention, the function name
{                 #+ starts with an underscore.
  local cur
  # Pointer to current completion word.
  # By convention, it's named "cur" but this isn't strictly necessary.

  COMPREPLY=()   # Array variable storing the possible completions.
  cur=${COMP_WORDS[COMP_CWORD]}

  case "$cur" in
    -*) # Specify all the options
    COMPREPLY=( $( compgen -W '-b --build  --build-all  -bnc --build-no-cache \
        -s --start  --start-jnkns  --start-all  --exec  -t --stop  --stop-all \
        --kill  --kill-all  --restart  --inspect  --clear-containers --' -- $cur ) );;
    *) # Reads the files in the directory
    COMPREPLY=( $( compgen -W '$(ls)' -- $cur ) );;
  esac

  return 0
}

complete -F _new-manager -o filenames ./new-manager.sh
#        ^^ ^^^^^^^^^^^^  Invokes the function _new-manager.

# Args from the command line
ARG1=$1
# wc $ARG1

# NET related vars
NET_NAME=mysql-db-net
SUBNET_MASK=172.18.0.0/16
MYSQL_IP=172.18.0.2
DEB_IP=172.18.0.3
JNKNS_IP=172.18.0.4

# MySQL vars
MYSQL_CONTAINER=mysql-db

#Debian+JDK8+MVN+GIT+CDB vars
DEB_CONTAINER=jdk8-mvn-cdb
MVN_REPO=/home/excilys/.m2/repository:/root/.m2/repository

# Jekins container
JNKNS_CONTAINER=jnkns-cdb
DOCKER_BIN=$(which docker):/usr/bin/docker

CONTAINERS=($MYSQL_CONTAINER $DEB_CONTAINER $JNKNS_CONTAINER)

function build {
    DOCKER_TARGET=$1
    cd $DOCKER_TARGET && docker build -t $DOCKER_TARGET .
    cd ..
}


function build-all {
    for i in ${CONTAINERS[@]}
    do
        build $i
    done
}

function build-no-cache {
    DOCKER_TARGET=$1
    cd $DOCKER_TARGET && docker build --no-cache -t $DOCKER_TARGET .
}

function start {
    DOCKER_TARGET=$1
    docker start $DOCKER_TARGET
}

function start-jnkns {
    docker network create --subnet=$SUBNET_MASK  $NET_NAME
    docker run -dit -v $DOCKER_BIN --name $JNKNS_CONTAINER --net=$NET_NAME --ip=$JNKNS_IP $JNKNS_CONTAINER
}

function start-all {
    # Create newtork
    docker network create --subnet=$SUBNET_MASK  $NET_NAME
    
    # Start jenkins container
    docker run -dit -v $DOCKER_BIN --name $JNKNS_CONTAINER --net=$NET_NAME --ip=$JNKNS_IP

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
    DOCKER_TARGET=$1
    # Stop running container
    docker stop $DOCKER_TARGET
    # Remove docker images
    docker rm $DOCKER_TARGET
}

function stop-all {
    for i in ${CONTAINERS[@]}
    do 
        stop $i
    done
}

function kill {
    # Remove network
    docker network rm $NET_NAME
}

function kill-all {
    for i in ${CONTAINERS[@]}
    do
        stop $i
    done

    # Remove network
    docker network rm $NET_NAME
}

function inspect {
    docker network inspect $NET_NAME
}

function clear-containers {
    docker rm $(docker ps -aq)
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
    --build-all)
        build-all
        shift # past argument=value
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
    --start-jnkns)
        start-jnkns
        shift # past argument=value
        ;;
    --start-all)
        start-all
        shift # past argument=value
        ;;
    --exec)
        exec
        shift # past argument=value
        ;;
    -t|--stop)
        stop "$2"
        shift # past argument=value
        ;;
    --stop-all)
        stop-all
        shift # past argument=value
        ;;
    --kill)
        kill "$2"
        shift # past argument=value
        ;;
    --kill-all)
        kill-all
        shift # past argument=value
        ;;
    --restart)
        stop
        start
        ;;
    --inspect)
        inspect
        ;;
    --clear-containers)
        clear-containers
        ;;
    *)
        echo $"Usage: $0 {start|exec|stop|kill|restart|inspect|build|build-no-cache}"
        exit 1
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters
