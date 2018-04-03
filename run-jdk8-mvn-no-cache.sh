DOCKER_TARGET=jdk8-mvn
cd $DOCKER_TARGET && docker build --no-cache -t $DOCKER_TARGET .

