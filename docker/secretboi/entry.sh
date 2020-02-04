#!/usr/bin/env bash

set -e

read -r -d '' REQUIRED_ENVIRONMENT_VARIABLES <<'EOF'
VAULT_ADDR
VAULT_ROLE
EOF

K8S_TOKEN_PATH="${K8S_TOKEN_PATH:-/var/run/secrets/kubernetes.io/serviceaccount/token}"
SECRETBOI_DIRECTORY="${SECRETBOI_DIRECTORY:-/secretboi}"

log() {
    echo "SECRETBOI: $1"
}

required_env_vars_populated() {
    log "LETS SEE IF YOU HAVE THE REQUIRED ENVIRONMENT VARIABLES SET"
    local status="good"

    for var in $REQUIRED_ENVIRONMENT_VARIABLES; do
	log "CHECKING IF $var IS SET..."
	val="${!var}"
	if [ -z "$val" ]; then
	    log "OOPS, YOU FORGOT TO SET ${var}!  I NEED THAT!"
	    status="bad"
	else
	    log "$var IS SET TO \"$val\", GOOD JOB!"
	fi
    done

    [ "$status" == "good" ]
}

k8s_token_exists() {
    log "GREAT NOW LETS SEE IF THE K8S TOKEN EXISTS"
    log "CHECKING: $K8S_TOKEN_PATH"
    [ -f "$K8S_TOKEN_PATH" ]
}

secretboi_directory_exists() {
    log "GREAT NOW LETS SEE IF MY DIRECTORY EXISTS"
    log "CHECKING: $SECRETBOI_DIRECTORY"
    [ -d "$SECRETBOI_DIRECTORY" ]
}

k8s_token() {
    cat "$K8S_TOKEN_PATH" | tr -d '\n'
}

log "OOOO WEEEE HERE WE GO LETS GET SOME SECRETS!"

if required_env_vars_populated; then
    log "REQUIRED ENVIRONMENT VARIABLES ARE GOOD TO GO!"
else
    log "I DON'T HAVE ALL THE ENVIRONMENT VARIABLES I NEED, EXITING!"
    exit 1
fi

if k8s_token_exists; then
    log "EXCELLENT, I FOUND THE K8S TOKEN!"
    log "IT'S AT $K8S_TOKEN_PATH"
else
    log "WHERE IS THE K8S TOKEN?"
    log "I THOUGHT IT WOULD BE AT $K8S_TOKEN_PATH"
    log "NOW I HAVE TO EXIT, GOODBYE CRUEL WORLD"
    exit 1
fi

if secretboi_directory_exists; then
    log "EXCELLENT, I FOUND MY DIRECTORY!"
    log "IT'S AT $SECRETBOI_DIRECTORY"
else
    log "WHERE IS MY DIRECTORY?"
    log "I THOUGHT IT WOULD BE AT $SECRETBOI_DIRECTORY"
    log "OH WHAT'S THE POINT?  I MIGHT AS WELL EXIT!"
    exit 1
fi

log "OK ON TO THE REAL STUFF"
log "BUILDING THE PAYLOAD FOR LOGGING INTO VAULT AS ROLE \"$VAULT_ROLE\""
PAYLOAD="{\"role\": \"$VAULT_ROLE\", \"jwt\": \"$(k8s_token)\"}"
log "OK SENDING ALL THIS TO VAULT, LET'S HOPE IT WORKS"
LOGIN_RESPONSE="$(echo "$PAYLOAD" | curl -s --request POST -d @- $VAULT_ADDR/v1/auth/kubernetes/login)"
log "WE GOT SOMETHING BACK - IT MIGHT BE SHIT, BUT IT MIGHT BE A TOKEN."
TOKEN="$(echo $LOGIN_RESPONSE | jq -r '.auth.client_token')"
if [ "$TOKEN" == "null" ]; then
    log "AH SHIT IT DIDN'T WORK.  THIS IS WHAT IT SAID:"
    log "$LOGIN_RESPONSE"
    exit 1
else
    log "OH MY GOD IT WORKED I HAVE A VAULT TOKEN"
fi

log "WRITING THE TOKEN TO $SECRETBOI_DIRECTORY/token"
echo -n "$TOKEN" > "$SECRETBOI_DIRECTORY/token"
