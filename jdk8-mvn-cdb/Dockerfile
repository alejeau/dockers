# Install debian 9.4
FROM debian:stretch

# Installs JAVA 8, maven and git
RUN apt update \
	&& apt install -y apt-utils \
	&& apt upgrade -y \
	&& apt install -y openjdk-8-jdk \
	&& apt install -y maven \
	&& apt install -y git

# sets USER as ROOT
USER root

# Copy the test shell
COPY exec/git-and-test.sh /home/git-and-test.sh

# Runs the test shell
RUN chmod +x /home/git-and-test.sh
