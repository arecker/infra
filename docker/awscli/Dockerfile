FROM python:alpine
MAINTAINER Alex Recker <alex@reckerfamily.com>

ARG CLI_VERSION=1.16.140

RUN apk -uv add --no-cache groff jq less && \
	pip install --no-cache-dir awscli==$CLI_VERSION

WORKDIR /root

CMD sh
