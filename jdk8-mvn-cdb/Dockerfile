# Install debian 9.4
FROM debian:stretch

RUN apt update \
	&& apt install -y apt-utils \
	&& apt upgrade -y \
	&& apt install -y openjdk-8-jdk \
	&& apt install -y maven \
	&& apt install -y git

USER root

COPY config-files/git-and-test.sh /home/git-and-test.sh
COPY config-files/db.properties /home/db.properties


RUN chmod +x /home/git-and-test.sh
