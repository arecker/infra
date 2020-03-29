FROM arecker/jenkins-agent:latest
MAINTAINER Alex Recker <alex@reckerfamily.com>
USER root
ADD https://raw.githubusercontent.com/jenkinsci/docker-jnlp-slave/master/jenkins-agent /usr/local/bin/
RUN chmod +x /usr/local/bin/jenkins-agent
RUN cp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave

RUN apk add --update-cache git

USER jenkins
ENTRYPOINT ["jenkins-slave"]
