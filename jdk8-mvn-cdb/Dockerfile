# Install debian 9.4
FROM debian:stretch

RUN apt update \
	&& apt install -y apt-utils \
	&& apt upgrade -y \
	&& apt install -y openjdk-8-jdk \
	&& apt install -y maven \
	&& apt install -y git

RUN git clone https://github.com/alejeau/computer-database.git

RUN cd computer-database \
        && git checkout dev \ 
        && mvn clean install

