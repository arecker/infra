#!/usr/bin/env bash

set -e

log() {
    echo "build.sh: $1"
}

_cd() {
    cd "$1"
    log "cd $(pwd)"
}

case "$1" in
    "terraform")
	log "building terraform"
	_cd "terraform"
	log "running terraform init"
	terraform init
	log "running terraform apply"
	terraform apply -auto-approve
	;;
    "docker")
	log "building docker"
	_cd "docker"
	log "running docker-compose build"
	docker-compose build
	log "running docker-compose push"
	docker-compose push
	;;
    "install-terraform")
	log "installing terraform"
	log "creating local bin"
	mkdir -p ~/.local/bin
	TF_VERSION="$(cat ./terraform/.terraform-version)"
	log "using terraform version $TF_VERSION"
	URL_BASE="https://releases.hashicorp.com"
	URL="$URL_BASE/terraform/${TF_VERSION}/terraform_{$TF_VERSION}_linux_amd64.zip"
	log "downloading $URL"
	curl -sLo /tmp/terraform.zip "$URL"
	log "unpacking $HOME/.local/bin/terraform"
	unzip /tmp/terraform.zip -d ~/.local/bin/
	;;
    *)
	log "command $1 not known!"
	exit 1
esac

log "finished!"
