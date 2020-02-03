#!/usr/bin/env bash

# set -e

read -r -d '' REQUIRED_ENVIRONMENT_VARIABLES <<'EOF'
VAULT_ADDR
EOF

log() {
    echo "SECRETBOI: $1"
}

missing_required_environment_variables() {
    log "LETS SEE IF YOU HAVE THE REQUIRED ENVIRONMENT VARIABLES SET"
    local status=1

    for var in $REQUIRED_ENVIRONMENT_VARIABLES; do
	log "CHECKING IF $var IS SET..."
	val="${!var}"
	if [ -z "$val" ]; then
	    log "OOPS, YOU FORGOT TO SET ${var}!  I NEED THAT!"
	    status=0
	else
	    log "$var IS SET TO \"$val\", GOOD JOB!"
	fi
    done

    return $status
}

if missing_required_environment_variables; then
    log "I DON'T HAVE ALL THE ENVIRONMENT VARIABLES I NEED, EXITING!"
else
    log "REQUIRED ENVIRONMENT VARIABLES ARE GOOD TO GO!"
fi
