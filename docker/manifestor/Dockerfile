FROM alpine:latest
MAINTAINER Alex Recker <alex@reckerfamily.com>

ARG KUBECTL_VERSION="v1.18.2"
ARG KUBECTL_ARCH="arm"

RUN apk --update add bash curl

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl && \
    chmod +x kubectl && mv kubectl /usr/local/bin/kubectl

ADD run.bash /usr/local/bin/run.bash

ENTRYPOINT ["/usr/local/bin/run.bash"]
