#!/bin/bash
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${RED}MANUALLY hit CTL C ${NC}and run this script again til you cannot enter CTL C anymore."

declare -A containers

while IFS== read -r key value; do
    containers[$key]=${value}
    cmd="/usr/bin/mcrouter --debug-fifo-root /var/lib/mcrouter/fifos --stats-root /var/lib/mcrouter/stats -L /var/log/mcrouter/mcrouter.log -p -f /etc/mcrouter.conf -f /etc/mcrouter.conf -L /var/log/mcrouter/mcrouter.log -p 5000 --send-invalid-route-to-default --file-observer-poll-period-ms=1000 --file-observer-sleep-before-update-ms=100 &"
    S=$(sudo docker exec -t $key sysctl net.core.somaxconn);
    RS=$(sudo docker exec -t $key service rsyslog start);
    M=$(sudo docker exec -t $key $cmd);
    RSPS=$(sudo docker exec -t $key ps -ef |grep rsyslog);
    MPS=$(sudo docker exec -t $key ps -ef |grep mcrouter);

    echo $key ":" $RSPS;
    echo $key ":" $MPS;
    printf "\n"
    for i in {5..0}; do echo -ne "$i"'\r'; sleep 1; done; echo 
    echo -e "${RED}MANUALLY hit CTL C ${NC}and run this script again til you cannot enter CTL C anymore."
done < "/opt/Docker_mcrouter/upgrade/containers.txt"
