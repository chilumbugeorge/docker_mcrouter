#!/bin/bash
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

declare -A containers

# Stop consul on all containers gracefully before shutting down other services.
while IFS== read -r key value; do
    containers[$key]=${value}
    CS=$(docker exec -t $key ps -ef |grep consul);
    if [[ "$CS" != "" ]]; then
        stop_consul=$(docker exec -t $key consul leave);
        echo $key ":" $stop_consul
    else
        echo "Container $key does not seem to have Consul running"
    fi
done < "/opt/docker_mcrouter/scripts/mcrouter_system_upgrade/containers.txt"
printf "\n"
echo -e "${BLUE}Please wait for sessions in redis to complete after stopping consul... ${NC}"
printf "\n"
sleep 5

while IFS== read -r key value; do
    containers[$key]=${value}
    mcrouter_status=$(docker exec -t $key ps -ef |grep mcrouter);
    if [[ "$mcrouter_status" != "" ]]; then
        stop_mcrouter=$(docker exec -t $key pkill mcrouter);
        echo $key ":" $stop_mcrouter "Redis Server Stopped."
    else
        echo "Container $key does not seem to have mcrouter running"
    fi
    printf "\n"
done < "/opt/docker_mcrouter/scripts/mcrouter_system_upgrade/containers.txt"
exit
