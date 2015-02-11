# Dockerfile to build TeamCity server container images.
# Based on Debian.

# sudo docker run -dt --name teamcity_server -p 8111:8111 stuartfenton/teamcity-server

FROM debian:wheezy
ENV TC_VERSION 9.0.2

VOLUME ["/home-teamcity"]

ENV TEAMCITY_DATA_PATH /home-teamcity

RUN	apt-get update && \
        apt-get install -y wget default-jre && \
        rm -rf /var/lib/apt/lists/*

RUN wget -qO- http://download.jetbrains.com/teamcity/TeamCity-$TC_VERSION.tar.gz | tar xz -C /opt

EXPOSE 8111
CMD ["/opt/TeamCity/bin/teamcity-server.sh", "run"]
