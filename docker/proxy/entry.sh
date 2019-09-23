#!/usr/bin/env bash

set -e

log() {
    echo "entry.sh: $1"
}

log "validating environment variables"
if [[ -z "$UPSTREAM_DNS" ]]; then
    echo "UPSTREAM_DNS not set" 1>&2
    exit 1
fi

if [[ -z "$UPSTREAM_HOSTNAME" ]]; then
    echo "UPSTREAM_HOSTNAME not set" 1>&2
    exit 1
fi

log "subbing {{UPSTREAM_HOSTNAME}} with \"$UPSTREAM_HOSTNAME\""
sed -i "s/{{UPSTREAM_HOSTNAME}}/$UPSTREAM_HOSTNAME/g" /etc/nginx/nginx.conf

log "subbing {{UPSTREAM_DNS}} with \"$UPSTREAM_DNS\""
sed -i "s/{{UPSTREAM_DNS}}/$UPSTREAM_DNS/g" /etc/nginx/nginx.conf

log "validating nginx config"
nginx -t

log "starting nginx"
nginx -g "daemon off;"

