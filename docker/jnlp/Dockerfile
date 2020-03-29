FROM arecker/jenkins-agent:latest
MAINTAINER Alex Recker <alex@reckerfamily.com>
USER root
ADD https://raw.githubusercontent.com/jenkinsci/docker-jnlp-slave/master/jenkins-agent /usr/local/bin/
RUN chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave
USER jenkins

ENTRYPOINT ["jenkins-slave"]
