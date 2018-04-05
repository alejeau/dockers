FROM jenkins/jenkins:lts

MAINTAINER Aurélien LEJEAU (alejeau@excilys.com)


USER root
RUN apt-get update \
      && apt-get install -y sudo \
      && apt-get install -y libltdl7 \
      && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins

COPY config/computer-database.xml $JENKINS_HOME/jobs/computer-database/config.xml

# Install plugins in Jenkins
COPY config/plugin-list.txt /usr/share/jenkins/ref/plugin-list.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugin-list.txt

COPY computer-database /home/computer-database
