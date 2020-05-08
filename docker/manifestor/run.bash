#!/usr/bin/env bash

log() {
    echo "manifestor: $1" 1>&2;
}

while true; do
    log "sleeping"
    sleep 1
done
