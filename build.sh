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
    *)
	log "command $1 not known!"
	exit 1
esac

log "finished!"
