FROM jenkins/jenkins:lts
MAINTAINER Denys Vitali <denys@denv.it>

USER root

RUN apt update && apt install -y ca-certificates apt-transport-https gnupg2 sudo
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" > /etc/apt/sources.list.d/docker-ce.list
RUN apt update && apt install -y openjfx maven docker-ce
RUN wget -O /tmp/jdk-11_linux-x64_bin.deb --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  http://download.oracle.com/otn-pub/java/jdk/11.0.1+13/90cf5d8f270a4347a95050320eef3fb7/jdk-11.0.1_linux-x64_bin.deb
RUN dpkg -i /tmp/jdk-11_linux-x64_bin.deb
RUN touch /usr/lib/jvm/.jdk-11.0.1.jinfo
RUN rm /tmp/jdk-11_linux-x64_bin.deb
RUN rm /usr/bin/java
RUN ln -s /usr/lib/jvm/jdk-11.0.1/bin/java /usr/bin/java
RUN java -version
RUN usermod -a -G docker jenkins

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod u+x /usr/local/bin/entrypoint.sh
USER jenkins
ENTRYPOINT [ "bash", "/usr/local/bin/entrypoint.sh" ]
