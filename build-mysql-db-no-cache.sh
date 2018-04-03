DOCKER_TARGET=mysql-db
cd $DOCKER_TARGET && docker build --no-cache -t $DOCKER_TARGET .

