#
# Bluefairy Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:14.04
MAINTAINER moremagic<itoumagic@gmail.com>

RUN apt-get update && apt-get upgrade -y && apt-get clean

# ssh install
RUN apt-get update && apt-get install -y openssh-server openssh-client && apt-get clean
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Java install
RUN apt-get install -q -y openjdk-7-jre-headless openjdk-7-jdk && apt-get clean
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/
ENV PATH $JAVA_HOME/bin:$PATH

# Maven + Git install
RUN apt-get -y install maven && apt-get -y install git

# bluefariy install
RUN git clone https://github.com/Yoichi-KIKUCHI/bluefairy.git
RUN cd /bluefairy && mvn package spring-boot:repackage

EXPOSE 22 8080
CMD /usr/sbin/sshd -D -e;
