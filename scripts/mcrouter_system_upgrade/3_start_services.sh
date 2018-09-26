#!/bin/bash
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

declare -A containers

while IFS== read -r key value; do
    containers[$key]=${value}
    mc_status=$(docker exec -t $key ps -ef |grep mcrouter);
    if [[ "$mc_status" != "" ]]; then
        echo -e " mcrouter $key is ${GREEN}already running${NC}"
    else   
        echo -e "${BLUE}MANUALLY hit CTL C ${NC}and run this script again til you cannot enter CTL C anymore."
        cmd="/usr/bin/mcrouter --debug-fifo-root /var/lib/mcrouter/fifos --stats-root /var/lib/mcrouter/stats -L /var/log/mcrouter/mcrouter.log -p -f /etc/mcrouter.conf -f /etc/mcrouter.conf -L /var/log/mcrouter/mcrouter.log -p 5000 --send-invalid-route-to-default --disable-miss-on-get-errors --file-observer-poll-period-ms=1000 --file-observer-sleep-before-update-ms=100"
        S=$(docker exec -t $key sysctl net.core.somaxconn);
        RS=$(docker exec -t $key service rsyslog start);
        M=$(docker exec -t $key $cmd);
        RSPS=$(docker exec -t $key ps -ef |grep rsyslog);
        MPS=$(docker exec -t $key ps -ef |grep mcrouter);
        echo $key ":" $RSPS;
        echo $key ":" $MPS;
        printf "\n"
        echo "Please wait a few seconds ..."
        for i in {5..0}; do echo -ne "$i"'\r'; sleep 1; done; echo 
    fi
done < "/opt/docker_mcrouter/scripts/mcrouter_system_upgrade/containers.txt"
