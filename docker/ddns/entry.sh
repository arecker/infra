#!/usr/bin/env bash

set -e

ZONEID="ZONEID123"
"${ZONEID:?ZONEID not set or empty}"

RECORDSET="something.com"
"${RECORDSET:?RECORDSET not set or empty}"

TTL="${TTL:=300}"
TYPE="${TYPE:=A}"

COMMENT="ddns @ `date`"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
IPFILE="$DIR/update-route53.ip"
IP=`dig +short myip.opendns.com @resolver1.opendns.com`

log() {
    echo "entry.sh: $1"
}

valid_ip() {
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

if ! valid_ip $IP; then
    log "Invalid IP address: $IP"
    exit 1
else
    log "IP address $IP valid"
fi

if [ ! -f "$IPFILE" ]; then
    log "Creating $IPFILE"
    touch "$IPFILE"
fi

if grep -Fxq "$IP" "$IPFILE"; then
    log "IP is still $IP. Exiting"
    exit 0
else
    log "IP has changed to $IP"
    TMPFILE="$(mktemp ${DIR}/ddns-tmp.XXXXXXXX)"
    cat > ${TMPFILE} << EOF
    {
      "Comment":"$COMMENT",
      "Changes":[
        {
          "Action":"UPSERT",
          "ResourceRecordSet":{
            "ResourceRecords":[
              {
                "Value":"$IP"
              }
            ],
            "Name":"$RECORDSET",
            "Type":"$TYPE",
            "TTL":$TTL
          }
        }
      ]
    }
EOF

    aws route53 change-resource-record-sets \
        --hosted-zone-id "$ZONEID" \
        --change-batch file://"$TMPFILE"
    log "IP Changed in Route53"

    log "Removing $TMPFILE"
    rm $TMPFILE
fi

log "Caching IP in $IPFILE"
echo "$IP" > "$IPFILE"
