#!/usr/bin/env bash

log() {
    echo "manifestor: $1" 1>&2;
}

log "using kubectl $(kubectl version --short=true | head -1 | awk '{ print $3 }')"

kubectl apply -f "$MANIFEST_URL"
