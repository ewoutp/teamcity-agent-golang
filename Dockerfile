FROM dockerfile/java

RUN   \
  apt-get update && \
  apt-get install -qqy git build-essential curl wget unzip apt-transport-https ca-certificates lxc iptables && \
  rm -rf /var/lib/apt/lists/*

RUN curl -o /usr/local/go1.4.1.linux-amd64.tar.gz https://storage.googleapis.com/golang/go1.4.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf /usr/local/go1.4.1.linux-amd64.tar.gz
RUN cd /usr/local/bin && ln -s /usr/local/go/bin/go

RUN curl -o /usr/local/bin/wrapdocker https://raw.githubusercontent.com/jpetazzo/dind/master/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

RUN curl -sSL https://get.docker.com/ubuntu/ | sh

VOLUME /var/lib/docker

ADD setup-agent.sh /setup-agent.sh

RUN adduser --quiet teamcity
RUN mkdir -p /agent
RUN chown teamcity.teamcity /agent

EXPOSE 9090
CMD TEAMCITY_SERVER=$TEAMCITY_SERVER bash /setup-agent.sh run

