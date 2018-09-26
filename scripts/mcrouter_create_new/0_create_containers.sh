#!/bin/bash
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

declare -A containers

while IFS== read -r key value; do
    containers[$key]=${value}
    name=${key::-2}
    CS=$(docker ps -a |grep $key);
    if [[ "$CS" != "" ]]; then
        echo -e "Container $key ${GREEN}Already exists${NC}"
        exit 2
    else
        cont_create=$(docker run -td -i -d -v /srv/${key//[[:blank:]]/}:/opt/mcrouter -v /proc:/writable-proc --sysctl net.core.somaxconn=4096 --hostname $key --name $key mcrouter:0.36 bash);
        ip_bind=$(pipework enp2s0f0 $key ${value//[[:blank:]]/}/24@10.1.24.254);
        cp_config=$(docker cp /opt/docker_mcrouter/mcrouter/${name//[[:blank:]]/}".conf" ${key//[[:blank:]]/}:/etc/mcrouter.conf);
        name_update=$(docker exec -t $key sed -i -e 's/mcrouter-name/'${name//[[:blank:]]/}'/g' /etc/consul.d/services.json);
        echo $key "Container created:" $cp_config
        echo $key "bound to" ${value//[[:blank:]]/}/24@10.1.24.254
        echo $key ":Consul Service updates appropriately"
    fi
done < "/opt/docker_mcrouter/scripts/mcrouter_create_new/containers.txt"
exit
