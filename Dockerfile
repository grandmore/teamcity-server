# Dockerfile to build TeamCity server container images.
# Based on Debian.

# sudo docker run -dt --name teamcity_server -p 8111:8111 stuartfenton/teamcity-server
# sudo docker run -v /home-teamcity:/home-teamcity -p 8111:8111 --name="teamcity-server" --restart=always -d stuartfenton/teamcity-server 

FROM stuartfenton/base
MAINTAINER Stuart Fenton "stuart@overlima.com"

ENV TC_VERSION 9.0.2

VOLUME ["/home-teamcity"]

ENV TEAMCITY_DATA_PATH /home-teamcity

#install needed library for add-apt-repository to work
RUN eatmydata -- apt-get install -yq software-properties-common python-software-properties python3-software-properties && add-apt-repository ppa:webupd8team/java -y && apt-get update

# Install Oracle Java 7
RUN eatmydata -- apt-get install -yq software-properties-common && add-apt-repository ppa:webupd8team/java -y
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN eatmydata -- apt-get install -yq oracle-java7-installer


# This will use the 1.3.2 release
#RUN wget -O /usr/local/bin/docker https://get.docker.io/builds/Linux/x86_64/docker-1.3.2
# This will use the 1.4.1 release
RUN wget -O /usr/local/bin/docker https://get.docker.io/builds/Linux/x86_64/docker-1.4.1
RUN chmod +x /usr/local/bin/docker
ADD 10_wrapdocker.sh /etc/my_init.d/10_wrapdocker.sh
RUN groupadd docker


# install zip
RUN eatmydata -- apt-get install -yq zip

# install php5
RUN eatmydata -- apt-get install -yq php5
RUN eatmydata -- apt-get install -yq php5-curl

# install Phpunit
RUN wget https://phar.phpunit.de/phpunit.phar
RUN chmod +x phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit

# install Phing
RUN wget http://www.phing.info/get/phing-latest.phar
RUN chmod +x phing-latest.phar
RUN mv phing-latest.phar /usr/local/bin/phing-latest.phar

#add symbolic link
RUN mkdir /usr/local/phing-symbolic
RUN mkdir /usr/local/phing-symbolic/bin
RUN ln -s /usr/local/bin/phing-latest.phar /usr/local/phing-symbolic/bin/ant

# install Apache Ant
RUN eatmydata -- apt-get install -yq ant

# install Node & npm
RUN eatmydata -- apt-add-repository ppa:chris-lea/node.js
RUN eatmydata -- apt-get install -yq nodejs npm
RUN eatmydata -- npm install -g grunt-cli

#install mercurial 3.2.x
RUN eatmydata -- apt-get install -yq python-dev python3-dev python3-setuptools python-docutils python3-docutils
RUN wget http://mercurial.selenic.com/release/mercurial-3.2.4.tar.gz
RUN cd /; tar -zxf mercurial-3.2.4.tar.gz
RUN cd mercurial-3.2.4; make build PYTHON=python; make install;

#install ssh client
RUN eatmydata -- apt-get install -yq ssh-askpass-gnome ssh-askpass

RUN	apt-get install -y wget default-jre && rm -rf /var/lib/apt/lists/*

RUN wget -qO- http://download.jetbrains.com/teamcity/TeamCity-$TC_VERSION.tar.gz | tar xz -C /opt


EXPOSE 8111
CMD ["/opt/TeamCity/bin/teamcity-server.sh", "run"]
