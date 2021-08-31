#!/usr/bin/env bash

set -e

BIRTHDAY_WEBHOOK="${BIRTHDAY_WEBHOOK:-}"

BIRTHDAY_LINK="${BIRTHDAY_LINK:-https://youtu.be/Y6JnYnA9Tzo}"
BIRTHDAY_NAME="${BIRTHDAY_NAME:-Joey Bag-o-Donuts}"
BIRTHDAY_CHANNEL="${BIRTHDAY_CHANNEL:-#birthdays}"
BIRTHDAY_BOT_NAME="${BIRTHDAY_BOT_NAME:-reckerbot}"
BIRTHDAY_BOT_ICON="${BIRTHDAY_BOT_ICON:-:reckerbot:}"

log() {
    echo "birthday.sh: $1" 1>&2
}

validate() {
    local return=0

    log "validating dependencies"
    if ! which curl > /dev/null 2>&1; then log 'curl is not in $PATH'; return=1; fi

    log "validating environment variables"
    if [ "$BIRTHDAY_WEBHOOK" == "" ]; then log '$BIRTHDAY_WEBHOOK is not set!'; return=1; fi

    return $return
}

payload() {
    cat <<EOF
{
  "username": "$BIRTHDAY_BOT_NAME",
  "icon_emoji": "$BIRTHDAY_BOT_ICON",
  "text": "Happy birthday, ${BIRTHDAY_NAME}!\n${BIRTHDAY_LINK}",
  "channel": "$BIRTHDAY_CHANNEL"
}
EOF
}

validate || exit 1

log "posting payload to $BIRTHDAY_CHANNEL"
curl \
    -H 'Content-type: application/json' \
    -X POST \
    -d "$(payload)" \
    "$BIRTHDAY_WEBHOOK"
