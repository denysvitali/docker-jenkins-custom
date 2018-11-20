FROM jenkins/jenkins:latest
ARG DOCKER_GROUP_ID
MAINTAINER Denys Vitali <denys@denv.it>

USER root

RUN apt update && apt install -y ca-certificates apt-transport-https gnupg2 sudo
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" > /etc/apt/sources.list.d/docker-ce.list
RUN apt update && apt install -y docker-ce
RUN usermod -a -G docker jenkins

RUN groupmod -g $DOCKER_GROUP_ID docker 

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod u+x /usr/local/bin/entrypoint.sh
USER jenkins
ENTRYPOINT [ "bash", "/usr/local/bin/entrypoint.sh" ]
