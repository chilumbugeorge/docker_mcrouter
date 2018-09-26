#!/bin/bash
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

printf "\n"
declare -A containers

while IFS== read -r key value; do
    containers[$key]=${value}
    CS=$(docker exec -t $key ps -ef |grep consul);
    if [[ "$CS" != "" ]]; then
        echo -e $key ": Consul is ${GREEN}already running${NC}"
    else
       echo -e "${BLUE}MANUALLY hit CTL C ${NC}and run this script again til you cannot enter CTL C anymore."
        X=$(uuidgen | awk '{print tolower($0)}')
        nodeid_update=$(docker exec -t $key sed -i -e 's/00000000-0000-0000-000-00000000/'$X'/g' /etc/init/consul.conf);
        ip_update=$(docker exec -t $key sed -i -e 's/ip_address/'${value//[[:blank:]]/}'/g' /etc/init/consul.conf);
        C=$(docker exec -t $key consul agent -node-id $X -config-dir /etc/consul.d/ -bind ${value} &)
        CP=$(docker exec -t $key ps -ef |grep consul);
        echo $key
        echo ${GREEN}$CP${NC};
        printf "\n"
    fi
done < "/opt/docker_mcrouter/scripts/mcrouter_system_upgrade/containers.txt"
exit
