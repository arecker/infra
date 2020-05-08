FROM debian:buster-slim
MAINTAINER Alex Recker <alex@reckerfamily.com>

RUN apt update && \
	apt install -y curl && \
	curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
	chmod +x ./kubectl && \
	mv ./kubectl /usr/local/bin/kubectl

ADD run.bash /usr/local/bin/run.bash

ENTRYPOINT ["/usr/local/bin/run.bash"]
